import sim

def launch (switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type,
            n = 2):
  """
  Creates a star topology

  The topology has a single switch surrounded by n hosts.

  n defaults to 2.
  """

  n = int(n)

  s = switch_type.create("s")

  for i in range(1, n+1):
    h = host_type.create('h' + str(i))
    s.linkTo(h)
