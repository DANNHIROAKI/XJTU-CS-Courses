import sim

def launch (switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type):
  """
  Creates a very simple linear topology with two switches and three hosts;
  Two of the hosts connect to the same switch while the other host connect
  to the separate switch.

  The topology looks like:

   h2
    |
    s1 -- s2
    |     |
   h1     h3
  """

  switch_type.create('s1')
  switch_type.create('s2')

  host_type.create('h1')
  host_type.create('h2')
  host_type.create('h3')

  s1.linkTo(h1)
  s1.linkTo(h2)
  s2.linkTo(h3)

  s1.linkTo(s2)
