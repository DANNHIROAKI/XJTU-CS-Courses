from collections import defaultdict
import itertools
from random import Random
import sys
import traceback

import os
dir_path = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, os.path.join(dir_path, "lib"))

import networkx as nx

import sim.api as api
from sim.basics import Ping
import sim.cable

from dv_comprehensive_test_utils import all_hosts, all_cables


def pick_action(g, rand):
    """Randomly picks a valid action (add / remove link)."""
    actions = []
    # We can remove any edge as long as the removal doesn't cause a partition.
    actions.extend(("del", u, v) for u, v in set(g.edges) - set(nx.bridges(g)))
    # We can add any router-to-router edge that doesn't exist yet.
    # Hosts are ignored since we can't connect a host to multiple routers.
    actions.extend(
        ("add", u, v) for u, v in nx.non_edges(g)
        if (not isinstance(g.nodes[u]["entity"], api.HostEntity) and
            not isinstance(g.nodes[v]["entity"], api.HostEntity))
    )
    actions.sort(key=lambda a: (a[0], g.nodes[a[1]]["entity"].name,
        g.nodes[a[2]]["entity"].name))
    return rand.choice(actions)


def launch(seed=None):
    # Seed the RNG.
    rand = Random()
    if seed is not None:
        rand.seed(float(seed))

    sim.config.default_switch_type.POISON_REVERSE = True
    sim.config.default_switch_type.POISON_EXPIRED = True
    sim.config.default_switch_type.SPLIT_HORIZON = False
    sim.config.default_switch_type.POISON_ON_LINK_DOWN = True
    sim.config.default_switch_type.SEND_ON_LINK_UP = True

    # Make sure that each cable has a transmission time of zero.
    for c in all_cables:
        assert c.tx_time == 0, "BUG: cable {} has non-zero transmission time {}".format(c, c.tx_time)

    def comprehensive_test_tasklet():
        """Comprehensive test."""
        successes = 0

        try:
            yield 0

            g = nx.Graph()  # Construct a graph for the current topology.
            for c in sorted(all_cables, key=lambda x: (x.src.entity.name, x.dst.entity.name)):
                assert c.src, "cable {} has no source".format(c)
                assert c.dst, "cable {} has no destination".format(c)

                g.add_node(c.src.entity.name, entity=c.src.entity)
                g.add_node(c.dst.entity.name, entity=c.dst.entity)

                g.add_edge(c.src.entity.name, c.dst.entity.name, latency=c.latency)

            initial_wait = 5 + nx.diameter(g)
            api.simlog.info("Waiting for at least %d seconds for initial routes to converge...", initial_wait)
            yield initial_wait * 1.1

            for round in itertools.count():
                api.simlog.info("=== Round %d ===", round+1)
                num_actions = rand.randint(1, 3)
                for i in range(num_actions):
                    yield rand.random() * 2  # Wait 0 to 2 seconds.
                    action, u, v = pick_action(g, rand)
                    if action == "del":
                        api.simlog.info("\tAction %d/%d: remove link %s -- %s" % (i+1, num_actions, u, v))
                        g.remove_edge(u, v)
                        g.nodes[u]["entity"].unlinkTo(g.nodes[v]["entity"])
                    elif action == "add":
                        api.simlog.info("\tAction %d/%d: add link %s -- %s" % (i+1, num_actions, u, v))
                        g.add_edge(u, v)
                        g.nodes[u]["entity"].linkTo(g.nodes[v]["entity"])
                    else:
                        assert False, "unknown action {}".format(action)

                # Wait for convergence.
                max_latency = nx.diameter(g) * 1.01
                yield max_latency

                # Send pair-wise pings.
                assert nx.is_connected(g), "BUG: network partition"
                expected = defaultdict(dict)  # dst -> src -> time
                deadline = defaultdict(dict)  # dst -> src -> time

                lengths = dict(nx.shortest_path_length(g))
                for s in sorted(all_hosts, key=lambda h: h.name):
                    for d in sorted(all_hosts, key=lambda h: h.name):
                        if s is d:
                            continue

                        s.ping(d, data=round)
                        latency = lengths[s.name][d.name]
                        deadline[d][s] = api.current_time() + latency
                        expected[d][s] = api.current_time() + latency * 1.01

                # Wait for ping to propagate.
                yield max_latency

                for dst in expected:
                    rxed = dst.rxed_pings
                    for src in set(expected[dst].keys()) | set(rxed.keys()):
                        if src not in rxed:
                            api.simlog.error("\tFAILED: Missing ping: %s -> %s", src, dst)
                            return

                        assert rxed[src]
                        rx_packets = [packet for packet, _ in rxed[src]]
                        if src not in expected[dst]:
                            api.simlog.error("\tFAILED: Extraneous ping(s): %s -> %s %s", src, dst, rx_packets)
                            return

                        if len(rx_packets) > 1:
                            api.simlog.error("\tFAILED: Duplicate ping(s): %s -> %s %s", src, dst, rx_packets)
                            return

                        rx_packet = rx_packets[0]
                        assert isinstance(rx_packet, Ping)
                        if rx_packet.data != round:
                            api.simlog.error("\tFAILED: Ping NOT from current round %d: %s -> %s %s", round, src, dst, rx_packet)
                            return

                        _, actual_time = rxed[src][0]
                        late = actual_time - expected[dst][src]
                        if late > 0:
                            api.simlog.error("\tFAILED: Ping late by %g sec: %s -> %s %s", actual_time - deadline[dst][src], src, dst, rx_packet)
                            return

                    dst.reset()

                api.simlog.info("\tSUCCESS!")
                successes += 1
        except Exception as e:
            api.simlog.error("Exception occurred: %s" % e)
            traceback.print_exc()
        finally:
            sys.exit()

    api.run_tasklet(comprehensive_test_tasklet)