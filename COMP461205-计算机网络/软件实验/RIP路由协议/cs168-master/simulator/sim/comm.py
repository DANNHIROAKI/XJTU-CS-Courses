"""
This simulator can call methods in this class to inform external
programs that various events have occurred.
"""

class NullInterface (object):
  """ Interface that does nothing / base class """
  def send_console(self, text):
    pass

  def send_console_more (self, text):
    pass

  def send_log (self, record):
    pass

  def send_entity_down (self, name):
    pass

  def send_entity_up (self, name, kind):
    pass

  def send_link_up (self, srcid, sport, dstid, dport):
    pass

  def send_info (self, msg):
    pass

  def packet (self, n1, n2, packet, duration, drop=False):
    pass

  def send_link_down (self, srcid, sport, dstid, dport):
    pass

  def highlight_path (self, nodes):
    """ Sends a path to the GUI to be highlighted """
    pass

  def set_debug (self, nodeid, msg):
    pass


  def _handle_function (self, which):
    """
    Called when a remote function is invoked.

    The identifier of the function is passed in "which".
    """
    import sim.core as core
    core.world.do_function(which)

  def _handle_selection (self, update=None, selected=None, unselected=None, a=None, b=None):
    """
    Called when a remote selection is made / changed

    selected is the currently selected node
    unselected is the *previously* selected node if any
    a and b are the current A and B nodes
    update holds the name of the field that is being updated if any
    """
    import sim.core as core
    core.world.do_selection(update=update, selected=selected, unselected=unselected, a=a, b=b)


interface = NullInterface
