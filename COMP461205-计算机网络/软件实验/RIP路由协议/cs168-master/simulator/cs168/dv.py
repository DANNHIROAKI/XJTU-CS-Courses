"""
Framework code for the Berkeley CS168 Distance Vector router project

Authors:
  zhangwen0411, MurphyMc, lab352
"""

#NOTE: This file is written in POX style.


import sim.api as api


# Host discovery packets are treated as an implementation detail --
# they're how we know when to call add_static_route().  Thus, we make
# them invisible in the simulator.
from sim.basics import HostDiscoveryPacket
HostDiscoveryPacket.outer_color = [0, 0, 0, 0]
HostDiscoveryPacket.inner_color = [0, 0, 0, 0]



#TODO: Make this a namedtuple?
class RoutePacket (api.Packet):
  """
  A DV route advertisement

  Note that these packets have both a .dst and a .destination.
  The former is the destination address for the packet, the same as any
  packet has a destination address.
  The latter is the destination for which this is a route advertisement.
  """
  def __init__ (self, destination, latency):
    super(RoutePacket, self).__init__()
    self.latency = latency
    self.destination = destination
    self.outer_color = [1, 0, 1, 1]
    self.inner_color = [1, 0, 1, 1]

  def __repr__ (self):
    return "<RoutePacket to %s at cost %s>" % (
        self.destination, self.latency)

class Ports:
  def __init__ (self):
    self.link_to_lat = {}
  
  def add_port(self, port, latency):
    self.link_to_lat[port] = latency

  def remove_port(self, port):
    del self.link_to_lat[port]

  def get_all_ports(self):
    return self.link_to_lat.keys()

  def get_latency(self, port):
    return self.link_to_lat[port]
  
  def get_underlying_dict(self):
    return self.link_to_lat



class DVRouterBase (api.Entity):
    """
    Base class for implementing a distance vector router
    """
    TIMER_INTERVAL = 5  # Default timer interval.
    ROUTE_TTL = 15
    GARBAGE_TTL = 10

    def start_timer (self, interval=None):
      """
      Start the timer that calls handle_timer()

      This should get called in the constructor.

      !!! DO NOT OVERRIDE THIS METHOD !!!
      """
      if interval is None:
        interval = self.TIMER_INTERVAL
        if interval is None: return
      api.create_timer(interval, self.handle_timer)

    def handle_rx (self, packet, port):
      """
      Called by the framework when this router receives a packet.

      The implementation calls one of several methods to handle the specific
      type of packet that is received.  You should implement your
      packet-handling logic in those methods instead of modifying this one.

      !!! DO NOT OVERRIDE THIS METHOD !!!
      """
      if isinstance(packet, RoutePacket):
        self.expire_routes()
        self.handle_route_advertisement(packet.destination,
                                        packet.latency,
                                        port)
      elif isinstance(packet, HostDiscoveryPacket):
        self.add_static_route(packet.src, port)
      else:
        self.handle_data_packet(packet, port)

    def handle_timer (self):
      """
      Called periodically when the router should send tables to neighbors

      You probably want to override this.
      """
      self.expire_routes()
      self.send_routes(force=True)

    def add_static_route (self, host, port):
      """
      Called when you should add a static route to your routing table

      You probably want to override this.
      """
      pass

    def handle_route_advertisement (self, route_dst, route_latency, port):
      """
      Called when this router receives a route advertisement packet

      You probably want to override this.
      """
      pass

    def handle_data_packet (self, packet, in_port):
      """
      Called when this router receives a data packet

      You probably want to override this.
      """
      pass

    def send_route(self, port, dst, latency):
      """
      Creates a control packet from dst and lat and sends it.
      """

      pkt = RoutePacket(destination=dst, latency=latency)
      self.send(pkt, port=port)
    
    def s_log(self, format, *args):
      """
      Logs the message.

      DO NOT remove any existing code from this method.

      :param message: message to be logged.
      :returns: nothing.
      """
      try:
        if api.netvis.selected == self.name:
          self.log(format, *args)
      except:
        self.log(format, *args)


#TODO: Move this stuff to top of file?

#import abc
from collections import namedtuple
from numbers import Number  # Available in Python >= 2.7.
import unittest

from sim.api import HostEntity, get_name, current_time


# Used for a time ininitely in the future.
# (e.g., for routes that should never time out)
FOREVER = float("+inf")  # Denotes forever in time.
INFINITY = 100

#FIXME: Make FOREVER an internal thing and fix the way it gets formatted in __str__?
#       Instead, have expiration time = None (a default?) mean forever?  (Internally,
#       we may want to set it to +inf just because that should do the right thing?)



class _ValidatedDict (dict):
#  __metaclass__ = abc.ABCMeta
#
  def __init__ (self, *args, **kwargs):
    super(_ValidatedDict, self).__init__(*args, **kwargs)
    for k, v in self.items():
      self.validate(k, v)

  def __setitem__ (self, key, value):
    self.validate(key, value)
    return super(_ValidatedDict, self).__setitem__(key, value)

  def update (self, *args, **kwargs):
    super(_ValidatedDict, self).update(*args, **kwargs)
    for k, v in self.items():
      self.validate(k, v)

  #@abc.abstractmethod
  def validate (self, key, value):
    """Raises ValueError if (key, value) is invalid."""
    #pass
    raise NotImplementedError("Dict validation not implemented")



class Table (_ValidatedDict):
  """
  A routing table

  You should use a `Table` instance as a `dict` that maps a
  destination host to a `TableEntry` object.
  """
  owner = None

  def validate (self, dst, entry):
    """Raises ValueError if dst and entry have incorrect types."""
    if not isinstance(dst, HostEntity):
      raise ValueError("destination %s is not a host" % (dst,))

    if not isinstance(entry, TableEntry):
      raise ValueError("entry %s isn't a table entry" % (entry,))

    if entry.dst != dst:
      raise ValueError("entry destination %s doesn't match key %s" %
               (entry.dst, dst))

  def __str__ (self):
    o = "=== Table"
    if self.owner and getattr(self.owner, 'name'):
      o += " for " + str(self.owner.name)
    o += " ===\n"

    if not self:
      o += "(empty table)"
    else:
      o += "%-6s %-3s %-4s %s\n" % ("name", "prt", "lat", "sec")
      o += "------ --- ---- -----\n"
      o += "\n".join("{}".format(v) for v in self.values())
    return o



class TableEntry (namedtuple("TableEntry",
                             ["dst", "port", "latency", "expire_time"])):
  """
  An entry in a Table, representing a route from a neighbor to some
  destination host.

  Example usage:
    rte = TableEntry(
      dst=h1, latency=10, expire_time=api.current_time()+10
    )
  """

  def __new__ (cls, dst, port, latency, expire_time):
    """
    Creates a peer table entry, denoting a route advertised by a neighbor.

    A TableEntry is immutable.

    :param dst: the route's destination host.
    :param port: the port that this route takes.
    :param latency: the route's advertised latency (DO NOT include the link
            latency to this neighbor). #FIXME: Yes, do include it?
    :param expire_time: time point (seconds) at which this route expires.
    """
    if not isinstance(dst, HostEntity):
      raise ValueError("Provided destination %s is not a host" % (dst,))

    if not isinstance(port, int):
      raise ValueError("Provided port %s is not an integer" % (port,))

    if not isinstance(expire_time, Number):
      raise ValueError("Provided expire time %s is not a number"
               % (expire_time,))

    if not isinstance(latency, Number):
      raise ValueError("Provided latency %s is not a number" % latency)

    self = super(TableEntry, cls).__new__(cls, dst, port,
                        latency, expire_time)
    return self

  @property
  def has_expired (self):
    return current_time() > self.expire_time

  def __str__ (self):
    latency = self.latency
    if int(latency) == latency: latency = int(latency)
    return "%-6s %-3s %-4s %0.2f" % (
         get_name(self.dst), self.port, latency,
         self.expire_time - current_time())



#FIXME: add port tests
class TestTableEntry (unittest.TestCase):
  """Unit tests for TableEntry."""
  def test_init_success (self):
    """Ensures __init__ accepts valid arguments."""
    host1 = HostEntity()
    host1.name = "host1"
    TableEntry(dst=host1, latency=10, expire_time=300)
    TableEntry(dst=host1, latency=0.1, expire_time=0.2)
    TableEntry(dst=host1, latency=10,
           expire_time=TableEntry.FOREVER)

  def test_init_None (self):
    """Ensures __init__ doesn't accept None arguments."""
    host1 = HostEntity()
    host1.name = "host1"

    with self.assertRaises(ValueError):
      TableEntry(dst=None, latency=10, expire_time=300)

    with self.assertRaises(ValueError):
      TableEntry(dst=host1, latency=None, expire_time=300)

    with self.assertRaises(ValueError):
      TableEntry(dst=host1, latency=10, expire_time=None)

  def test_init_types (self):
    """Ensures __init__ rejects incorrectly typed arguments."""
    host1 = HostEntity()
    host1.name = "host1"

    with self.assertRaises(ValueError):
      TableEntry(dst="host1", latency=10, expire_time=300)

    with self.assertRaises(ValueError):
      TableEntry(dst=host1, latency="hi", expire_time=300)

    with self.assertRaises(ValueError):
      TableEntry(dst=host1, latency=10, expire_time="oops")

  def test_equality (self):
    """Tests __eq__, __ne__, and __hash__ implementations."""
    host1 = HostEntity()
    host1.name = "host1"
    host2 = HostEntity()
    host2.name = "host2"

    rte1 = TableEntry(dst=host1, latency=10, expire_time=300)
    rte2 = TableEntry(dst=host1, latency=10, expire_time=300)
    self.assertEqual(rte1, rte2)
    self.assertTrue(rte1 == rte2)
    self.assertFalse(rte1 != rte2)
    self.assertEqual(hash(rte1), hash(rte2))

    rte3 = TableEntry(dst=host2, latency=10, expire_time=300)
    self.assertNotEqual(rte1, rte3)
    self.assertFalse(rte1 == rte3)
    self.assertTrue(rte1 != rte3)

    rte4 = TableEntry(dst=host1, latency=0, expire_time=300)
    self.assertNotEqual(rte1, rte4)
    self.assertFalse(rte1 == rte4)
    self.assertTrue(rte1 != rte4)

    rte5 = TableEntry(dst=host1, latency=10, expire_time=500)
    self.assertNotEqual(rte1, rte5)
    self.assertFalse(rte1 == rte5)
    self.assertTrue(rte1 != rte5)

  def test_equality_forever (self):
    """Makes sure expire_time=FOREVER doesn't mess with equality tests."""
    host1 = HostEntity()
    host1.name = "host1"

    rte1 = TableEntry(dst=host1, latency=10,
                      expire_time=TableEntry.FOREVER)
    rte2 = TableEntry(dst=host1, latency=10,
                      expire_time=TableEntry.FOREVER)
    self.assertEqual(rte1, rte2)
    self.assertTrue(rte1 == rte2)
    self.assertFalse(rte1 != rte2)
    self.assertEqual(hash(rte1), hash(rte2))
