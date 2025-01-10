from __future__ import print_function
import sys
import os
import random
import unittest
from contextlib import contextmanager
from collections import namedtuple
import argparse
from sim.api import HostEntity, Packet, get_name
from dv_router import DVRouter
from cs168.dv import RoutePacket, Table, TableEntry, DVRouterBase, FOREVER, INFINITY
dir_path = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, os.path.join(dir_path, "lib"))
from mock import patch



class Route(namedtuple("RouteAd", ["dst", "latency"])):
    """Helper class for checking route advertisements."""

    def __repr__(self):
        return "RouteAd(dst={}, latency={})".format(
            get_name(self.dst), self.latency
        )


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def assertItemsEqual(actual, expected, message):
    actual.sort()
    expected.sort()
    union = set(actual).union(set(expected))
    failure = False
    for item in union:
        if not item in expected:
            message += "\n"+"Extraneous Value: "+str(item)
            failure = True
    intersection = set(actual).intersection(set(expected))
    for item in expected:
        if not item in intersection:
            message += "\n"+"Missing Value: "+str(item)
            failure = True
    if failure:
        assert True == False, message

class DataPacket(Packet):
    """A packet with data."""

    def __init__(self, dst, src, name):
        super(DataPacket, self).__init__(dst=dst, src=src)
        self.name = name

    def __repr__(self):
        return "<Packet name=%s %s->%s>" % (
            self.name, get_name(self.src), get_name(self.dst)
        )


class TestDVRouterBase(unittest.TestCase):
    """Base class for DVRouter tests."""

    def _set_up(self, poison_reverse, poison_expired, poison_on_link_down, split_horizon, send_on_link_up, triggered=False):
        # Raise an error if time.time() is called.
        call_time_error = AssertionError(
            "DO NOT call time.time() for timestamps; "
            "call api.current_time() instead"
        )
        call_time_patcher = patch("time.time", side_effect=call_time_error)
        call_time_patcher.start()
        self.addCleanup(call_time_patcher.stop)

        # Simulate time.
        self._current_time = 50
        current_time_patch = patch("sim.api.current_time",
                                   side_effect=lambda: self._current_time)
        current_time_patch.start()
        self.addCleanup(current_time_patch.stop)

        DVRouter.POISON_REVERSE = poison_reverse
        DVRouter.POISON_EXPIRED = poison_expired
        DVRouter.POISON_ON_LINK_DOWN = poison_on_link_down
        DVRouter.SPLIT_HORIZON = split_horizon
        DVRouter.SEND_ON_LINK_UP = send_on_link_up
        #DVRouter.TRIGGERED = triggered
        DVRouter.DEFAULT_TIMER_INTERVAL = 5
        with patch("dv_router.DVRouter.start_timer") as start_timer:
            self.router = DVRouter()
        assert not (DVRouter.SPLIT_HORIZON and DVRouter.POISON_REVERSE), "Split horizon and poison reverse can't be on"
        start_timer.assert_called_once()  # Make sure start_timer is called.
        self.assertEqual(self.router.POISON_REVERSE, poison_reverse,
                         "POISON_REVERSE flag doesn't match")
        self.assertEqual(self.router.POISON_EXPIRED, poison_expired,
                         "POISON_EXPIRED flag doesn't match")
        self.assertEqual(self.router.POISON_ON_LINK_DOWN, poison_on_link_down,
                         "POISON_ON_LINK_DOWN flag doesn't match")
        self.assertEqual(self.router.SPLIT_HORIZON, split_horizon,
                         "SPLIT_HORIZON flag doesn't match")
        self.assertEqual(self.router.SEND_ON_LINK_UP, send_on_link_up,
                         "SEND_ON_LINK_UP flag doesn't match")

    def _set_current_time(self, new_time):
        """Sets current time.  Time must only go forward."""
        self.assertGreaterEqual(
            new_time, self._current_time,
            "BUG: turning time back from {} to {}".format(
                self._current_time, new_time)
        )
        self._current_time = new_time

    @contextmanager
    def _patch_send(self, all_ports):
        """
        Mock send function that captures all packets sent (for `self.router`).

        Yields a dict mapping port => list of packets sent to the port.

        :param all_ports: all ports that are up for the router.
        """
        # Type check and validate `all_ports`, just to be sure.
        _all_ports = set()
        for port in all_ports:
            self.assertIsInstance(port, int, "invalid port %d" % port)
            self.assertNotIn(port, _all_ports, "duplicate port %d" % port)
            _all_ports.add(port)
        del all_ports

        sent_packets = {port: [] for port in _all_ports}

        def _send(packet, port=None, flood=None):
            """Emulates `send`."""
            self.assertIsInstance(packet, Packet,
                                  "{} is not a Packet".format(packet))
            if packet.src is None:
                packet.src = self.router

            if port is None:
                ports = set()
            elif isinstance(port, int):
                ports = {port}
            else:
                # `port` had better be iterable.
                ports = set(port)
            del port

            if flood:
                # Take the inverse.
                ports = _all_ports - ports

            for port in ports:
                self.assertIn(port, sent_packets,
                              "invalid port number {}".format(port))
                sent_packets[port].append(packet)

        with patch.object(self.router, "send", side_effect=_send):
            yield sent_packets

    @contextmanager
    def _ensure_no_send(self, all_ports):
        """Ensures that no packet is sent."""
        with self._patch_send(all_ports) as sent_packets:
            yield

        for port, packets in sent_packets.items():
            self.assertListEqual(
                packets, [], "unexpected packet(s) sent to port {}: {}".format(
                    port, packets
                ))

    @contextmanager
    def _patch_send_routes(self, all_ports, allow_dup=False):
        """
        Mock send function that captures route advertisements sent.

        Yields a nested dict mapping port => dst => Route, denoting the
        route advertisement sent to port for destination dst.

        Fails if any packet sent is not a route advertisement.  Unless
        `allow_dup` is set, fails if duplicate route advertisements have
        been sent.

        Fails if multiple route ads are sent for the same destination.

        :param all_ports: all ports that are up for the router.
        """
        advertised_routes = {port: {} for port in all_ports}

        with self._patch_send(all_ports) as sent_packets:
            yield advertised_routes

        for port, packets in sent_packets.items():
            for packet in packets:
                self.assertIsInstance(
                    packet, RoutePacket,
                    "sent packet {} isn't route advertisement".format(packet)
                )

                dst, lat = packet.destination, packet.latency
                route = Route(dst, lat)
                old = advertised_routes[port].get(dst)
                if old is None:
                    advertised_routes[port][dst] = route
                else:
                    self.assertEqual(
                        old.dst, dst, "BUG: route ad dst differ"
                    )
                    self.assertEqual(
                        old, route,
                        "duplicate route advertisement for HOST {} sent to "
                        "PORT {} with different latency: old={} new={}".format(
                            get_name(dst), port, old.latency, lat
                        )
                    )
                    if not allow_dup:
                        self.fail(
                            "duplicate route advertisement for HOST {} sent "
                            "to PORT {} (latency={})".format(
                                get_name(dst), port, lat
                            )
                        )

    def _add_test_routes_raw(self):
        """
        Adds some simple test table entries.

        LINKS:             TABLE:
        +------+---------+ +------+------+---------+
        | Port | Latency | | Dest | Port | Latency |
        +------+---------+ +------+------+---------+
        |    1 |       5 | | h1   |    1 |       8 |
        |    2 |       1 | | h2   |    3 |       5 |
        |    3 |       3 | +------+------+---------+
        +------+---------+
        """
        h1 = _create_host("h1")
        h2 = _create_host("h2")
        self.h1 = h1
        self.h2 = h2

        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=2, latency=1)
        self.router.handle_link_up(port=3, latency=3)

        self.router.table.update({
            h1: TableEntry(dst=h1, port=1, latency=8, expire_time=115),
            h2: TableEntry(dst=h2, port=3, latency=5, expire_time=109),
        })

        self._set_current_time(100)

    def _add_test_routes_proper(self):
        """
        Adds some simple test routes.

        Configuration after all the links and routes have been added:

        LINKS:             TABLE:
        +------+---------+ +------+------+---------+
        | Port | Latency | | Dest | Port | Latency |
        +------+---------+ +------+------+---------+
        |    1 |       5 | | h1   |    1 |       8 |
        |    2 |       1 | | h2   |    3 |       5 |
        |    3 |       3 | +------+------+---------+
        |   10 |       1 |
        +------+---------+
        """
        h1 = _create_host("h1")
        h2 = _create_host("h2")
        self.h1 = h1
        self.h2 = h2
        self.h3 = _create_host("h3")

        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=2, latency=1)
        self.router.handle_link_up(port=3, latency=3)
        self.router.handle_link_up(port=10, latency=1)

        self._set_current_time(94)
        self.router.handle_route_advertisement(
            h1, port=1, route_latency=3)
        self._set_current_time(96)
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=6)
        self._set_current_time(98)
        self.router.handle_route_advertisement(
            h1, port=3, route_latency=10)
        self._set_current_time(100)
        self.router.handle_route_advertisement(
            h2, port=3, route_latency=2)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=8, expire_time=94+self.router.ROUTE_TTL),
            h2: TableEntry(dst=h2, port=3, latency=5, expire_time=100+self.router.ROUTE_TTL),
        })

    def _compute_dict_diff(self, d, expected, singular, plural):
        message = ""
        failed = False
        def pe(count): return _pluralize(count, singular, plural)

        extra = set(d.keys()) - set(expected.keys())
        if extra:
            failed = True
            message += "\nEXTRANEOUS %s:\n" % pe(len(extra))
            for k in sorted(extra):
                message += "\t{}\n".format(d[k])
        del extra

        missing = set(expected.keys()) - set(d.keys())
        if missing:
            failed = True
            message += "\nMISSING %s:\n" % pe(len(missing))
            for k in sorted(missing):
                message += "\t{}\n".format(expected[k])
        del missing
        incorrect = {k for k in set(d.keys()) & set(expected.keys())
                     if d[k] != expected[k]}

        if incorrect:
            failed = True
            message += "\nINCORRECT %s:\n" % pe(len(incorrect))
            for k in sorted(incorrect):
                message += "\n"
                message += "\tExpected: {}\n".format(expected[k])
                message += "\tActual:   {}\n".format(d[k])

        if failed:
            self.assertTrue(message, "BUG: error message should not be empty")
            return message
        else:
            return None

    def _assert_table_equal(self, expected):
        """Asserts that the router's forwarding table matches expected."""
        self.assertIsInstance(expected, dict, "BUG: expected is not a dict")

        t = self.router.table
        self.assertIsInstance(t, Table,
                              "{} is not a Table".format(t))

        failure = self._compute_dict_diff(
            t, expected,
            singular="table entry",
            plural="table entries"
        )

        if failure:
            self.fail(failure)
        else:
            if len(expected) > 0 and not "TableEntry" in str((type(expected[list(expected.keys())[0]]))):
                self.assertDictEqual(t, expected, "BUG: dicts should be equal")

    def _assert_packets_sent(self, sent, expected):
        """Asserts that packets sent match expected."""
        assertItemsEqual(
            list(sent.keys()), list(expected.keys()),
            "BUG: ports mismatch for sent packets"
        )

        def dps(ps): return str(ps) if ps else "(none)"

        failed = False
        message = ""

        for port in sorted(sent.keys()):
            self.assertIsInstance(port, int,
                                  "BUG: port {} is not a int".format(port))
            self.assertIsInstance(sent[port], list,
                                  "BUG: {} is not a list".format(sent[port]))
            self.assertIsInstance(
                expected[port], list,
                "BUG: {} is not a list".format(expected[port])
            )

            if sent[port] != expected[port]:
                failed = True
                message += "\n\nMISMATCH detected for packets sent to PORT %d:\n" % port
                message += "\tEXPECTED packets sent: %s\n" % dps(
                    expected[port])
                message += "\tACTUAL packets sent:   %s\n" % dps(sent[port])

        if failed:
            self.assertTrue(message, "BUG: there should be an error message")
            self.fail(message)
        else:
            self.assertDictEqual(sent, expected, "BUG: dicts should be equal")

    def _assert_route_ads_sent(self, sent, expected_sets):
        """
        Asserts that route advertisements sent match expected.

        :param expected: dict mapping port => set of Route objects.
        """
        assertItemsEqual(
            list(sent.keys()), list(expected_sets.keys()),
            "BUG: ports mismatch for sent route advertisements"
        )

        for routes in expected_sets.values():
            self.assertIsInstance(routes, set, "BUG: routes is not a set")
            self.assertEqual(
                len(routes), len(set(r.dst for r in routes)),
                "BUG: duplicate destination in expected_sets"
            )

        expected = {
            port: {r.dst: r for r in routes}
            for port, routes in expected_sets.items()
        }

        failed = False
        message = ""

        for port in sorted(sent.keys()):
            self.assertIsInstance(port, int,
                                  "BUG: port {} is not a int".format(port))
            self.assertIsInstance(sent[port], dict,
                                  "BUG: {} is not a dict".format(sent[port]))
            self.assertIsInstance(
                expected[port], dict,
                "BUG: {} is not a list".format(expected[port])
            )

            failure = self._compute_dict_diff(
                sent[port], expected[port],
                singular="route advertisement",
                plural="route advertisements"
            )

            if failure:
                failed = True
                message += "\n\nMISMATCH detected for route advertisements sent to port %d:" % port
                message += _indent(failure)

        if failed:
            self.assertTrue(message, "BUG: there should be an error message")
            self.fail(message)
        else:
            self.assertDictEqual(sent, expected, "BUG: dicts should be equal")

    def _assert_route_ads_sent_passed(self, sent, expected_sets):
        """
        Asserts that route advertisements sent match expected.

        :param expected: dict mapping port => set of Route objects.
        """
        assertItemsEqual(
            list(sent.keys()), list(expected_sets.keys()),
            "BUG: ports mismatch for sent route advertisements"
        )

        for routes in expected_sets.values():
            self.assertIsInstance(routes, set, "BUG: routes is not a set")
            self.assertEqual(
                len(routes), len(set(r.dst for r in routes)),
                "BUG: duplicate destination in expected_sets"
            )

        expected = {
            port: {r.dst: r for r in routes}
            for port, routes in expected_sets.items()
        }

        failed = False
        message = ""

        for port in sorted(sent.keys()):
            self.assertIsInstance(port, int,
                                  "BUG: port {} is not a int".format(port))
            self.assertIsInstance(sent[port], dict,
                                  "BUG: {} is not a dict".format(sent[port]))
            self.assertIsInstance(
                expected[port], dict,
                "BUG: {} is not a list".format(expected[port])
            )

            failure = self._compute_dict_diff(
                sent[port], expected[port],
                singular="route advertisement",
                plural="route advertisements"
            )

            if failure:
                failed = True
                message += "\n\nMISMATCH detected for route advertisements sent to port %d:" % port
                message += _indent(failure)

        if failed:
            return False
        else:
            return True

    def _gather_timer_ads(self, ports, advance):
        """
        Forwards time by `advance` seconds and calls timer.

        Returns route ads to each port.
        """
        with self._patch_send_routes(all_ports=ports) as ads:
            old_time = self._current_time
            self._set_current_time(old_time + advance)
            self.router.handle_timer()

        return ads


class TestStarterCode(TestDVRouterBase):
    """
    Tests for the starter code.  They DO NOT count as part of your grade.

    These tests should pass without any modifications on your part.  If these
    tests fail, make sure you didn't change the starter code!
    """

    def setUp(self):
        self._set_up(poison_reverse=False, poison_expired=False,
                     poison_on_link_down=False, split_horizon=False, send_on_link_up=False)

    def test_init(self):
        """Tests DVRouter initialization."""
        # Initially, all tables should be empty.
        self.assertDictEqual(
            #self.router.link_latency, {},
            self.router.ports.get_underlying_dict(), {},
            "link_latency isn't empty: {}".format(self.router.ports.get_underlying_dict())
        )
        self._assert_table_equal({})

    def test_handle_link_up(self):
        """Tests handler for link up."""
        # Add a link.
        self.router.handle_link_up(port=1234, latency=42)

        ex_link_lat = {1234: 42}  # Expected link latency table.
        self.assertDictEqual(self.router.ports.get_underlying_dict(), ex_link_lat)

        # Add a second link!
        self.router.handle_link_up(port=1, latency=0.1)

        ex_link_lat.update({1: 0.1})
        self.assertDictEqual(self.router.ports.get_underlying_dict(), ex_link_lat)

    def test_handle_link_down(self):
        """Tests handler for link down."""
        # Add a link.
        self.router.handle_link_up(port=1234, latency=42)

        ex_link_lat = {1234: 42}  # Expected link latency table.
        self.assertDictEqual(self.router.ports.get_underlying_dict(), ex_link_lat)

        # Add a second link!
        self.router.handle_link_up(port=1, latency=0.1)

        ex_link_lat.update({1: 0.1})
        self.assertDictEqual(self.router.ports.get_underlying_dict(), ex_link_lat)

        # Remove second link.
        self.router.handle_link_down(port=1)
        del(ex_link_lat[1])
        self.assertDictEqual(self.router.ports.get_underlying_dict(), ex_link_lat)


class TestStaticRoutes(TestDVRouterBase):
    """
    Tests for adding static routes.

    Each unit test starts off with an empty topology.
    """

    def setUp(self):
        self._set_up(poison_reverse=False, poison_expired=False,
                     poison_on_link_down=False, split_horizon=False, send_on_link_up=False)

    def test_add_static_route(self):
        """Tests adding static routes."""
        DIRECT_LATENCY = 0.1
        host1 = _create_host("host1")

        # Add the first host.
        self.router.handle_link_up(port=1234, latency=DIRECT_LATENCY)
        self.router.add_static_route(host1, port=1234)

        expected_rts = {  # Expected table.
            host1: TableEntry(
                dst=host1, port=1234,
                latency=DIRECT_LATENCY,  # No latency after the first hop.
                expire_time=FOREVER,
            )
        }
        self._assert_table_equal(expected_rts)

        # Add a second host!
        host2 = _create_host("host2")
        self.router.handle_link_up(port=1, latency=DIRECT_LATENCY)
        self.router.add_static_route(host2, port=1)

        expected_rts.update({  # New table.
            host2: TableEntry(
                dst=host2, port=1,
                latency=DIRECT_LATENCY, expire_time=FOREVER,
            )
        })
        self._assert_table_equal(expected_rts)

class TestForwarding(TestDVRouterBase):
    """
    Tests for forwarding data-plane packets.

    See docstring for the _add_test_routes_raw() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 100.
    """

    def setUp(self):
        self._set_up(poison_reverse=False, poison_expired=False,
                     poison_on_link_down=False, split_horizon=False, send_on_link_up=False)
        self._add_test_routes_raw()

    def test_forward(self):
        """Ensures that packets are forwarded according to forwarding table."""
        hs = _create_host("hs")

        with self._patch_send(all_ports={1, 2, 3}) as sent_packets:
            packet1 = DataPacket(dst=self.h2, src=hs, name="foo")
            self.router.handle_data_packet(packet1, in_port=2)

        self._assert_packets_sent(sent_packets, {
            1: [], 2: [], 3: [packet1],
        })

        # Send another packet.
        with self._patch_send(all_ports={1, 2, 3}) as sent_packets:
            packet2 = DataPacket(dst=self.h1, src=hs, name="bar")
            self.router.handle_data_packet(packet2, in_port=3)

        self._assert_packets_sent(sent_packets, {
            1: [packet2], 2: [], 3: [],
        })

    def test_drop(self):
        """Ensures that router drops packet if no route is known."""
        packet = Packet(dst=_create_host("hx"), src=_create_host("hy"))
        with self._ensure_no_send(all_ports={1, 2, 3}):
            self.router.handle_data_packet(packet, in_port=2)

    def test_infinity(self):
        """Ensures packets for destinations of latency infinity are dropped."""
        h3 = _create_host("h3")
        self.router.table.update({
            h3: TableEntry(
                dst=h3, port=1,
                latency=INFINITY, expire_time=FOREVER,
            )
        })
        packet = Packet(dst=h3, src=_create_host("hz"))
        with self._ensure_no_send(all_ports={1, 2, 3}):
            self.router.handle_data_packet(packet, in_port=3)
    
    def test_bigger_than_infinity(self):
        """Ensures packets for destinations of latency larger than infinity are dropped."""
        h3 = _create_host("h3")
        self.router.table.update({
            h3: TableEntry(
                dst=h3, port=1,
                latency=INFINITY+1, expire_time=FOREVER,
            )
        })
        packet = Packet(dst=h3, src=_create_host("hz"))
        with self._ensure_no_send(all_ports={1, 2, 3}):
            self.router.handle_data_packet(packet, in_port=3)


class TestAdvertise(TestDVRouterBase):
    """
    Tests for advertising routes on timer.

    See docstring for the _add_test_routes_raw() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 100.
    """

    def setUp(self):
        self._set_up(poison_reverse=False, poison_expired=False,
                     poison_on_link_down=False, split_horizon=False, send_on_link_up=False)
        self._add_test_routes_raw()

    def test_send_routes(self):
        """Ensures that send_routes(force=True) advertises correctly."""
        # Routes advertised out of each port.
        all_ports = {1, 2, 3}
        with self._patch_send_routes(all_ports) as advertised_routes:
            self.router.send_routes(force=True, single_port=None)

        self._assert_route_ads_sent(
                advertised_routes, {
                    1: {Route(self.h1, 8), Route(self.h2, 5)},
                    2: {Route(self.h1, 8), Route(self.h2, 5)},
                    3: {Route(self.h1, 8), Route(self.h2, 5)}
                }
            )

class TestHandleAdvertisement(TestDVRouterBase):
    """
    Tests for route advertisement handling.

    See docstring for the _add_test_routes_raw() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 102.
    """

    def setUp(self):
        self._set_up(poison_reverse=False, poison_expired=False,
                     poison_on_link_down=False, split_horizon=False, send_on_link_up=False)
        self.h1 = _create_host("host1")
        self.h2 = _create_host("host2")
        self.h3 = _create_host("host3")

    def test_single_neighbor(self):
        """Merging updates -- when your router only has one neighbor."""
        self.router.handle_link_up(port=1, latency=5.5)

        h1, h2, h3 = self.h1, self.h2, self.h3
        self.router.handle_route_advertisement(
            h1, port=1, route_latency=2)
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=0)
        self.router.handle_route_advertisement(
            h3, port=1, route_latency=0.5)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=7.5, expire_time=65),
            h2: TableEntry(dst=h2, port=1, latency=5.5, expire_time=65),
            h3: TableEntry(dst=h3, port=1, latency=6, expire_time=65),
        })

    def test_multiple_neighbors(self):
        """Merging multiple peer updates."""
        self.router.handle_link_up(port=1, latency=5.5)
        self.router.handle_link_up(port=3, latency=2)

        h1, h2, h3 = self.h1, self.h2, self.h3
        self.router.handle_route_advertisement(
            h1, port=1, route_latency=1)
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=2)
        self.router.handle_route_advertisement(
            h3, port=1, route_latency=3)

        self.router.handle_route_advertisement(
            h2, port=3, route_latency=5)
        self.router.handle_route_advertisement(
            h3, port=3, route_latency=7)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=1 + 5.5, expire_time=65),
            h2: TableEntry(dst=h2, port=3, latency=2 + 5, expire_time=65),
            h3: TableEntry(dst=h3, port=1, latency=3 + 5.5, expire_time=65),
        })

    def test_ties(self):
        """Ensures implementation can break ties (choosing the current route)."""
        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=3, latency=2)

        h1, h2 = self.h1, self.h2
        self.router.handle_route_advertisement(
            h1, port=1, route_latency=1)
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=2)

        self.router.handle_route_advertisement(
            h1, port=3, route_latency=4)
        self.router.handle_route_advertisement(
            h2, port=3, route_latency=5)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=1 + 5, expire_time=65),
            h2: TableEntry(dst=h2, port=1, latency=2 + 5, expire_time=65),
        })

    def test_update_same_port_shorter(self):
        """Ensures forwarding table is updated after route change (same port, shorter route)."""
        self.test_multiple_neighbors()

        h1, h2, h3 = self.h1, self.h2, self.h3
        self.router.handle_route_advertisement(
            h2, port=3, route_latency=1)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=1 + 5.5, expire_time=65),
            h2: TableEntry(dst=h2, port=3, latency=2 + 1, expire_time=65),
            h3: TableEntry(dst=h3, port=1, latency=3 + 5.5, expire_time=65),
        })

    def test_update_same_port_longer(self):
        """Ensures forwarding table is updated after route change (same port, longer route)."""
        self.test_multiple_neighbors()

        h1, h2, h3 = self.h1, self.h2, self.h3
        self.router.handle_route_advertisement(
            h2, port=3, route_latency=5.25)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=1 + 5.5, expire_time=65),
            h2: TableEntry(dst=h2, port=3, latency=2 + 5.25, expire_time=65),
            h3: TableEntry(dst=h3, port=1, latency=3 + 5.5, expire_time=65),
        })

    def test_update_alternate_port_shorter(self):
        """Ensures forwarding table is updated after a route change (another port, shorter route)."""
        self.test_multiple_neighbors()

        h1, h2, h3 = self.h1, self.h2, self.h3
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=1)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=1 + 5.5, expire_time=65),
            h2: TableEntry(dst=h2, port=1, latency=1 + 5.5, expire_time=65),
            h3: TableEntry(dst=h3, port=1, latency=3 + 5.5, expire_time=65),
        })

    def test_update_alternate_port_longer(self):
        """Ensures forwarding table is not updated after a route change (another port, longer route)."""
        self.test_multiple_neighbors()

        h1, h2, h3 = self.h1, self.h2, self.h3
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=6)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=1 + 5.5, expire_time=65),
            h2: TableEntry(dst=h2, port=3, latency=2 + 5, expire_time=65),
            h3: TableEntry(dst=h3, port=1, latency=3 + 5.5, expire_time=65),
        })

    def test_update_alternate_port_longer_same_port(self):
        """Ensures forwarding table is updated after a route change (same port, longer route)."""
        self.test_multiple_neighbors()

        h1, h2, h3 = self.h1, self.h2, self.h3
        self.router.handle_route_advertisement(
            h2, port=3, route_latency=6)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=1 + 5.5, expire_time=65),
            h2: TableEntry(dst=h2, port=3, latency=2 + 6, expire_time=65),
            h3: TableEntry(dst=h3, port=1, latency=3 + 5.5, expire_time=65),
        })


class TestRemoveRoutes(TestDVRouterBase):
    """
    Tests for removing routes on timer and link down.

    See docstring for the _add_test_routes_proper() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 100.
    """

    def setUp(self):
        self._set_up(poison_reverse=False, poison_expired=False,
                     poison_on_link_down=False, split_horizon=False, send_on_link_up=False)
        self._add_test_routes_proper()

    def test_expire_routes_none(self):
        """No routes expire."""
        h1, h2 = self.h1, self.h2

        # Current time is 100, so no routes expire.
        self.router.expire_routes()

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=8, expire_time=109),
            h2: TableEntry(dst=h2, port=3, latency=5, expire_time=115),
        })

    def test_expire_routes_forever(self):
        """Routes with expire_time=FOREVER shouldn't expire."""
        h3 = _create_host("h3")
        self.router.add_static_route(h3, port=10)

        actual = self.router.table[h3].expire_time
        self.assertEqual(
            actual, FOREVER,
            "route for host h3 through port 10 should have latency=FOREVER, "
            "instead got latency={}".format(actual)
        )

        self._set_current_time(10000)
        self.router.expire_routes()

        self._assert_table_equal({
            h3: TableEntry(dst=h3, port=10, latency=1, expire_time=FOREVER),
        })

    def test_expire_routes_some(self):
        """Some of the routes for a destination expire."""
        h1, h2 = self.h1, self.h2

        self._set_current_time(110)
        self.router.expire_routes()

        self._assert_table_equal({
            h2: TableEntry(dst=h2, port=3, latency=5, expire_time=115),
        })

    def test_expire_routes_more(self):
        """Expire all routes for a destination."""
        h1, h2 = self.h1, self.h2

        packet = Packet(dst=h1, src=h2)
        with self._patch_send(all_ports={1, 2, 3, 10}) as sent_packets:
            self.router.handle_data_packet(packet, in_port=10)
        self._assert_packets_sent(
            sent_packets, {1: [packet], 2: [], 3: [], 10: []}
        )

        self._set_current_time(114)
        self.router.expire_routes()

        expected = TableEntry(dst=h2, port=3, latency=5, expire_time=115)
        actual = self.router.table.get(h2)
        self.assertEqual(
            actual, expected,
            "forwarding table entry for HOST h2 should be {}, got {}".format(
                expected, actual
            )
        )


class TestSplitHorizon(TestDVRouterBase):
    """
    Tests for split horizon behavior.

    See docstring for the _add_test_routes_proper() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 100.
    """

    def setUp(self):
        self._set_up(poison_reverse=False, poison_expired=False,
                     poison_on_link_down=False, split_horizon=True, send_on_link_up=False)
        self._add_test_routes_proper()

    def test_single_neighbor_update(self):
        """Ensure neighbor isn't advertised its route for a destination."""
        # Routes advertised out of each port.
        all_ports = {1, 2, 3, 10}
        with self._patch_send_routes(all_ports) as advertised_routes:
            self.router.send_routes(force=True, single_port=None)

        # Not every port gets every advertisement due to split horizon.
        self._assert_route_ads_sent(
            advertised_routes, {
                1: {Route(self.h2, 5)},
                2: {Route(self.h1, 8), Route(self.h2, 5)},
                3: {Route(self.h1, 8)},
                10: {Route(self.h1, 8), Route(self.h2, 5)}
            }
        )


class TestPoisonReverse(TestDVRouterBase):
    """
    Tests for poison reverse.

    See docstring for the _add_test_routes_proper() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 100.
    """

    def setUp(self):
        self._set_up(poison_reverse=True, poison_expired=False,
                     poison_on_link_down=True, split_horizon=False, send_on_link_up=False)
        self._add_test_routes_proper()

    def test_poison_reverse(self):
        """Ensures that poison reverse advertisements are sent."""
        # Routes advertised out of each port.
        with self._patch_send_routes(all_ports={1, 2, 3, 10}, allow_dup=True) as ads:
            self.router.send_routes(force=True)

        self._assert_route_ads_sent(
            ads, {
                1: {Route(self.h1, INFINITY), Route(self.h2, 5)},
                2: {Route(self.h1, 8), Route(self.h2, 5)},
                3: {Route(self.h1, 8), Route(self.h2, INFINITY)},
                10: {Route(self.h1, 8), Route(self.h2, 5)},
            }
        )


class TestInfiniteLoops(TestDVRouterBase):
    """
    Tests for poison reverse.

    See docstring for the _add_test_routes_proper() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 100.

    FORWARDING TABLE:
        +------+------+---------+
        | Dest | Port | Latency |
        +------+------+---------+
        | h1   |    1 |       8 |
        | h2   |    3 |       5 |
        +------+------+---------+
        """

    def setUp(self):
        self._set_up(poison_reverse=True, poison_expired=False,
                     poison_on_link_down=True, split_horizon=False, send_on_link_up=False)
        self._add_test_routes_proper()

    def test_propagate_poison(self):
        """Propagate a poisoned forwarding entry."""
        h2 = self.h2
        h1 = self.h1
        self.router.handle_route_advertisement(route_dst=h2,
                                                      route_latency=1, port=3)

        with self._patch_send_routes(all_ports={1, 2, 3, 10}, allow_dup=True) as ads:
            self.router.handle_route_advertisement(route_dst=h2, port=3,
                                                          route_latency=INFINITY)
            self.router.send_routes(force=True, single_port=None)
        self._assert_route_ads_sent(ads, {
            1: {Route(h2, INFINITY), Route(h1, INFINITY)},
            2: {Route(h2, INFINITY), Route(h1, 8)},
            3: {Route(h2, INFINITY), Route(h1, 8)},
            10: {Route(h2, INFINITY), Route(h1, 8)},
        })

    def test_handle_poison_no_route(self):
        """
        If the only route is poisoned, treat destination as unreachable.
        """
        self.setUp()
        h1, h2 = self.h1, self.h2

        # Poison both routes for h1.
        self.router.handle_route_advertisement(route_dst=h1, port=1,
                                                      route_latency=INFINITY)
        self.router.handle_route_advertisement(route_dst=h1, port=3,
                                                      route_latency=INFINITY)

        # Packets destined for h1 should no longer be routed.
        with self._ensure_no_send(all_ports={1, 2, 3, 10}):
            packet = Packet(dst=h1, src=h2)
            self.router.handle_data_packet(packet, in_port=10)

    def test_handle_poison_no_route_unpoison(self):
        """
        An "unpoisoned" route should be used again.
        """
        self.setUp()
        self.test_handle_poison_no_route()

        h1, h2 = self.h1, self.h2
        # The route to h1 comes back!
        self.router.handle_route_advertisement(
            route_dst=h1, port=1, route_latency=1)

        packet = Packet(dst=h1, src=h2)
        with self._patch_send(all_ports={1, 2, 3, 10}) as sent_packets:
            self.router.handle_data_packet(packet, in_port=10)
        self._assert_packets_sent(
            sent_packets, {1: [packet], 2: [], 3: [], 10: []}
        )


class TestRoutePoisoning(TestDVRouterBase):
    """Tests for route poisoning."""

    def setUp(self):
        """
        Sets up configuration before each unit test in this stage:

        LINKS:             TABLE:
        +------+---------+ +------+------+---------+
        | Port | Latency | | Dest | Port | Latency |
        +------+---------+ +------+------+---------+
        |    1 |       5 | | h1   |    1 |       8 |
        |    2 |       1 | | h2   |    1 |      11 |
        |    3 |       3 | | h3   |    1 |      14 |
        |   10 |       1 | | h4   |    2 |       2 |
        +------+---------+ +------+------+---------+
        Current time starts off at 100.
        """
        self._set_up(poison_reverse=True, poison_expired=True,
                     poison_on_link_down=True, split_horizon=False, send_on_link_up=False)

        h1 = _create_host("h1")
        h2 = _create_host("h2")
        h3 = _create_host("h3")
        h4 = _create_host("h4")
        self.h1 = h1
        self.h2 = h2
        self.h3 = h3
        self.h4 = h4

        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=2, latency=1)
        self.router.handle_link_up(port=3, latency=3)
        self.router.handle_link_up(port=10, latency=1)

        self._set_current_time(92)
        self.router.handle_route_advertisement(
            h1, port=1, route_latency=3)
        self._set_current_time(94)
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=6)
        self._set_current_time(96)
        self.router.handle_route_advertisement(
            h3, port=1, route_latency=9)
        self._set_current_time(98)
        self.router.handle_route_advertisement(
            h4, port=2, route_latency=1)
        self._set_current_time(100)
        self.router.handle_route_advertisement(
            h2, port=3, route_latency=9)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=8, expire_time=107),
            h2: TableEntry(dst=h2, port=1, latency=11, expire_time=109),
            h3: TableEntry(dst=h3, port=1, latency=14, expire_time=111),
            h4: TableEntry(dst=h4, port=2, latency=2, expire_time=113),
        })

    def _assert_poison_sent(self, host, ads, port):
        """Asserts that poison for a host has been sent to a port."""
        expected = Route(host, INFINITY)
        self.assertIn(port, ads, "BUG: nonexistent port %d" % port)
        actual = ads[port].get(host)
        self.assertEqual(
            expected, actual,
            "poison for HOST {} not properly advertised to PORT {}\n"
            "expected: {}\nactual:   {}".format(
                get_name(host), port, expected,
                actual if actual else "(no advertisement)"
            )
        )

    def test_expire_routes_single(self):
        """Poison expired routes (single route)."""
        self._set_current_time(108)  # Expire the route added first.
        ads = self._gather_timer_ads(ports={1, 2, 3, 10}, advance=0)

        h1, h2, h3, h4 = self.h1, self.h2, self.h3, self.h4

        self._assert_route_ads_sent(ads, {
            1: {Route(h1, INFINITY), Route(h2, INFINITY),
                Route(h3, INFINITY), Route(h4, 2)},
            2: {Route(h1, INFINITY), Route(h2, 11),
                Route(h3, 14), Route(h4, INFINITY)},
            3: {Route(h1, INFINITY), Route(h2, 11),
                Route(h3, 14), Route(h4, 2)},
            10: {Route(h1, INFINITY), Route(h2, 11),
                 Route(h3, 14), Route(h4, 2)},
        })

    def test_expire_routes_single_periodic_poison(self):
        """Poison expired routes (single route) periodically."""
        self._set_current_time(108)
        self.router.handle_timer()  # Call timer immediately.

        # Call timer again after 5 seconds.
        ads = self._gather_timer_ads(ports={1, 2, 3, 10}, advance=5)
        h1 = self.h1
        for port in [2, 3, 10]:
            self._assert_poison_sent(h1, ads, port)

    def test_expire_routes_multiple(self):
        """Poison expired routes (multiple routes)."""
        self._set_current_time(114)
        # Call timer immediately.
        ads = self._gather_timer_ads(ports={1, 2, 3, 10}, advance=0)

        h1, h2, h3, h4 = self.h1, self.h2, self.h3, self.h4
        self._assert_route_ads_sent(ads, {
            1: {Route(h1, INFINITY), Route(h2, INFINITY),
                Route(h3, INFINITY), Route(h4, INFINITY)},
            2: {Route(h1, INFINITY), Route(h2, INFINITY),
                Route(h3, INFINITY), Route(h4, INFINITY)},
            3: {Route(h1, INFINITY), Route(h2, INFINITY),
                Route(h3, INFINITY), Route(h4, INFINITY)},
            10: {Route(h1, INFINITY), Route(h2, INFINITY),
                 Route(h3, INFINITY), Route(h4, INFINITY)},
        })

    def test_expire_routes_multiple_periodic_poison(self):
        """Poison expired routes (multiple routes) periodically."""
        self._set_current_time(114)
        self.router.handle_timer()

        ports = {1, 2, 3, 10}
        ads = self._gather_timer_ads(ports, advance=5)
        h1, h2, h3, h4 = self.h1, self.h2, self.h3, self.h4

        # Route for h2 should also have expired.
        expected = {Route(h1, INFINITY), Route(h2, INFINITY),
                    Route(h3, INFINITY), Route(h4, INFINITY)}
        self._assert_route_ads_sent(ads, {
            port: expected for port in ports
        })

    def test_expire_routes_multiple_periodic_poison_unpoison(self):
        """No longer advertise poison for expired routes after they come back."""
        self.test_expire_routes_multiple_periodic_poison()

        h1, h2, h3, h4 = self.h1, self.h2, self.h3, self.h4
        self.router.handle_route_advertisement(
            h1, port=2, route_latency=1)

        ads = self._gather_timer_ads(ports={1, 2, 3, 10}, advance=5)
        self._assert_route_ads_sent(ads, {
            1: {Route(h1, 2), Route(h2, INFINITY),
                Route(h3, INFINITY), Route(h4, INFINITY)},
            2: {Route(h1, INFINITY), Route(h2, INFINITY),
                Route(h3, INFINITY), Route(h4, INFINITY)},
            3: {Route(h1, 2), Route(h2, INFINITY),
                Route(h3, INFINITY), Route(h4, INFINITY)},
            10: {Route(h1, 2), Route(h2, INFINITY),
                 Route(h3, INFINITY), Route(h4, INFINITY)},
        })

class TestTriggeredIncrementalUpdates(TestDVRouterBase):
    """
    Tests for triggered and incremental updates implementation.

    See docstring for the _add_test_routes_proper() method for initial link,
    peer table, and forwarding table configurations.  The current time starts
    off at 100.
    """

    def _set_up_routes(self, sub_poison_reverse=True, sub_poison_expired=True, sub_poison_on_link_down=True, sub_split_horizon=False, sub_send_on_link_up=True, sub_triggered=True):
        self._set_up(sub_poison_reverse, sub_poison_expired,
                     sub_poison_on_link_down, sub_split_horizon, sub_send_on_link_up, sub_triggered)
        self._add_test_routes_proper()

    def _set_up_routes_directly(self, sub_poison_reverse=True, sub_poison_expired=True, sub_poison_on_link_down=True, sub_split_horizon=False, sub_send_on_link_up=True, sub_triggered=True):
        """
        Adds some simple test routes.

        Configuration after all the links and routes have been added:

        LINKS:             TABLE:
        +------+---------+ +------+------+---------+
        | Port | Latency | | Dest | Port | Latency |
        +------+---------+ +------+------+---------+
        |    1 |       5 | | h1   |    1 |       8 |
        |    2 |       1 | | h2   |    3 |       5 |
        |    3 |       3 | +------+------+---------+
        |   10 |       1 |
        +------+---------+
        """
        self._set_up(sub_poison_reverse, sub_poison_expired,
                     sub_poison_on_link_down, sub_split_horizon, sub_send_on_link_up, sub_triggered)
        h1 = _create_host("h1")
        h2 = _create_host("h2")
        self.h1 = h1
        self.h2 = h2
        self.h3 = _create_host("h3")

        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=2, latency=1)
        self.router.handle_link_up(port=3, latency=3)
        self.router.handle_link_up(port=10, latency=1)

        self.router.table = ({
            h1: TableEntry(dst=h1, port=1, latency=8, expire_time=94+self.router.ROUTE_TTL),
            h2: TableEntry(dst=h2, port=3, latency=5, expire_time=100+self.router.ROUTE_TTL),
        })

    def poison_set_up(self):
        """
        Sets up configuration before each unit test in this stage:

        LINKS:             FORWARDING TABLE:
        +------+---------+ +------+------+---------+
        | Port | Latency | | Dest | Port | Latency |
        +------+---------+ | h1   |    1 |       8 |
        |    1 |       5 | | h2   |    1 |      11 |
        |    2 |       1 | | h3   |    1 |      14 |
        |    3 |       3 | | h4   |    2 |       2 |
        |   10 |       1 |  +------+------+---------+
        +------+---------+

        Current time starts off at 100.
        """
        self._set_up(poison_reverse=True, poison_expired=True,
                     poison_on_link_down=True, split_horizon=False, send_on_link_up=True, triggered=True)

        h1 = _create_host("h1")
        h2 = _create_host("h2")
        h3 = _create_host("h3")
        h4 = _create_host("h4")
        self.h1 = h1
        self.h2 = h2
        self.h3 = h3
        self.h4 = h4

        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=2, latency=1)
        self.router.handle_link_up(port=3, latency=3)
        self.router.handle_link_up(port=10, latency=1)

        self._set_current_time(92)
        self.router.handle_route_advertisement(
            h1, port=1, route_latency=3)
        self._set_current_time(94)
        self.router.handle_route_advertisement(
            h2, port=1, route_latency=6)
        self._set_current_time(96)
        self.router.handle_route_advertisement(
            h3, port=1, route_latency=9)
        self._set_current_time(98)
        self.router.handle_route_advertisement(
            h4, port=2, route_latency=1)
        self._set_current_time(100)
        self.router.handle_route_advertisement(
            h2, port=3, route_latency=9)

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=8, expire_time=107),
            h2: TableEntry(dst=h2, port=1, latency=11, expire_time=109),
            h3: TableEntry(dst=h3, port=1, latency=14, expire_time=111),
            h4: TableEntry(dst=h4, port=2, latency=2, expire_time=113),
        })

    def assert_no_poisoning(self):
        self.assertFalse(self.router.POISON_REVERSE,
                         "poison reverse should be off")
        self.assertFalse(self.router.POISON_EXPIRED,
                         "poison expired should be off")
        self.assertFalse(self.router.POISON_ON_LINK_DOWN,
                         "poison on link down should be off")

    def assert_full_poisoning(self):
        self.assertTrue(self.router.POISON_REVERSE,
                        "poison reverse should be on")
        self.assertTrue(self.router.POISON_EXPIRED,
                        "poison expired should be on")
        self.assertTrue(self.router.POISON_ON_LINK_DOWN,
                        "poison on link down should be on")
        #self.assertTrue(self.router.TRIGGERED,
        #                "triggered updates should be on")
        self.assertFalse(self.router.SPLIT_HORIZON,
                         "split horizon should be off")
    
    def test_new_route(self):
        """Triggered update when new route is shortest."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True),
        h1 = self.h1

        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h1, port=2, route_latency=1)

        self._assert_route_ads_sent(ads, {
            1: {Route(h1, 2)},
            2: set(),
            3: {Route(h1, 2)},
            10: {Route(h1, 2)}
        })
        self.assert_no_poisoning()

    def test_new_route_poison(self):
        """Triggered update when new route is shortest (with poison)."""
        self._set_up_routes()
        h1 = self.h1
        # self.router.send_routes(force=True)

        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h1, port=2, route_latency=1)

        self._assert_route_ads_sent(ads, {
            1: {Route(h1, 2)},
            2: {Route(h1, INFINITY)},
            3: {Route(h1, 2)},
            10: {Route(h1, 2)},
        })
        self.assert_full_poisoning()

    def _test_non_shortest_route_longer(self):
        h1 = self.h1
        # self.router.send_routes(force=True)
        with self._ensure_no_send(all_ports={1, 2, 3, 10}):
            self.router.handle_route_advertisement(h1, port=2,
                                                          route_latency=INFINITY)

    def test_non_shortest_route_longer(self):
        """No triggered update advertisements should be sent if no updates."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        self._test_non_shortest_route_longer()
        self.assert_no_poisoning()

    def test_non_shortest_route_longer_poison(self):
        """No triggered update advertisements should be sent if no updates."""
        self._set_up_routes()
        self.assert_full_poisoning()
        # Still, no advertisement should be made.
        self._test_non_shortest_route_longer()

    def _test_shortest_route_shorter(self):
        h1 = self.h1

        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h1, port=1, route_latency=1)

        self._assert_route_ads_sent(ads, {
            1: set(),
            2: {Route(h1, 6)},
            3: {Route(h1, 6)},
            10: {Route(h1, 6)},
        })

    def test_shortest_route_shorter(self):
        """Make shortest route shorter."""
        self._set_up_routes(sub_poison_reverse=False, sub_poison_expired=False,
                            sub_poison_on_link_down=False, sub_split_horizon=True)
        self._test_shortest_route_shorter()
        self.assert_no_poisoning()

    def test_shortest_route_shorter_poison(self):
        """Make shortest route shorter (with poison)."""
        self._set_up_routes()
        # Should not re-advertise poison to port 1.
        self._test_shortest_route_shorter()
        self.assert_full_poisoning()

    def _test_shortest_route_slightly_longer(self):
        h2 = self.h2
        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h2, port=3, route_latency=3)

        self._assert_route_ads_sent(ads, {
            1: {Route(h2, 6)},
            2: {Route(h2, 6)},
            3: set(),
            10: {Route(h2, 6)},
        })

    def test_shortest_route_slightly_longer(self):
        """Make shortest route slightly longer (still shortest)."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        self.assert_no_poisoning()
        self._test_shortest_route_slightly_longer()

    def test_shortest_route_slightly_longer_poison(self):
        """Make shortest route longer (still shortest) (with poison)."""
        self._set_up_routes()
        self._test_shortest_route_slightly_longer()
        self.assert_full_poisoning()

    def _test_shortest_route_longer(self, expected_advertisements):
        """Make shortest route longer (no longer shortest)."""
        h2 = self.h2
        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h2, port=3, route_latency=9)

        self._assert_route_ads_sent(ads, expected_advertisements)

    def test_shortest_route_longer(self):
        """Make shortest route longer (no longer shortest)."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        h2 = self.h2
        self._test_shortest_route_longer(expected_advertisements={
            1: {Route(h2, 12)},
            2: {Route(h2, 12)},
            # The previous advertisement for h2 to port 3 already had latency
            # 11 (from the previous shortest path).
            3: set(),
            10: {Route(h2, 12)},
        })
        self.assert_no_poisoning()

    def test_shortest_route_longer_poison(self):
        """Make shortest route longer (no longer the shortest) (with poison)."""
        self._set_up_routes_directly()
        h2 = self.h2
        h1 = self.h1
        self.assert_full_poisoning()
        self._test_shortest_route_longer(expected_advertisements={
            1: {Route(h2, 12), Route(h1, INFINITY)},
            2: {Route(h2, 12), Route(h1, 8)},
            3: {Route(h2, INFINITY), Route(h1, 8)},
            10: {Route(h2, 12), Route(h1, 8)},
        })

    def _test_non_shortest_route_slightly_shorter(self):
        h2 = self.h2
        with self._ensure_no_send(all_ports={1, 2, 3, 10}):
            self.router.handle_route_advertisement(
                h2, port=1, route_latency=5)

    def test_non_shortest_route_slightly_shorter(self):
        """Make non-shortest route shorter (but still not shortest)."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False)
        self._test_non_shortest_route_slightly_shorter()
        self.assert_no_poisoning()

    def test_non_shortest_route_slightly_shorter_poison(self):
        """Make non-shortest route shorter (still not shortest) (w/ poison)."""
        self._set_up_routes()
        # Still, no advertisement should be made.
        self._test_non_shortest_route_slightly_shorter()
        self.assert_full_poisoning()
    
    def _test_non_shortest_route_shorter(self, expected_advertisements):
        h1 = self.h1
        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h1, port=3, route_latency=1)

        self._assert_route_ads_sent(ads, expected_advertisements)
    
    def test_non_shortest_route_shorter(self):
        """Make non-shortest route shortest."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        h1 = self.h1
        self._test_non_shortest_route_shorter(expected_advertisements={
            1: {Route(h1, 4)},
            2: {Route(h1, 4)},
            3: set(),
            10: {Route(h1, 4)},
        })
        self.assert_no_poisoning()


    def test_non_shortest_route_shorter_poison(self):
        """Make non-shortest route shortest (with poison)."""
        self._set_up_routes_directly()
        self.assert_full_poisoning()
        h1 = self.h1
        h2 = self.h2
        self._test_non_shortest_route_shorter(expected_advertisements={
            1: {Route(h1, 4), Route(h2, 5)},
            2: {Route(h1, 4), Route(h2, 5)},
            3: {Route(h1, INFINITY), Route(h2, INFINITY)},
            10: {Route(h1, 4), Route(h2, 5)},
        })
    
    def _test_new_host(self, expected_advertisements):
        h3 = self.h3

        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h3, port=2, route_latency=1)

        self._assert_route_ads_sent(ads, expected_advertisements)

    def test_new_host(self):
        """Route to new host."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        h3 = self.h3
        self._test_new_host(expected_advertisements={
            1: {Route(h3, 2)},
            2: set(),
            3: {Route(h3, 2)},
            10: {Route(h3, 2)},
        })
        self.assert_no_poisoning()

    def test_new_host_poison(self):
        """Route to new host (with poisoning)."""
        self._set_up_routes()
        h3 = self.h3
        self._test_new_host(expected_advertisements={
            1: {Route(h3, 2)},
            2: {Route(h3, INFINITY)},
            3: {Route(h3, 2)},
            10: {Route(h3, 2)},
        })
        self.assert_full_poisoning()

    def test_consecutive(self):
        """Tests triggered updates with consecutive route advertisements."""
        #poison_reverse = False, poison_expired = False, poison_on_link_down = False, 
        #split_horizon = True, send_on_link_up = True)
        self._set_up(False, False,
                     False, True, True, True)

        h1 = _create_host("h1")
        h2 = _create_host("h2")

        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=2, latency=1)
        self.router.handle_link_up(port=3, latency=3)

        with self._patch_send_routes(all_ports={1, 2, 3}) as ads:
            self.router.handle_route_advertisement(
                h1, port=1, route_latency=3)
        self._assert_route_ads_sent(ads, {1: set(), 2: {Route(h1, 8)},
                                          3: {Route(h1, 8)}})

        with self._patch_send_routes(all_ports={1, 2, 3}) as ads:
            self.router.handle_route_advertisement(
                h2, port=1, route_latency=6)
        self._assert_route_ads_sent(ads, {1: set(), 2: {Route(h2, 11)},
                                          3: {Route(h2, 11)}})

        with self._ensure_no_send(all_ports={1, 2, 3}):
            self.router.handle_route_advertisement(h1, port=3,
                                                          route_latency=10)

        with self._patch_send_routes(all_ports={1, 2, 3}) as ads:
            self.router.handle_route_advertisement(
                h2, port=3, route_latency=2)
        self._assert_route_ads_sent(ads, {1: {Route(h2, 5)}, 2: {Route(h2, 5)},
                                          3: set()})

    def test_consecutive_poison(self):
        """Triggered updates, consecutive route ads (with poison)."""
        #poison_reverse = True, poison_expired = True, poison_on_link_down = True, 
        #split_horizon = False, send_on_link_up = True)
        self._set_up(True, True, True, False, True, True)

        h1 = _create_host("h1")
        h2 = _create_host("h2")

        self.router.handle_link_up(port=1, latency=5)
        self.router.handle_link_up(port=2, latency=1)
        self.router.handle_link_up(port=3, latency=3)

        with self._patch_send_routes(all_ports={1, 2, 3}) as ads:
            self.router.handle_route_advertisement(
                h1, port=1, route_latency=3)
        self._assert_route_ads_sent(ads, {1: {Route(h1, INFINITY)}, 2: {Route(h1, 8)},
                                          3: {Route(h1, 8)}})

        self._assert_table_equal({
            h1: TableEntry(dst=h1, port=1, latency=8, expire_time=65),
        })

        with self._patch_send_routes(all_ports={1, 2, 3}) as ads:
            self.router.handle_route_advertisement(
                h2, port=2, route_latency=6)
        self._assert_route_ads_sent(ads, {1: {Route(h2, 7)},
                                          2: {Route(h2, INFINITY)}, 3: {Route(h2, 7)}})

        with self._ensure_no_send(all_ports={1, 2, 3}):
            self.router.handle_route_advertisement(h1, port=3,
                                                          route_latency=10)

        with self._patch_send_routes(all_ports={1, 2, 3}) as ads:
            self.router.handle_route_advertisement(
                h2, port=3, route_latency=2)
        self._assert_route_ads_sent(ads, {1: {Route(h2, 5)}, 2: {Route(h2, 5)},
                                          3: {Route(h2, INFINITY)}})

    def _test_handle_link_down_update(self, expected_advertisements):
        """Advertise updated routes on link down."""
        # Force sending of routes if we are poisoning on link down
        if self.router.POISON_ON_LINK_DOWN:
            self.router.handle_link_down(port=1)
            with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
                self.router.send_routes(force=True)
        else:
            with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
                self.router.handle_link_down(port=1)

        self._assert_route_ads_sent(ads, expected_advertisements)

    def test_handle_link_down_update(self):
        """Advertise updated routes on link down."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        h1 = self.h1
        self._test_handle_link_down_update(expected_advertisements={
            1: set(),
            2: set(),
            3: set(),
            10: set(),
        })
        self.assert_no_poisoning()

    def test_handle_link_down_update_poison(self):
        """Advertise updated routes on link down (with poison) (forced update)."""
        self._set_up_routes()
        h1 = self.h1
        h2 = self.h2
        self._test_handle_link_down_update(expected_advertisements={
            1: set(),
            2: {Route(h1, INFINITY), Route(h2, 5)},
            3: {Route(h1, INFINITY), Route(h2, INFINITY)},
            10: {Route(h1, INFINITY), Route(h2, 5)}
        })

    def _test_handle_link_down_update_multiple(self, expected_advertisements):
        """Advertise multiple updated routes on link down."""
        h3 = self.h3
        self.router.handle_route_advertisement(
            h3, port=1, route_latency=1)
        self.router.handle_route_advertisement(
            h3, port=2, route_latency=10)

        # Route for h3 should be through port 1.
        actual = self.router.table[h3].port
        self.assertEqual(
            actual, 1,
            "route for HOST h3 should take PORT 1, not {}".format(actual)
        )
        if not self.router.POISON_ON_LINK_DOWN:
            with self._patch_send_routes(all_ports={2, 3, 10}) as ads:
                self.router.handle_link_down(port=1)
        # Force update if not poisoning
        else:
            self.router.handle_link_down(port=1)
            with self._patch_send_routes(all_ports={2, 3, 10}) as ads:
                self.router.send_routes(force=True)

        self._assert_route_ads_sent(ads, expected_advertisements)

    def test_handle_link_down_update_multiple(self):
        """Advertise multiple updated routes on link down."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        h1, h3 = self.h1, self.h3
        self._test_handle_link_down_update_multiple(expected_advertisements={
            2: set(),
            3: set(),
            10: set(),
        })
        self.assert_no_poisoning()

    def test_handle_link_down_update_multiple_poison(self):
        """Advertise multiple updated routes on link down (with poison)."""
        self._set_up_routes()
        h1, h2, h3 = self.h1, self.h2, self.h3
        self._test_handle_link_down_update_multiple(expected_advertisements={
            2: {Route(h1, INFINITY), Route(h3, INFINITY), Route(h2, 5)},
            3: {Route(h1, INFINITY), Route(h3, INFINITY), Route(h2, INFINITY)},
            10: {Route(h1, INFINITY), Route(h3, INFINITY), Route(h2, 5)},
        })
        self.assert_full_poisoning()

    def test_handle_link_down_no_update(self):
        """Shouldn't advertise when downed link affects no advertised route."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False)
        with self._ensure_no_send(all_ports={1, 2, 3, 10}):
            self.router.handle_link_down(port=10)
        self.assert_no_poisoning()

    def test_handle_link_down_no_update_poison(self):
        """Down link, no advertise (with poison)."""
        self._set_up_routes()
        with self._ensure_no_send(all_ports={1, 2, 3, 10}):
            self.router.handle_link_down(port=10)
        self.assert_full_poisoning()

    def test_expire_no_duplicate(self):
        """Ensures no duplicate advertisement in case of route timeout."""
        self._set_up_routes(sub_poison_reverse=False,
                            sub_poison_expired=False, sub_poison_on_link_down=False, sub_split_horizon=True)
        self._set_current_time(110)  # Expire all but the last-added route.
        ads = self._gather_timer_ads(ports={1, 2, 3, 10}, advance=0)
        # The timer handler should have advertised all routes.

        h1, h2 = self.h1, self.h2
        self._assert_route_ads_sent(ads, {
            1: {Route(h2, 5)},
            2: {Route(h2, 5)},
            3: set(),
            10: {Route(h2, 5)},
        })
        self.assert_no_poisoning()

    def test_expire_no_duplicate_with_poison(self):
        """Ensures no duplicate advertisement in case of route timeout (with poison)."""
        self._set_up_routes()
        self._set_current_time(110)  # Expire all but the last-added route.
        ads = self._gather_timer_ads(ports={1, 2, 3, 10}, advance=0)
        # The timer handler should have advertised all routes.

        h1, h2 = self.h1, self.h2
        self._assert_route_ads_sent(ads, {
            1: {Route(h1, INFINITY), Route(h2, 5)},
            2: {Route(h1, INFINITY), Route(h2, 5)},
            3: {Route(h1, INFINITY), Route(h2, INFINITY)},
            10: {Route(h1, INFINITY), Route(h2, 5)},
        })
        self.assert_full_poisoning()

    def test_poison_alternate_route(self):
        """Advertise alternate route chosen due to poisoning."""
        self._set_up_routes()
        h1 = self.h1

        self.router.handle_route_advertisement(h1, port=1,
                                                      route_latency=INFINITY)
        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(h1, port=3,
                                                          route_latency=10)

        self._assert_route_ads_sent(ads, {
            1: {Route(h1, 13)},
            2: {Route(h1, 13)},
            3: set(),
            10: {Route(h1, 13)},
        })

    def test_poison_no_update(self):
        """Don't advertise if poisoning doesn't change forwarding table."""
        self.poison_set_up()
        h1 = self.h1

        with self._ensure_no_send(all_ports={1, 2, 3, 10}):
            self.router.handle_route_advertisement(h1, port=3,
                                                          route_latency=INFINITY)

    def test_expire_advertise_poison_incremental(self):
        """Ensures that poison ads are sent incrementally (from expiry)."""
        self.poison_set_up()
        self._set_current_time(108)  # Expire the route added first.
        self.router.handle_timer()
        self.router.send_routes(force=False)
        h1, h2, h3, h4 = self.h1, self.h2, self.h3, self.h4
        with self._patch_send_routes(all_ports={1, 2, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h2, port=1, route_latency=1)

        self._assert_route_ads_sent(ads, {
            # No advertisement for port 1 since h2 was already poisoned
            # through poisoned reverse.
            1: set(),
            2: {Route(h2, 6)},
            3: {Route(h2, 6)},
            10: {Route(h2, 6)},
        })
    
    def test_link_down_advertise_poison_incremental(self):
        """Ensures that poison ads are sent incrementally (from link down)."""
        self.poison_set_up()
        self.router.handle_link_down(port=2)

        h1, h2, h3, h4 = self.h1, self.h2, self.h3, self.h4
        with self._patch_send_routes(all_ports={1, 3, 10}) as ads:
            self.router.handle_route_advertisement(
                h2, port=1, route_latency=1)

        self._assert_route_ads_sent(ads, {
            # No advertisement for port 1 since h2 was already poisoned
            # through poisoned reverse.
            1: set(),

            3: {Route(h2, 6)},
            10: {Route(h2, 6)},
        })

    def test_link_down_advertise_poison_incremental_multiple(self):
        """Ensures that poison ads are sent incrementally (multiple rounds)."""
        self.poison_set_up()
        self.router.handle_link_down(port=2)

        h1, h2, h3, h4 = self.h1, self.h2, self.h3, self.h4
        with self._patch_send_routes(all_ports={3, 10}) as ads:
            self.router.handle_link_down(port=1)

        self._assert_route_ads_sent(ads, {
            3: {Route(h1, INFINITY), Route(h2, INFINITY), Route(h3, INFINITY)},
            10: {Route(h1, INFINITY), Route(h2, INFINITY), Route(h3, INFINITY)},
        })


def _create_host(name):
    """Hacky helper function to create a host outside of simulation."""
    host = HostEntity()
    host.name = name
    return host


def _pluralize(count, singular, plural):
    """Returns singular or plural based on count."""
    if count == 1:
        return singular
    else:
        return plural


def _indent(text):
    """Returns text with a tab inserted in the front of each line."""
    return "\n".join(
        "\t" + line for line in text.splitlines()
    )


def main():
    test_cases = (
        TestStarterCode, TestStaticRoutes, TestForwarding,
        TestAdvertise, TestHandleAdvertisement, TestRemoveRoutes,
        TestSplitHorizon, TestPoisonReverse, TestInfiniteLoops,
        TestRoutePoisoning, TestTriggeredIncrementalUpdates
    )

    parser = argparse.ArgumentParser()
    parser.add_argument("step_num", type=int, choices=range(len(test_cases)),
                        default=len(test_cases)-1, nargs="?",
                        help="run tests for the first x steps "
                             "(runs all tests if omitted)")
    parser.add_argument("--verbose", "-v", action="count", default=1,
                        help="sets verbosity of test output")
    args = parser.parse_args()

    successes = {}  # stage => tests that passed
    totals = {}  # stage => total number of tests

    for stage, test_case in enumerate(test_cases[:args.step_num+1]):
        eprint("********** Stage {}: {} **********".format(
            stage, test_case.__name__)
        )
        runner = unittest.TextTestRunner(verbosity=args.verbose)
        suite = unittest.TestLoader().loadTestsFromTestCase(test_case)
        result = runner.run(suite)
        eprint()

        assert not result.skipped
        assert not result.expectedFailures
        assert not result.unexpectedSuccesses

        if stage > 0:
            total = suite.countTestCases()
            passed = total - len(result.errors) - len(result.failures)
            assert passed >= 0
            successes[stage] = passed
            totals[stage] = total

    score = 0
    eprint("Overall scores:")
    for stage in range(1, len(test_cases)):
        if stage > args.step_num:
            eprint("\tStage {0} {1: <35}:  tests not run".format(
                stage, test_cases[stage].__name__)
            )
            continue

        fails = totals[stage] - successes[stage]
        msg = ""
        if fails:
            msg = " ({} FAILED)".format(fails)

        eprint("\tStage {0} {1: <35}: {2: >2} / {3: <2} passed{4}".format(
            stage, test_cases[stage].__name__, successes[stage], totals[stage],
            msg)
        )
        score += 10 * float(successes[stage]) / totals[stage]
    eprint()
    eprint("Total score: %.2f / %.2f" % (score, 10 * (len(test_cases) - 1)))


if __name__ == '__main__':
    main()
