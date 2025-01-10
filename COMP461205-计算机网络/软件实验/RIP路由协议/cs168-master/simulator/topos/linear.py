import sim

def launch (switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type,
            n = 2):
  """
  Creates a very simple linear topology.

  The topology looks like:

  s1 -- s2 -- .. -- sn
   |     |           |
  h1    h2          hn

  n defaults to 2.
  """

  n = int(n)

  switches = []
  for i in range(1, n+1):
    s = switch_type.create('s' + str(i))
    switches.append(s)
    h = host_type.create('h' + str(i))
    s.linkTo(h)

  # Connect the switches
  prev = switches[0]
  for s in switches[1:]:
    prev.linkTo(s)
    prev = s
