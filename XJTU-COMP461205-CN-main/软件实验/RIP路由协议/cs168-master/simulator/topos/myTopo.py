import sim
def launch (switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type):

  switch_type.create('A')
  switch_type.create('B')
  switch_type.create('C')
  switch_type.create('D')

  host_type.create('h1')
  host_type.create('h2')
  host_type.create('h3')
  host_type.create('h4')

  A.linkTo(h1, latency=1)
  B.linkTo(h2, latency=1)
  C.linkTo(h3, latency=1)
  D.linkTo(h4, latency=1)

  A.linkTo(B, latency=2)
  A.linkTo(C, latency=7)
  B.linkTo(C, latency=1)
  C.linkTo(D, latency=1)
  B.linkTo(D, latency=3)

