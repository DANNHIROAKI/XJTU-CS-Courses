"""
This module lets the simulator communicate with external things like the
log viewer and NetVis.
"""

import sim
import sim.comm as comm
import socket
import json
import threading
import traceback

import sim.core as core

class StreamingConnection (comm.NullInterface):
  READ_TIMEOUT = 5

  def __init__ (self, parent, sock):
    self.sock = sock
    self.parent = parent
    self.thread = threading.Thread(target = self._recvLoop)
    self.thread.daemon = True
    self.thread.start()
    self._send_initialize()

  def _send_initialize (self):
    parent = self.parent

    def make (a,A, b,B):
      a = a.entity.name
      b = b.entity.name
      if a <= b:
        return (a,A,b,B)
      return (b,B,a,A)

    links = set()
    for te in core.topo.values():
      for n,p in enumerate(te.ports):
        if p is None: continue
        links.add(make(te, n, p.dst, p.dstPort))
    links = [list(e) for e in links]

    import sim.api
    msg = {
      'type':'initialize',
      'entities':dict([(n.entity.name,
                   'circle' if isinstance(n.entity, sim.api.HostEntity) else 'square')
                  for n in core.topo.values()]),
      #      'entities': {},
      'links':links,
    }
    parent.send(msg, connections=self)
    if core.world.info:
      msg = {
        'type':'info', 'text':core.world.info
      }
      parent.send(msg, connections=self)

  def _recvLoop (self):
    import select
    d = bytes()
    retry = 0
    while True:
      try:
        (rx, tx, xx) = select.select([self.sock], [], [self.sock],
                                     self.READ_TIMEOUT)
      except Exception:
        # sock died
        break
      if len(xx):
        #TODO: reopen?
        break
      if len(rx):
        try:
          r = self.sock.recv(4096)
          if len(r) == 0:
            retry += 1
            if retry > 4: break
            continue
          else:
            retry = 0
          d = d + r
        except Exception:
          #TODO: reopen
          break
        while d.find('\n'.encode()) >= 0:
            l,d = d.split('\n'.encode(), 1)
            self._process_incoming(l)
    core.events._disconnect(self)

  def _process_incoming (self, l):
    """
    Process an incoming message (single JSON object)
    """
    l = l.decode().strip()
    if len(l) == 0: return
    methodName = "<UNSET>"
    try:
      data = json.loads(l)
      methodName = "_handle_" + data.get('type', "<UNDEFINED>")
      m = getattr(self, methodName)
      del data['type']
      core.world.doLater(0, m, **data)
    except Exception:
      core.simlog.error("Error dispatching " + methodName)
      traceback.print_exc()

  def _handle_ping (self, node1, node2):
      import sim.basics as basics
      node1 = core._getByName(node1).entity
      node2 = core._getByName(node2).entity
      if node1 and node2:
        node1.send(basics.Ping(node2), flood=True)

  def _handle_console (self, command):
      # Execute python command, return output to GUI
      r = interp.runsource(command, "<gui>")
      if r:
        core.events.send_console_more(command)

  def _handle_addEdge (self, node1, node2):
    node1 = core._getByName(node1)
    node2 = core._getByName(node2)
    if node1 and node2:
      if not node1.isConnectedTo(node2):
        node1.linkTo(node2)

  def _handle_delEdge (self, node1, node2):
    node1 = core._getByName(node1)
    node2 = core._getByName(node2)
    if node1 and node2:
      if node1.isConnectedTo(node2):
        node1.unlinkTo(node2)

  def _handle_disconnect (self, node):
    node = core._getByName(node)
    if node:
      node.disconnect()

  def send_raw (self, msg):
    try:
      self.sock.send(msg.encode())
    except Exception:
      try:
        self.sock.close()
      except Exception:
        pass
      self.sock = None
      #TODO: reopen?
      pass

  def _close (self):
    self.sock.close()


class StreamingInterface (object):
  CONNECTION_CLASS = StreamingConnection

  def __init__ (self):
    self.connections = []

    self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    self.sock.bind((sim.config.remote_interface_address,
                    sim.config.remote_interface_port))
    self.sock.listen(5)
    self.thread = threading.Thread(target = self._listenLoop)
    self.thread.daemon = True
    self.thread.start()

  def _listenLoop (self):
    import select
    try:
      while True:
        (rx, tx, xx) = select.select([self.sock], [], [self.sock])
        if len(xx): break
        sock,addr = self.sock.accept()
        #print "connect",addr
        self.connections.append(self.CONNECTION_CLASS(self, sock))
    except Exception:
      traceback.print_exc()
      pass
    core.simlog.debug("No longer listening for remote interfaces")

  def _disconnect (self, con):
    try:
      con._close()
    except Exception:
      pass
    try:
      self.connections.remove(con)
      #print "con closed"
    except Exception:
      pass

  def send(self, msg, connections = None):
    if connections is None:
      connections = self.connections
    elif not isinstance(connections, list):
      connections = [connections]
    r = json.dumps(msg, default=repr) + "\n";
    bad = []
    for c in connections:
      try:
        c.send_raw(r)
      except Exception:
        bad.append(c)
    for c in bad:
      self._disconnect(c)

  def send_console(self, text):
    #self.send({'type':'console','msg':text})
    pass

  def send_console_more(self, text):
    #self.send({'type':'console_more','command':text})
    pass

  def send_info(self, msg):
    self.send({'type':'info', 'text': str(msg)})

  def send_log(self, record):
    self.send(record)

  def send_entity_down(self, name):
    self.send({
      'type':'delEntity',
      'node':name,
      })

  def send_entity_up(self, name, kind):
    self.send(
      {
      'type':'addEntity',
      'kind':'square' if kind == 'switch' else 'circle',
      'label':name,
      })

  def send_link_up(self, srcid, sport, dstid, dport):
    self.send({
      'type':'link',
      'node1':srcid,
      'node2':dstid,
      'node1_port':sport,
      'node2_port':dport,
      })

  def packet (self, n1, n2, packet, duration, drop=False):
    m = {
      "type":"packet",
      "node1":n1,
      "node2":n2,
      "duration":duration * 1000,
      "stroke":packet.outer_color,
      "fill":packet.inner_color,
      "drop":drop,
      }
    #if color is not None:
    #  m['stroke'] = color
    self.send(m)

  def send_link_down(self, srcid, sport, dstid, dport):
    self.send({
      'type':'unlink',
      'node1':srcid,
      'node2':dstid,
      'node1_port':sport,
      'node2_port':dport,
      })

  def highlight_path (self, nodes):
    """ Sends a path to the GUI to be highlighted """
    nodes = [n.name for n in nodes]
    msg = {'type':'highlight', 'nodes':nodes}
    #self.send(msg)

  def set_debug(self, nodeid, msg):
    self.send({
      'type' : 'debug',
      'node' : nodeid,
      'msg': msg,
      })

interface = StreamingInterface
