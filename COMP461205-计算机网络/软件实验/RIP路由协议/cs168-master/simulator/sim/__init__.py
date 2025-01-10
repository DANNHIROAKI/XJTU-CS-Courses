"""
The network simulator.
This file contains a singleton which holds simulator configuration (sim.config)
and some helper junk.  The former *may* be useful to take a look at, but
generally the useful options can be set through the commandline in boot and
are hopefully documented there or elsewhere.
Students are expected to use api and basics, and should stay out most of the
rest of the files (particularly core).  cable *may* be useful if you want to
get very fancy with your testing.
"""
from __future__ import print_function

class SimConfiguration (object):
  """
  Singleton which holds some config type information
  """
  _default_switch_type = None
  _default_host_type = None

  gui_log = False
  console_log = True
  interactive = True
  readline = True # Use readline?

  debug_startup = False

  remote_interface = "tcp" # Probably "tcp", "udp", or None
  remote_interface_address = "127.0.0.1"
  remote_interface_port = 4444

  @property
  def default_switch_type (self):
    if self._default_switch_type: return self._default_switch_type
    from sim.api import Entity
    return Entity

  @default_switch_type.setter
  def default_switch_type (self, t):
    self._default_switch_type = _find_switch_type(t)

  @property
  def default_host_type (self):
    if self._default_host_type: return self._default_host_type
    from sim.basics import BasicHost
    return BasicHost

  @default_host_type.setter
  def default_host_type (self, t):
    self._default_host_type = _find_host_type(t)
    #print(">>>",self._default_host_type, self.default_host_type)



config = SimConfiguration()


def _try_import (name, verbose = None):
  if verbose is None: verbose = config.debug_startup

  if not name.startswith("sim."):
    m = _try_import("sim." + name, verbose = False)
    if m: return m

  try:
    import sys
    if name not in sys.modules:
      m = __import__(name, globals())
    return sys.modules[name]
  except ImportError:
    if verbose:
      import traceback
      print("While attempting to import '%s'..." % (name,))
      traceback.print_exc()
    return None


def _issubclass (sub, sup):
  # If you call ischild(my_pen, an_elephant), the answer is obviously False
  # and not an exception because my_pen is not an elephant.  Why Python's
  # issubclass() does not heed this straightforward logic is beyond me.
  # This fixes it.
  try:
    return issubclass(sub, sup)
  except:
    return False


def _find_host_type (name):
  """
  Tries to load a given entity by name
  Also works if it's just passed an entity!
  """
  if not name: return None
  import sim.api as api
  if _issubclass(name, api.Entity): return name

  module = _try_import(name, False)
  import sys
  if not module:
    if "." in name:
      mname,oname = name.rsplit(".", 1)
      module = _try_import(mname)
      if module:
        o = getattr(module, oname, None)
        if o: return o
    _ = _try_import(name, verbose=True) # Allow to error
  else:
    o = None
    for k,v in vars(module).items():
      if not hasattr(v, "__module__"): continue
      if sys.modules.get(v.__module__) is not module: continue
      if k == "DefaultHostType": return v
      if _issubclass(v, api.HostEntity) and not o and v.__module__ == name:
        o = v
    return o
  raise RuntimeError("Could not get host node type '%s'" % (name,))


def _find_switch_type (name):
  """
  Tries to load a given entity by name
  Also works if it's just passed an entity!
  """
  if not name: return None
  import sim.api as api
  if _issubclass(name, api.Entity): return name

  module = _try_import(name, False)
  import sys
  if not module:
    if "." in name:
      mname,oname = name.rsplit(".", 1)
      module = _try_import(mname)
      if module:
        o = getattr(module, oname, None)
        if o: return o
    _ = _try_import(name, verbose=True) # Allow to error
  else:
    o = None
    for k,v in vars(module).items():
      if not hasattr(v, "__module__"): continue
      if sys.modules.get(v.__module__) is not module: continue
      if k == "DefaultSwitchType": return v
      if _issubclass(v, api.Entity) and not _issubclass(v, api.HostEntity):
        if not o:
          o = v
    if o is not None:
      return o
  raise RuntimeError("Could not get switch node type '%s'" % (name,))