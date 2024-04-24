import sim.api as api
from sim.basics import *

class Hub (api.Entity):
  """
  A dumb hub.

  This just sends every packet it gets out of every port.  On the plus side,
  if there's a way for the packet to get to the destination, this will find it.
  On the down side, it's probably pretty wasteful.  On the *very* down side,
  if the topology has loops, very bad things are about to happen.
  """

  def handle_rx (self, packet, in_port):
    # We'll just flood the packet out of every port.  Except the one the
    # packet arrived on, since whatever is out that port has obviously
    # seen the packet already!
    self.send(packet, in_port, flood=True)
