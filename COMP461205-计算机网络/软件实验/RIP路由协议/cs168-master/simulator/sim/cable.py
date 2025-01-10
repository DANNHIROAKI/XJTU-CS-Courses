"""
Cables are how Entities are connected
"""

import random
import sim.core as core

class Cable (object):
  """
  Connects two Entities.

  Entities can be connected by a Cable.  If no Cable is used, there's
  a default behavior.
  Note that a Cable is unidirectional.  In many cases, you'll actually
  want to install an identical Cable in both directions.
  """
  DEFAULT_LATENCY = 1
  latency = DEFAULT_LATENCY

  def initialize (self, src, srcport, dst, dstport):
    """ Called to set up the ends. """
    for a in ['src','srcPort','srcEntity',
              'dst','dstPort','dstEntity']:
      setattr(self, a, None)
    self.src = src
    self.srcPort = srcport
    self.srcEnt = src.entity
    self.dst = dst
    self.dstPort = dstport
    self.dstEnt = dst.entity

  def transfer (self, packet):
    """ Implement this in subclasses. """
    pass

  def get_connections (self):
    """ Return the list of things we're connected to. """
    pass

  def _handle_disconnect (self):
    """ Called when cable is disconnected from devices """
    pass


class DumbCable (Cable):
  """
  This is a plain old connection between two Entities.

  It just transfers the data after some amount of time.
  """
  def __init__ (self, latency = None):
    if latency is not None:
      self.latency = latency

  def transfer (self, packet):
    def rx ():
      packet._notify_rx(self.srcEnt, self.srcPort, self.dstEnt, self.dstPort, False)

      self.dstEnt.handle_rx(packet, self.dstPort)

    core.world.doLater(self.latency, rx)

    core.events.packet(self.srcEnt.name, self.dstEnt.name, packet, self.latency)
    packet._notify_tx(self.srcEnt, self.srcPort, self.dstEnt, self.dstPort, False)


class BasicCable (DumbCable):
  """
  A better-than-Dumb cable

  Models transmission delay as well as latency and properly drops packets
  which were on the wire when a link goes down (which is pretty important
  for sensible link down behavior).
  """
  DEFAULT_QUEUE_SIZE = None # Unlimited
  DEFAULT_TX_TIME = 0.1 # Transmission delay

  def __init__ (self, *args, **kw):
    self.size = kw.pop("queue_size", self.DEFAULT_QUEUE_SIZE)
    self.queue = [] # time, packet
    self.next_delivery = None

    super(BasicCable, self).__init__(*args, **kw)

    self.tx_time = kw.pop("tx_time", self.DEFAULT_TX_TIME)

    self._tx_stop = None # Time at which current transfer ends (or None)

  def drop (self):
    del self.queue[-1] # Tail drop

  def sched (self):
    if not self.queue: return
    assert [x[0] for x in self.queue] == [x[0] for x in sorted(self.queue, key=self._queue_key)]
    #self.queue.sort() # We could do better than this! (And have, apparently)
    t = self.queue[0][0]
    self.next_delivery = None
    if self.next_delivery is None or t < self.next_delivery:
      self.next_delivery = t
      core.world.doAt(t, self.deliver)

  def deliver (self):
    if self.src: self.old_src = self.src
    if self.dst: self.old_dst = self.dst
    self.next_delivery = None
    drop = False
    if not self.src or self.src.ports[self.srcPort] is not self:
      if self.queue:
        #print "DISCONNECTED",self.old_src,self.old_dst, self.queue
        drop = True
        return

    while self.queue:
      if self.queue[0][0] > core.world.time: break
      p = self.queue.pop(0)[1]
      self._do_deliver(p, drop)
    self.sched()

  def _do_deliver (self, p, drop):
    p._notify_rx(self.srcEnt, self.srcPort, self.dstEnt, self.dstPort, drop)
    if not drop:
      self.dstEnt.handle_rx(p, self.dstPort)

  def transfer (self, packet):
    now = core.world.time
    tx_time = self.tx_time
    if self._tx_stop is None or now >= self._tx_stop:
      # Not transferring
      tx_at = now
      self._tx_stop = now + tx_time
    else:
      # Transfer in progress
      tx_at = self._tx_stop
      self._tx_stop += tx_time

    self.queue.append((tx_at + tx_time + self.latency,packet))
    if self.size is not None and len(self.queue) > self.size:
      self.drop()

    if len(self.queue) >= 2:
      if self.queue[-1][0] < self.queue[-2][0]:
        # Deliver last before second-to-last?
        # Simple answer: just sort
        self.queue.sort(key=self._queue_key)

    self.sched()

    core.events.packet(self.srcEnt.name, self.dstEnt.name, packet, self.latency)

    packet._notify_tx(self.srcEnt, self.srcPort, self.dstEnt, self.dstPort, False)

  def _handle_disconnect (self):
    del self.queue[:]

  @staticmethod
  def _queue_key (queue_item):
    return queue_item[0]


class UnreliableCable (BasicCable):
  """
  Very much like its superclass except it drops packets sometimes.
  """
  @classmethod
  def pair (cls, latency = None, drop = .1, drop_reverse = None):
    """
    Create a pair of these (one for each direction)

    drop is the drop rate for A to B.
    drop_reverse is the drop rate for B to A (defaults to the same as drop)
    """
    if drop_reverse is None: drop_reverse = drop
    return ( cls(latency = latency, drop = drop),
             cls(latency = latency, drop = drop_reverse) )

  def __init__ (self, latency = None, drop = .1):
    """
    Drop 10% by default
    """
    super(UnreliableCable, self).__init__(latency = latency)
    self.drop_rate = drop

  def transfer (self, packet):
    # It'd be nice if we called notify_tx and not notify_rx for dropped packets
    # or something, but that'd require more work. :)
    if random.random() >= self.drop_rate:
      super(UnreliableCable, self).transfer(packet)
    else:
      core.events.packet(self.srcEnt.name, self.dstEnt.name, packet,
                         self.latency, drop=True)
