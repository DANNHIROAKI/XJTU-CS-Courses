"""
A simple test of a learning switch

Creates some hosts connected to a single central switch.
Sends some pings.
Makes sure the expected number of pings and pongs arrive.
"""

import sim
import sim.api as api
import sim.basics as basics


class TestHost (basics.BasicHost):
  """
  A host that counts pings and pongs
  """
  pings = 0
  pongs = 0
  ENABLE_DISCOVERY = False # Too easy with it turned on!

  def handle_rx (self, packet, port):
    if isinstance(packet, basics.Ping):
      self.pings += 1
    elif isinstance(packet, basics.Pong):
      self.pongs += 1
    super(TestHost,self).handle_rx(packet, port)


def launch ():
  h1 = TestHost.create("h1")
  h2 = TestHost.create("h2")
  h3 = TestHost.create("h3")
  h4 = TestHost.create("h4")

  hosts = [h1, h2, h3, h4]

  r = sim.config.default_switch_type.create("r")

  r.linkTo(h1)
  r.linkTo(h2)
  r.linkTo(h3)
  r.linkTo(h4)

  def test_tasklet ():
    yield 1

    api.userlog.debug("Sending test pings")

    h2.ping(h1)

    yield 3

    h2.ping(h4)

    yield 3

    h1.ping(h2)

    api.userlog.debug("Waiting for deliveries")

    yield 5 # Wait five seconds for deliveries

    pings = sum([h.pings for h in hosts])
    pongs = sum([h.pongs for h in hosts])

    good = True
    if pings != 7:
      api.userlog.error("Got %s pings", pings)
      good = False
    if pongs != 3:
      api.userlog.error("Got %s pongs", pongs)
      good = False

    if good:
      api.userlog.debug("Test passed successfully!")

    # End the simulation and (if not running in interactive mode) exit.
    import sys
    sys.exit(0)

  api.run_tasklet(test_tasklet)
