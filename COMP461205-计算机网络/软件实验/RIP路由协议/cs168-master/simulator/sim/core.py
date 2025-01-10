"""
The core of the network simulator.
Students should not need to inspect this module at all, and direct
utilization of functionality herein is liable to make you fail a
project.  Also, pieces of the implementation will change during
grading.
"""

from __future__ import print_function
import sys
import sim
import copy
import threading
try:
  import queue as Queue
except ImportError:
  import Queue
import time
import weakref

import logging
import traceback

class EventLogger (logging.Handler):
  _attributes = [
    'created','filename','funcName','levelname','levelno','lineno',
    'module','msecs','name','pathname','process','processName',
    'relativeCreated','thread','threadName','args',
  ]

  #def __init__ (self, *args, **kw):
  #  logging.Handler.__init__(self, *args, **kw)

  def emit (self, record):
    o = {'message' : self.format(record)}
    o['type'] = 'log'
    if True:
      for attr in self._attributes:
        if hasattr(record, attr):
          o[attr] = getattr(record, attr)
      fmt = self.formatter
      if fmt is None:
        fmt = logging._defaultFormatter
      o['asctime'] = fmt.formatTime(record)
      if record.exc_info:
        o['exc_info'] = [str(record.exc_info[0]),
                         str(record.exc_info[1]),
                         traceback.format_tb(record.exc_info[2],1)]
        o['exc'] = traceback.format_exception(*record.exc_info)
    if events: events.send_log(o)

if sim.config.console_log:
  logging.basicConfig(level=logging.DEBUG)
else:
  logging.getLogger().setLevel(logging.DEBUG)

logging.getLogger().addHandler(EventLogger())
simlog = logging.getLogger("simulator")
userlog = logging.getLogger("user")


#import code

class stdout_wrapper:
  def write (self, s):
    sys.__stdout__.write(s)
    events.send_console(s)

if sim.config.gui_log:
  sys.stdout = stdout_wrapper()
  sys.stderr = sys.stdout

#class Interp (code.InteractiveConsole):
#  def write (self, s):
#    events.send_console(s)
#interp = Interp(sys.modules['__main__'].__dict__)

#class NullAddressType (object):
#  """
#  There is one instance of this: NullAddress
#  It can be used for non-routable packets and such.  It has the
#  advantage over None of having a .name propery, so if you have
#  code that prints entity.name, it won't choke.
#  """
#  def __init__ (self):
#    self.name = "NullAddress"
#  def __repr__ (self):
#    return "<NullAddress>"
#NullAddress = NullAddressType()


def _catch (_f, *_args, **_kw):
  try:
    return _f(*_args, **_kw)
  except Exception:
    args = ", ".join(str(v) for v in _args)
    kws = ", ".join("%s=%s" % (k,v) for k,v in _kw.items())
    if args: args += ", "
    args += kws
    simlog.exception("Exception while executing %s(%s)" % (_f, args))


class Timer (object):
  """ It's a timer.
  You should just create this with api.create_timer()."""
  def __init__ (self, seconds, target=None, args=(), kw={}, passSelf=False):
    self.seconds = seconds
    world.doLater(seconds, self.timeout)
    self.func = target
    self.stopped = False
    self.args = list(args)
    self.kw = dict(kw)
    if passSelf:
      self.args = [self] + self.args

  def cancel (self):
    self.stopped = True

  def timer (self):
    if self.func:
      self.func(*self.args,**self.kw)

  def timeout (self):
    if self.stopped: return
    try:
      rv = self.timer()
      if rv is not False:
        world.doLater(self.seconds, self.timeout)
    except Exception:
      simlog.exception("Exception while executing a timer")
      #traceback.print_exc()


class OneShot (Timer):
  """ It's a single-shot timer.
  You should just create this with api.create_timer()."""
  def timeout (self):
    if self.stopped: return
    try:
      self.timer()
    except Exception:
      simlog.exception("Exception while executing a one-shot timer")
      #traceback.print_exc()


world = None
events = None


class World (object):
  """ Mostly this dispatches events in the simulator. """
  def __init__ (self):
    global world
    world = self

    self.queue = Queue.PriorityQueue()
    self._thread = None
    self._count = 0
    self.ended = False

    # When the world isn't running, items are put in the prelist.
    # They're added to the queue when the world is started, and
    # their start times are adjusted so that they are relative to
    # when the world was started, NOT to when they were added.
    self._prelist = []

    self.function_handler = {} # number -> handler for user-specific functions

    self.selected = None
    self.a = None
    self.b = None

    self._info = "<No Info!>"

    self._time = 0.0 # For virtual time
    self.max_timeout = 10

    self.trace = False
    self._running = True

    self.virtual_time = False

    import sim.api as api
    api.netvis._a = lambda : _getEntByName(self.a)
    api.netvis._b = lambda : _getEntByName(self.b)
    api.netvis._selected = lambda : _getEntByName(self.selected)
    api.netvis._info = (lambda : self._info, lambda v: self._set_info(v))
    def set_function_callback (which, callback):
      self.function_handler[which] = callback
    api.netvis.set_function_callback = set_function_callback
    def set_selection_callback (callback):
      def selection_callback (update, selected, unselected, a, b):
        callback(update)
      self.function_handler['selection'] = selection_callback
    api.netvis.set_selection_callback = set_selection_callback

    sim.api.current_time = lambda : self.time

    global events
    should_sleep = sim.config.interactive
    if sim.config.remote_interface == "tcp":
      import sim.comm_tcp as interface
    elif sim.config.remote_interface == "udp":
      import sim.comm_udp as interface
    elif sim.config.remote_interface == "web":
      import sim.comm_web as interface
    else:
      import sim.comm as interface
      should_sleep = False
    events = interface.interface()
    if should_sleep:
      # Sleep a sec to allow remote to possibly connect
      time.sleep(1)

  @property
  def virtual_time (self):
    return self._get_time == self._get_time_virtual

  @virtual_time.setter
  def virtual_time (self, virtual_time):
    extra = "_virtual" if virtual_time else "_real"
    for attr in "_get_time run".split():
      prefix = "" if attr.startswith("_") else "_"
      setattr(self, attr, getattr(self, prefix+attr+extra))

  def stop (self):
    self._running = False

  def _get_time_real (self):
    #if self._start_time is None:
    return time.time()

  @property
  def time (self):
    return self._get_time()


  def do_function (self, function_number):
    f = self.function_handler.get(function_number)
    if f: f()
    else: simlog.info("Function '%s' is not assigned", function_number)

  def do_selection (self, update=None, selected=None, unselected=None, a=None, b=None):
    self.selected = selected
    self.a = a
    self.b = b
    f = self.function_handler.get('selection')
    if f: f(update, selected, unselected, a, b)

  def _real_doLater (_self, _seconds, _method, *_args, **_kw):
    t = _self.time + _seconds
    _self._real_doAt(t, _method, *_args, **_kw)

  def _real_doAt (_self, _t, _method, *_args, **_kw):
    _self.queue.put((_t, _self._count, _method, _args, _kw))
    _self._count += 1

  @property
  def info (self):
    return self._info

  def _set_info (self, text):
    self._info = str(text)
    #TODO: Restore on reconnect
    events.send_info(self._info)

  @info.setter
  def info (self, text):
    self._set_info(text)

  def start (self, threaded=True):
    assert self._thread is None
    simlog.info("Starting simulation.")

    for a,b,c,d in self._prelist:
      self._real_doLater(a, b, *c, **d)
    self._prelist = []

    if threaded:
      self._thread = threading.Thread(target=self.run)
      self._thread.daemon = True
      self._thread.start()
    else:
      self._thread = threading.current_thread()
      self.run()

  def do (self, _method, *args, **kw):
    self.doLater(0, _method, *args, **kw)

  def doLater (_self, _seconds, _method, *_args, **_kw):
    if _self._thread is not None:
      _self._real_doLater(_seconds, _method, *_args, **_kw)
    else:
      _self._prelist.append((_seconds, _method, _args, _kw))

  def doAt (_self, _time, _method, *_args, **_kw):
    if _self._thread is not None:
      _self._real_doAt(_time, _method, *_args, **_kw)
    else:
      _self._prelist.append((_time-_self.time, _method, _args, _kw))

  def sleep (self, seconds):
    """
    Sleeps for the given amount of time

    Should NOT be called from within the simulation thread (only externally).
    """
    self.sleepUntil(seconds + self.time)

  def sleepUntil (self, time):
    """ Like sleep() except waits for an absolute time instead of relative. """
    assert threading.current_thread() is not self._thread
    event = threading.Event()
    self.doAt(time, event.set)
    event.wait()

  def _run_real (self):
    timeout = None
    waiting = Queue.PriorityQueue()

    try:
      while self._running:
        try:
          t = self.time
          while not waiting.empty():
            o = waiting.get()
            if o[0] <= t:
              self.queue.put(o)
              timeout = None
            else:
              waiting.put(o)
              o = waiting.get()
              waiting.put(o)
              timeout = o[0] - t
              break
          #print("World waiting for",timeout)

          o = self.queue.get(True, 5 if timeout is None else timeout)
        except Exception:
          #print("empty")
          continue

        t = self.time
        if o[0] > t:
          # Hasn't expired yet...
          #print("recycle")
          waiting.put(o)
          o = waiting.get()
          waiting.put(o)
          timeout = o[0] - t
          continue
        # Expired
        timeout = None
        if self.trace:
          if hasattr(o[2], "__self__"):
            print(o[2].__self__.__class__.__name__ + "." + o[2].__func__.__name__,end='')
          else:
            print(o[2],end='')
          print(o[3],o[4] if len(o[4]) else '')
        o[2](*o[3],**o[4])
        self._post_hook()
    except KeyboardInterrupt:
      pass
    except SystemExit:
      simlog.debug("Simulation stopped")
      raise
    except:
      simlog.exception("Simulation ended due to exception")
    finally:
      simlog.debug("Simulation ended")
      self.ended = True

  def _post_hook (self):
    pass


class TopoNode (object):
  """ A container for an Entity that connects it to other Entities and
      provides some infrastructure functionality. """

  ENABLE_TTL = True
  DEFAULT_CABLE_TYPE = None # Will default to BasicCable

  def __repr__ (self):
    e = str(self.entity)
    if e.startswith('<') and e.endswith('>'):
      e = e[1:-1]
    return "<T:" + str(self.entity) + ">"

  def get_ports (self):
    """ Returns (self, mynum, remote, remotenum) info about ports """
    o = []
    for n,p in enumerate(self.ports):
      if p is not None:
        o.append((self.entity.name,n,p.dstEnt.name,p.dstPort))
    return o

  def __init__ (self, numPorts = 0, growPorts =  True):
    self.ports = [None] * numPorts
    self.growPorts = growPorts
    self.entity = None

  def linkTo (self, topoEntity, cable = None, fillEmpty = True, latency = None):
    """
    You can specify a cable to use in several ways:
     None           Both directions use BasicCable
     Cable-Subclass Both directions use instances of Cable-Subclass
                    made with an empty argument list to the constructor
     (S->D,D->S)    A tuple.  Either end can be None (meaning to not
                    connect that direction), a Cable subclass (to get a
                    default instance), or a Cable instance.
    So the following are equivalent:
     a.linkTo(b, (C, None)); b.linkTo(a, (D, None))
      and
     a.linkTo(b, (C, D))
    """
    from sim.cable import Cable, BasicCable
    default_cable_type = self.DEFAULT_CABLE_TYPE or BasicCable
    if cable is None:
      cable = (default_cable_type, default_cable_type)
    elif isinstance(cable, Cable):
      raise RuntimeError("Can't share a single Cable in both directions!")
    elif isinstance(cable, tuple):
      pass
#    elif isinstance(cable, BidirectionalCable):
    else:
      cable = (cable, cable)

    def fixCableEnd (c, le, lp, re, rp):
      if c is None: c = default_cable_type
      # Add latency if the c is BasicCable - Kaifei Chen(kaifei@berkeley.edu)
      if isinstance(c, type) and issubclass(c, BasicCable):
        c = c(latency=latency)
      elif isinstance(c, type) and issubclass(c, Cable):
        c = c()
      c.initialize(le, lp, re, rp)
      return c

    topoEntity = topoOf(topoEntity)
    def getPort (entity):
      if not fillEmpty or entity.ports.count(None) == 0:
        assert self.growPorts
        entity.ports.append(None)
        return len(entity.ports) - 1
      return entity.ports.index(None)

    assert topoEntity is not self

    remotePort = getPort(topoEntity)
    localPort = getPort(self)

    world.doLater(0, events.send_link_up, self.entity.name, localPort,
             topoEntity.entity.name, remotePort)

    if cable[0] is not None:
      c = fixCableEnd(cable[0], self, localPort, topoEntity, remotePort)
      self.ports[localPort] = c

      world.do(_catch, self.entity.handle_link_up, localPort, c.latency)

    if cable[1] is not None:
      c = fixCableEnd(cable[1], topoEntity, remotePort, self, localPort)
      topoEntity.ports[remotePort] = c

      world.do(_catch, topoEntity.entity.handle_link_up, remotePort, c.latency)

    return (localPort, remotePort)

  def unlinkTo (self, topoEntity, right_now=False):
    topoEntity = topoOf(topoEntity)
    def goDown (index):
      port = self.ports[index] # Actually the cable
      if port is None: return
      other = port.dst
      otherPort = port.dstPort
      port._handle_disconnect()
      events.send_link_down(self.entity.name, index, other.entity.name, otherPort)

      _catch(other.entity.handle_link_down, otherPort)
      _catch(self.entity.handle_link_down, index)

      other.ports[otherPort] = None
      self.ports[index] = None

    remove = [index for index,value in enumerate(self.ports)
              if value is not None and value.dst is topoEntity]
    for index in remove:
      if right_now:
        world.do(goDown, index)
      else:
        world.doLater(0, goDown, index)

  def isConnectedTo (self, other):
    other = topoOf(other)
    for p in self.ports:
      if p is None: continue
      if p.dst is other:
        return True
    return False

  def disconnect (self):
    for p in (port for port in self.ports if port):
      self.unlinkTo(p.dst)

  def send (self, packet, port, flood = False):
    """
    Port can be a port number or a list of port numbers.
    If flood is True, Port can be a port number NOT to flood out of
    or None to flood all ports.
    """
    if self.ENABLE_TTL:
      packet.ttl -= 1
      if packet.ttl == 0:
        simlog.warning("Expired %s / %s", packet, ','.join(e.name for e in packet.trace))
        return

    if (packet.src is None):# or (packet.src is NullAddress):
      packet.src = self.entity

    if not isinstance(port, (list,set,tuple)):
      ports = [port]
    elif port is None:
      ports = []
    else:
      ports = list(port)

    if flood:
      ports = [p for p in  range(0, len(self.ports)) if p not in ports]

    for remote in ports:
      if remote >=0 and remote < len(self.ports):
        remote = self.ports[remote]
        if remote is not None:
          p = _duplicate_packet(packet)
          remote.transfer(p)


def _duplicate_packet (p):
  n = type(p).__new__(type(p))
  for k,v in vars(p).items():
    if isinstance(v, (dict, tuple, list, set)):
      setattr(n, k, copy.copy(v))
    else:
      setattr(n, k, v)
  return n


_builtin = sys.modules.get('__builtin__', sys.modules.get('builtins')).__dict__

def _getByName (name):
  # Ugh.
  return topoOf(_builtin.get(name, None))

def _getEntByName (name):
  t = _getByName(name)
  if not t: return t
  return t.entity

topo = weakref.WeakValueDictionary()
def CreateEntity (_name, _kind, *args, **kw):
  """
  Creates an Entity of kind, where kind is an Entity subclass.
  name is the name for the entity (e.g., "s1").
  Additional arguments are pased to the new Entity's __init__().
  Returns the TopoNode containing the new Entity.
  """
  if _name in _builtin:
    raise NameError(str(_name) + " already exists")
  import sim.api as api

  e = _kind(*args, **kw)
  setattr(e, 'name', _name)
  numPorts = 0
  growPorts = True
  if hasattr(e, 'num_ports'):
    ports = e.num_ports
    growPorts = False

  te = TopoNode(numPorts, growPorts)
  te.entity = e

  kind = "host" if isinstance(e, api.HostEntity) else "switch"
  world.do(events.send_entity_up,e.name, kind)
  simlog.info(e.name+" up!")

  # Add working methods
  setattr(e, 'get_port_count', lambda : len(te.ports))
  def send (packet, port=None, flood=False):
    te.send(packet, port, flood)
  setattr(e, 'send', send)
  def set_debug (*args):
    #print(e.name + ':', ' '.join((str(s) for s in args)))
    world.do(events.set_debug,e.name, ' '.join((str(s) for s in args)))
  setattr(e, 'set_debug', set_debug)
  def log (msg, *args, **kw):
    if getattr(e, 'NO_LOG', False): return
    level = getattr(e, 'LOG_LEVEL', "debug")
    if "level" in kw:
      level = kw["level"].lower()
      del kw["level"]
    if level not in ['debug', 'info', 'warning', 'error', 'critical', 'exception']:
      level = "debug"
    func = getattr(userlog, level)
    msg = "%s:" + str(msg) # Black magic
    args = tuple([e.name] + list(args))
    func(msg, *args, **kw)
  setattr(e, 'log', log)

  for m in ['linkTo', 'unlinkTo', 'disconnect']:
    setattr(e, m, getattr(te, m))

  def remove ():
    te.disconnect()
    world.do(events.send_entity_down,_name)
    try:
      del _builtin[_name]
    except Exception:
      pass
  setattr(e, 'remove', remove)

  # Make a global variable with the right name
  #sys.modules['__main__'].__dict__[_name] = e
  #sim.__dict__[_name] = e
  _builtin[_name] = e

  # This is so we can find its TopoNode
  topo[e] = te
  return e

def topoOf (entity):
  """ Get TopoNode that contains entity.  Students never use this. """
  if type(entity) is TopoNode:
    # We were actually passed a topo object
    return entity
  t = topo.get(entity, None)
  return t
