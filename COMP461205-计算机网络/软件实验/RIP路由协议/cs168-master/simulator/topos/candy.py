import sim

def launch (switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type):
  """
  Creates a topology with loops.

  It looks like:

  h1a    s4--s5    h2a
     \  /      \  /
      s1        s2
     /  \      /  \\
  h1b    --s3--    h2b
  """

  switch_type.create('s1')
  switch_type.create('s2')
  switch_type.create('s3')
  switch_type.create('s4')
  switch_type.create('s5')

  host_type.create('h1a')
  host_type.create('h1b')
  host_type.create('h2a')
  host_type.create('h2b')

  s1.linkTo(h1a)
  s1.linkTo(h1b)
  s2.linkTo(h2a)
  s2.linkTo(h2b)

  s1.linkTo(s3, latency=3)
  s3.linkTo(s2, latency=2)

  s1.linkTo(s4)
  s4.linkTo(s5, latency=2)
  s5.linkTo(s2)
