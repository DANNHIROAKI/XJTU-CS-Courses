"""
This adds a utility for NetVis

If you run this module and set MegaHost to be the default host type, you get
a new feature.  Select a host and press Shift-1 (by default), and all other
hosts will send a ping to it simultaneously.

In order for this to work, the hosts need to be MegaHosts, so you probably
want to put --default-host-type=examples.megaping at the start of your
commandline.  So a full commandline might look like:
python sim/boot.py --default-host-type=examples.megaping \
                   topos.candy examples.megaping

If you pass in --super, it'll send several megapings at one second intervals.

This demonstrates:
 * Creating a custom module
 * Creating a host subclass for the purpose of testing
 * Reading the selection from NetVis
 * Custom function invocation from NetVis
 * Simulator tasklets (kind of like little cooperative threads)
"""

from sim.basics import BasicHost
import sim.api

all_hosts = set()

class MegaHost (BasicHost):
  """
  This is actually the same as a BasicHost except it tracks all instances...
  """
  def __init__ (self, *args, **kw):
    super(MegaHost,self).__init__(*args, **kw)
    all_hosts.add(self)


def do_send_megaping (dst):
  """
  Make everyone send a ping to dst
  """
  if dst is None: return

  for host in all_hosts:
    if host is dst: continue
    host.ping(dst)

  sim.api.netvis.info = "%s hosts pinged %s" % (len(all_hosts) - 1, dst)


def get_dst ():
  """
  Get the currently selected node in NetVis
  """
  if not all_hosts:
    sim.api.netvis.info = ("No hosts!\n"
      "Did you remember to set\n --default-host-type=examples.megaping ?")
    return None

  dst = sim.api.netvis.selected
  if not dst:
    sim.api.netvis.info = "You must select a node to megaping!"
    return None

  assert dst in all_hosts

  return dst


def send_megaping ():
  """
  Full documentation at https://www.youtube.com/watch?v=jr0JaXfKj68#t=4
  """
  do_send_megaping(get_dst())


def send_super_megaping ():
  """
  When just one megaping won't do.
  """
  dst = get_dst()

  def send_some (how_many, interval):
    # Our tasklet function.
    # Sends /how_many/ pings separated by /interval/ seconds.
    for _ in range(how_many):
      do_send_megaping(dst) # Send
      yield interval        # Sleep

  # Send 5 megapings 1 second apart
  sim.api.run_tasklet(send_some, 5, 1)


def launch (bind_to = 1, super = False):
  if not super:
    sim.api.netvis.set_function_callback(int(bind_to), send_megaping)
  else:
    sim.api.netvis.set_function_callback(int(bind_to), send_super_megaping)

  # Now Shift-<bind_to> will cause all hosts to ping the selected host
