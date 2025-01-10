import sim
import random


def launch (switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type,
            switches = 6, hosts = 4, links = 8, multiple_hosts = True, seed = None):
    """
    Creates a random fully-connected (single component) topology

    The topology will have *switches* switches, and *hosts* hosts.
    The switches will be connected by *links* links unless *tree*, in which
    case the topology will be a tree (and therefore have *switches* - 1 links).
    That's all not counting the extra *hosts* links which connect hosts to
    switches.
    Invalid numbers of links should just be clamped to the legal range;
    among other things, this means that setting links=0 will give you a tree.
    If *multiple_hosts* is True, hosts are allocated to switches entirely at
    random, so a switch may have multiple hosts.  If it's False, each switch
    will have at most one host (so *hosts* better be <= *switches*).
    """
    if seed is None:
      rand = random
    else:
      try:
        seed = float(seed)
        if seed == int(seed):
          seed = int(seed)
      except:
        pass
      rand = random.Random()
      rand.seed(seed)

    n = switches
    h = hosts
    l = links

    n = int(n)
    h = int(h)
    if l is None: l = 2 * n
    l = int(l)
    l = min(l, l*(l-1)//2)
    l = max(l, n-1)

    l -= (n-1)

    groups = {x:[x] for x in range(n)}

    links = set()

    while len(groups) > 1:
      a,b = rand.sample(sorted(groups.keys()), 2)
      aa = groups[a]
      bb = groups[b]
      an = rand.choice(aa)
      bn = rand.choice(bb)
      if bn < an: an,bn = bn,an
      links.add((an,bn))
      aa.extend(bb)
      del groups[b]

    nodes = sorted(list(groups.values())[0])

    while l:
      an,bn = rand.sample(nodes, 2)
      if bn < an: an,bn = bn,an
      if (an,bn) in links: continue
      l -= 1
      links.add((an,bn))

    switches = []
    for i in range(n):
      switches.append( switch_type.create('s' + str(i+1)) )
    for u,v in sorted(links):
      switches[u].linkTo(switches[v])

    for i in range(h):
      host = host_type.create('h' + str(i+1))

      switch = rand.choice(switches)
      if not multiple_hosts:
        switches.remove(switch)

      switch.linkTo(host)
