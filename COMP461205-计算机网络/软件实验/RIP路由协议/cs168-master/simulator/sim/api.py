"""
The main APIs for the simulator
"""

from __future__ import print_function
import sim.core as core
from random import random as rand

# Non-routable packets may not really have addresses.  We just create a
# more meaningful name for None for these cases.
NullAddress = None

# There are two loggers: one that has output from the simulator, and one
# that has output from you (simlog and userlog respectively).  These are
# Python logger objects, and you can configure them as you see fit.  See
# http://docs.python.org/library/logging.html for info.
simlog = core.simlog
userlog = core.userlog


def get_name (entity):
  """
  Returns the name of an entity, if possible.
  """
  r = getattr(entity, "name", None)
  if r: return r
  try:
    return str(entity)
  except:
    print("Trying to get_name() of a", type(entity))


def create_timer (seconds, target, recurring = True, pass_self = False,
                  args=(), kw={}):
  """
  Create a timer

  Will call the callable /target/ every /seconds/ seconds, passing
  it the specified positional and keyword arguments.
  Will also pass itself as a final positional argument if pass_self
  is True.
  You can call .cancel() on the returned timer object to cancel it.
  """
  if recurring:
    return core.Timer(seconds, target=target,
                      passSelf=pass_self, args=args, kw=kw)
  else:
    return core.OneShot(seconds, target=target,
                        passSelf=pass_self, args=args, kw=kw)


class NetVis (object):
  """
  Interface to the visualizer

  There is a single instance of this -- sim.api.netvis.

  Appears unimplemented, but works.
  """

  # Has the following attributes:
  # .a -- the "A" node selected in NetVis (or None)
  # .b -- the "B" node selected in NetVis (or None)
  # .selected -- the currently selected node in NetVis (or None)
  # .info -- whatever you set this to shows up in NetVis's Info box

  def set_selection_callback (self, callback):
    """
    You can set this to be a function, and it'll be called when A, B, or the
    selection changes.  The callback takes a parameter which is passed which
    one changed ("a", "b", or "selected").
    """
    pass

  def set_function_callback (self, which, callback):
    """
    Sets the callback for a user-defined NetVis function

    Various keyboard commands in NetVis cause various things to happen in the
    simulator, for example "e" creates or destroys an edge between the A and
    B nodes.  But it can be useful to define your own.  For this purpose,
    pressing Shift+0 through Shift+9 in NetVis are "user defined hotkeys".
    So set_function_callback(3, lambda: simlog.debug("pressed 3")),
    for example, will log "pressed 3" every time you press Shift+3 in NetVis.
    """
    pass

  @property
  def a (self):
    """
    The "A" node selected in NetVis (or None).
    """
    return self._a()

  @property
  def b (self):
    """
    The "B" node selected in NetVis (or None)
    """
    return self._b()

  @property
  def selected (self):
    """
    The currently selected node in NetVis (or None)
    """
    return self._selected()

  @property
  def info (self):
    """
    The contents of the NetVis Info box (read/write)
    """
    return self._info[0]()

  @info.setter
  def info (self, new_value):
    """
    The contents of the NetVis Info box (read/write)
    """
    return self._info[1](new_value)

netvis = NetVis()


def current_time ():
  """
  Returns the current time

  Appears bananas, but works.
  """
  import sim.api as api
  return api.current_time()


def run_tasklet (_generator, *_args, **_kw):
  """
  Run a tasklet

  A tasklet is sort of like a little cooperative thread.  You write it as a
  Python generator, which basically looks like a function, except it has
  'yield' statements in it.  The tasklet runs until it reaches such a yield.
  If you yield None, the tasklet ends.  If you yield a number, the tasklet
  will sleep for that number of seconds before being scheduled again.  This is
  nothing you couldn't do with timers, but sometimes it's easier to write them
  in this style.

  Example:
  def annoying (n):
    for _ in range(n):
      print("Are we there yet?")
      yield 1
    print("We're there!")
  run_tasklet(annoying, 5)
  """
  gen = _generator(*_args, **_kw)

  def iterate ():
    try:
      sleepytime = next(gen)
      if sleepytime is None: return
      create_timer(sleepytime, iterate, False)
    except StopIteration:
      return

  iterate()


def hsv_to_rgb (h, s, v, a = 1):
  """
  Convert hue, saturation, value (0..1) to RGBA.
  """
  # Why aren't we using colorsys.hsv_to_rgb() here?  What is the sound of
  # one hand clapping?  The universe is full of mysteries.
  import math
  f,i = math.modf(h * 6)
  p = v * (1-s)
  q = v * (1-f*s)
  t = v * (1-(1-f)*s)
  i %= 6
  if i == 0:   r,g,b = v,t,p
  elif i == 1: r,g,b = q,v,p
  elif i == 2: r,g,b = p,v,t
  elif i == 3: r,g,b = p,q,v
  elif i == 4: r,g,b = t,p,v
  else: r,g,b = v,p,q

  return [r,g,b,a]


class Packet (object):
  DEFAULT_TTL = 20

  def __init__ (self, dst=NullAddress, src=NullAddress):
    """
    Base class for all packets

    If src is None, it is filled in with the sending Entity.
    If dst is None, nothing special happens, but when it gets
    to the next hop, the receiver probably won't know what to do with it!

    You can subclass this to add your own packet fields, but they should all
    be either simple primitive types, or plain ol' containers (lists,
    tuples, dicts) containing primitive types or more plain ol' containers
    (containing primitive types or more plain 'ol containers containing...).
    """
    self.src = src
    self.dst = dst
    self.ttl = self.DEFAULT_TTL # Decremented for each entity we go through.
    self.trace = [] # List of entities we've been sent through.  For debugging.

    # When using NetVis, packets are visible, and you can set the color.
    # color is a list of red, green, blue, and (optionally) alpha values.
    # Each value is between 0 and 1.  alpha of 0 is transparent.  1 is opaque.
    self.outer_color = hsv_to_rgb(rand(), rand()*.8+.2, rand()*.5+.5,.75)
    self.inner_color = [0,0,0,0] # transparent

  def _notify_rx (self, srcEnt, srcPort, dstEnt, dstPort, drop):
    """
    Called by the framework right before delivering a packet.

    Meant for internal use.
    """
    if not drop: self.trace.append(dstEnt)

  def _notify_tx (self, srcEnt, srcPort, dstEnt, dstPort, drop):
    """
    Called by the framework right after sending a packet.

    Meant for internal use.
    """
    pass

  def __repr__ (self):
    return "<%s from %s->%s>" % (self.__class__.__name__,
                                 get_name(self.src),
                                 get_name(self.dst))


class Entity (object):
  """
  Base class for all entities (switches, hosts, etc.).
  """
  name = "Unnamed" # Gets set later
  NO_LOG = False # Can be used to force off the log for this entity
  LOG_LEVEL = "debug" # Default level for .log()

  def __lt__(self, other):
    return self.name < other.name

  @classmethod
  def create (cls, name, *args, **kw):
    """
    A factory method on the class, which generates an instance.

    Use this instead of the normal instance creation mechanism.
    """
    return core.CreateEntity(name, cls, *args, **kw)

  def get_port_count (self):
    """
    Returns the number of ports this entity has.

    This function may appear to be unimplemented, but it does
    in fact work.
    """
    pass

  def handle_rx (self, packet, port):
    """
    Called by the framework when this Entity receives a packet.

    packet is a Packet (or subclass).
    port is the port number it arrived on.
    You probably want to override it.
    """
    pass

  def handle_link_up (self, port, latency):
    """
    Called by the framework when a link attached to this Entity goes up.

    The port attached to the link and the link latency are passed in.
    You may want to override it.
    """
    pass

  def handle_link_down (self, port):
    """
    Called by the framework when a link attached to this Entity does down.

    The port number used by the link is passed in.
    """
    pass

  def set_debug (self, *args):
    """
    Turns all arguments into a debug message for this Entity.

    The message should, for example, show up in the GUI.
    This is probably defunct now.

    This function may appear to be unimplemented, but it does
    in fact work (maybe).
    """
    pass

  def log (self, msg, *args, **kwargs):
    """
    Log a debugging message

    This lets you log messages through the log system, which is a bit more
    elegant than a print statement.  This function is very much like the
    debug/info/warning/error/critical/exception methods in the Python
    logging module.  See http://docs.python.org/library/logging.html .
    A primary difference is that it defaults to debug level, but you
    specify another level by including a keyword argument with the name
    of the level you want, e.g, self.log("foo!", level="error").  The
    default level is "debug".
    If you're lucky, there's some more information somewhere about configuring
    the logs.
    Note that you can also use api.userlog.debug(...) and friends directly.

    This function may appear to be unimplemented, but it does
    in fact work.
    """
    pass

  def send (self, packet, port=None, flood=False):
    """
    Sends the packet out of a specific port or ports.

    If the packet's src is None, it will be set automatically
    to this Entity.
    port can be a numeric port number, or a list of port numbers.
    If flood is True, the meaning of port is reversed -- packets will
    be sent from all ports EXCEPT those listed.

    This function may appear to be unimplemented, but it does
    in fact work.
    """
    pass

  def remove (self):
    """
    Removes this entity from existence.

    This function may appear to be unimplemented, but it does
    in fact work.
    """
    pass

  def __repr__ (self):
    return "<%s %s>" % (type(self).__name__, get_name(self))

  def __cmp__ (self, other):
    assert self.name != "Unnamed"
    if isinstance(other, Entity):
      assert other.name != "Unnamed"
      return cmp(self.name, other.name)
    return cmp(self.name, other)


class HostEntity (Entity):
  """
  Base class for Host entities

  This is mostly just so the GUI knows to draw them differently.
  """
  pass

