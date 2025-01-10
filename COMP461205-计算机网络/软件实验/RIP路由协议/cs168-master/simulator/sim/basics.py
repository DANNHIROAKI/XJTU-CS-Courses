"""
Subclasses of simulator API things.
"""

import sim.api as api


class BasicHost (api.HostEntity):
  """
  Basic host with a ping method
  """
  ENABLE_PONG = True       # Send Pong in reponse to ping?
  ENABLE_DISCOVERY = True  # Send HostDiscoveryPacket when link goes up?

  def ping (self, dst, data=None, color=None):
    """
    Sends a Ping packet to dst.
    """
    self.send(Ping(dst, data=data, color=color), flood=True)

  def handle_link_up (self, port, latency):
    """
    When a link comes up, send a message to the other side
    This is us saying hello so that the other side knows who we are.  In the
    real world this is *vaguely* similar to some uses of ARP, maybe DHCP,
    IPv6 NDP, and probably some others.  But only vaguely.
    """
    if self.ENABLE_DISCOVERY:
      self.send(HostDiscoveryPacket(), flood=True)

  def handle_rx (self, packet, port):
    """
    Handle packets for the BasicHost
    Silently drops messages to nobody.
    Warns about received messages to someone besides itself.
    Prints received messages.
    Returns Pings with a Pong.
    """
    if packet.dst is api.NullAddress:
      # Silently drop messages not to anyone in particular
      return

    trace = ','.join((s.name for s in packet.trace))

    if packet.dst is not self:
      self.log("NOT FOR ME: %s %s" % (packet, trace), level="WARNING")
    else:
      self.log("rx: %s %s" % (packet, trace))
      if type(packet) is Ping and self.ENABLE_PONG:
        # Trace this path
        import sim.core as core
        core.events.highlight_path([packet.src] + packet.trace)
        # Send a pong response
        self.send(Pong(packet), port)


class Ping (api.Packet):
  """
  A Ping packet
  """
  def __init__ (self, dst, data=None, color=None):
    super(Ping,self).__init__(dst=dst)
    self.data = data
    self.outer_color[3] = 0.8 # Mostly opaque
    self.inner_color = [1,1,1,.8] # white
    if color:
      for i,c in enumerate(color):
        self.outer_color[i] = c

  def __repr__ (self):
    d = self.data
    if d is not None:
      d = ': ' + str(d)
    else:
      d = ''
    return "<%s %s->%s ttl:%i%s>" % (type(self).__name__,
                                     api.get_name(self.src),
                                     api.get_name(self.dst),
                                     self.ttl, d)


class Pong (api.Packet):
  """
  A Pong packet
  It's a returned Ping.  The original Ping is in the .original property.
  """
  def __init__ (self, original):
    super(Pong,self).__init__(dst=original.src)
    self.original = original

    # Flip colors from original
    self.outer_color = original.inner_color
    self.inner_color = original.outer_color

  def __repr__ (self):
    return "<Pong " + str(self.original) + ">"


class HostDiscoveryPacket (api.Packet):
  """
  Just a way that hosts say hello
  """
  def __init__ (self, *args, **kw):
    # Call original constructor
    super(HostDiscoveryPacket, self).__init__(*args, **kw)
    self.outer_color = [1,1,0,1]
    self.inner_color = [1,1,0.5,0.5]


class RoutePacket (api.Packet):
  def __init__ (self, destination, latency):
    super(RoutePacket,self).__init__()
    self.latency = latency
    self.destination = destination
    self.outer_color = [1,0,1,1]
    self.inner_color = [1,0,1,1]

  def __repr__ (self):
    return "<RoutePacket to %s at cost %s>" % (self.destination, self.latency)


class DVRouterBase (api.Entity):
  """
  Base class for implementing a distance vector router
  """
  POISON_MODE = False # If self.POISON_MODE is True, send poisons.
  DEFAULT_TIMER_INTERVAL = 5 # Default timer interval.

  def start_timer (self, interval = None):
    """
    Start the timer that calls handle_timer()
    This should get called in the constructor.  You shouldn't override this.
    """
    if interval is None:
      interval = self.DEFAULT_TIMER_INTERVAL
      if interval is None: return
    api.create_timer(interval, self.handle_timer)

  def handle_timer (self):
    """
    Called periodically when the router should send tables to neighbors
    You probably want to override this.
    """
    pass