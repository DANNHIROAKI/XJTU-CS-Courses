#!/usr/bin/env python
"""
Starts up the simulator

Commandlines are a combination of simulator arguments, modules, and arguments
for the modules.  Something like this:

boot.py --sim-flag1 --sim-arg1=foo module1 module2 --mod2-flag1

In that case, we're passing a flag and an argument to the simulator itself
(see the arguments to pre_options() and post_options() below to see what
they are).  We're also running two modules.  The first one takes no arguments.
The second one takes a flag.  You could look at (the hypothetical) module2.py's
launch() function to see what arguments it can take (in this case, it'd have
at least one called mod2_flag1).
"""

from __future__ import print_function
import sys
import sim
from sim import _try_import as try_import

w = None

simlog = None

variables = {}

_netvis_welcome = """
CS-168 Network Simulator
Select a node and hit A or B to make it A or B.
Press X to swap A and B.
Press E to add/remove a link between A and B.
Press P to send a ping between A and B.
Press D to disconnect the selected node.
Press o/O to to pin/unpin all nodes.
Press Shift+<Number> to invoke a custom function.
Read the NetVis source for more!
""".strip()

_console_welcome = """
CS-168 Network Simulator
You can get help on a lot of things.
For example, if you loaded a module called foo, try help(foo).
If you have a host named h1a, try help(h1a).
If you want to inspect a method of that host, try help(h1a.ping).
For help about the simulator and its API, try help(sim) and help(api).
Type start() to start the simulator (or pass --start).
Ctrl-D or exit() exits.
Good luck!
""".strip()

def main ():
  modules = []
  cmd = None # Special
  args = {}
  general_args = args

  for arg in sys.argv[1:]:
    if arg.startswith("--"):
      # An option
      arg = arg[2:]
      if "=" in arg:
        k,v = arg.split("=", 1)
      else:
        if arg.startswith("no-"):
          k = arg[3:]
          v = False
        else:
          k = arg
          v = True
      k = k.replace("-", "_")
      args[k] = v
    else:
      cmd = arg
      args = {}
      modules.append((cmd, args))

  remaining = pre_options(**general_args)

  pymods = []
  for name, args in modules:
    m = launch_module(name, args)
    if not m:
      _fail("Could not launch all modules.")
      return
    pymods.append( (name, m) )

  post_options(**remaining)

  import sim.api
  sim.api.netvis.info = _netvis_welcome

  if sim.config.interactive:
    import code

    import sim.core as core
    import sim.basics as basics
    import topos as topo_package
    variables['start'] = core.world.start
    variables['sim'] = sys.modules['sim']
    variables['api'] = sim.api
    variables['topos'] = topo_package
    variables['basics'] = sim.basics
    for k,v in pymods:
      if "." in k:
        variables[k.rsplit(".")[-1]] = v
      variables[k.replace('.', '_')] = v
    if sim.config.readline:
      try:
        import readline
      except:
        pass
    _monkeypatch_console()
    interp = code.InteractiveConsole(locals=variables)
    interp.interact("")
  else:
    # Non-interactive always starts automatically
    import sim.core as core
    core.world.start(threaded=False)


def pre_options (default_host_type = None, default_switch_type = None,
                 gui_log = False, console_log = True, debug_startup = True,
                 remote_interface = "web", remote_interface_port = 4444,
                 remote_interface_address = "127.0.0.1", interactive = True,
                 very_quiet = False, readline = True,
                 **kw):
  """
  Set up initial options and create world

  Should return unused options (which will be passed to post_options)
  """

  if very_quiet:
    # Be very, very quiet!
    sim.config.console_log = False
    class Dummy (object):
      def write (self, *args, **kw):
        pass
    import sys
    sys.stdout = Dummy()
    sys.stderr = Dummy()

  sim.config.gui_log = gui_log
  sim.config.console_log = console_log
  sim.config.debug_startup = debug_startup
  sim.config.interactive = interactive
  sim.config.readline = readline

  sim.config.default_host_type = default_host_type
  sim.config.default_switch_type = default_switch_type

  sim.config.remote_interface = remote_interface
  sim.config.remote_interface_port = int(remote_interface_port)
  sim.config.remote_interface_address = remote_interface_address

  print(_console_welcome)

  import sim.core as core
  global w
  w = core.World()
  global simlog
  simlog = core.simlog

  return kw


def post_options (start = False, **kw):
  if kw:
    _fail("No such option as '%s'", list(kw.keys())[0])

  if sim.config.interactive and start:
    import sim.core as core
    core.world.start()


def launch_module (name, args):
  simlog.info("Launching module '%s'", name)

  module = try_import(name)

  if not module:
    _fail("Couldn't load module '%s'", name)
    return None

  launch = getattr(module, "launch", None)
  if launch:
    launch(**args)
  elif args:
    _fail("Module %s does not take arguments", name)
    return None

  return module



def _fail (fmt, *args):
  if simlog:
    simlog.error(fmt, *args)
  else:
    sys.stderr.write( (fmt % args) + "\n" )



def _monkeypatch_console ():
  """
  The readline in pypy (which is the readline from pyrepl) turns off output
  postprocessing, which disables normal NL->CRLF translation.  An effect of
  this is that output *from other threads* (like log messages) which try to
  print newlines end up just getting linefeeds and the output is all stair-
  stepped.  We monkeypatch the function in pyrepl which disables OPOST to
  turn OPOST back on again.  This doesn't immediately seem to break
  anything in the simple cases, and makes the console reasonable to use
  in pypy.

  This is borrowed from POX.
  """
  try:
    import termios
    import sys
    import pyrepl.unix_console
    uc = pyrepl.unix_console.UnixConsole
    old = uc.prepare
    def prep (self):
      old(self)
      f = sys.stdin.fileno()
      a = termios.tcgetattr(f)
      a[1] |= 1 # Turn on postprocessing (OPOST)
      termios.tcsetattr(f, termios.TCSANOW, a)
    uc.prepare = prep
  except:
    pass



if __name__ == '__main__':
  main()
