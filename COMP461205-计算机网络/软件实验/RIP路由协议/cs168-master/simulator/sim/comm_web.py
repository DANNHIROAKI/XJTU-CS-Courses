"""
This module lets the simulator communicate with external things like the
WebNetVis.
The factoring with comm_tcp is really ugly.  The comm stuff in general
is all pretty far off from where it started now.  It's gotten crufty and
needs a major rewrite/refactor.
"""

import sim
import sim.comm as comm
import socket
import errno
import json
import threading
import traceback


import logging

import sim.core as core

log = logging.getLogger("web")
log.setLevel(logging.INFO)

from .comm_tcp import StreamingConnection

import posixpath
import base64
import hashlib
import struct

import sys
import os
_base_path = os.path.join(os.path.dirname(os.path.realpath(sys.argv[0])),"../netvis/NetVis/")

try:
  from SimpleHTTPServer import SimpleHTTPRequestHandler
  from BaseHTTPServer import HTTPServer
  from SocketServer import ThreadingMixIn
  import urllib
  url_unquote = urllib.unquote
except:
  from http.server import SimpleHTTPRequestHandler
  from http.server import HTTPServer
  from socketserver import ThreadingMixIn
  import urllib.parse
  url_unquote = urllib.parse.unquote


try:
  _ = b' '[0] + 1
  # Python3
  _ord = lambda x:x
  _chr = lambda x:bytes([x])
except Exception:
  # Python2
  _ord = ord
  _chr = chr

class WebHandler (SimpleHTTPRequestHandler, StreamingConnection):
  _websocket_open = False # Should be protected by a lock, but isn't

  WS_CONTINUE = 0
  WS_TEXT = 1
  WS_BINARY = 2
  WS_CLOSE = 8
  WS_PING = 9
  WS_PONG = 10

  protocol_version = "HTTP/1.1"

  def _get_base_path (self):
    return _base_path

  def translate_path (self, path):
    """
    Translate a web path to a local filesystem path
    This is substantially similar to the one in the base class, but it
    doesn't have an unhealthy relationship with the current working
    directory.
    """
    out_path = self._get_base_path()
    path = path.split('?',1)[0].split('#',1)[0].strip()
    has_trailing_slash = path.endswith('/')
    parts = posixpath.normpath(url_unquote(path)).split('/')
    for part in parts:
      if not part.replace('.',''): continue
      if os.path.dirname(part): continue
      if part == os.curdir: continue
      if part == os.pardir: continue
      out_path = os.path.join(out_path, part)
    if has_trailing_slash: out_path += '/'
    return out_path

  def log_message (self, format, *args):
    log.debug(format, *args)

  @property
  def parent (self):
    """
    Used by parent comm class
    """
    return self.server

  @property
  def sock (self):
    """
    Used by parent comm class
    """
    return self.rfile

  def _send_initialize (self):
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
    self.parent.send(msg, connections=self)
    if core.world.info:
      msg = {
        'type':'info', 'text':core.world.info
      }
      self.parent.send(msg, connections=self)

  def _close (self):
    self._websocket_open = False
    try:
      pass #self.wfile.close()
    except Exception:
      pass
    try:
      pass #self.rfile.close()
    except Exception:
      pass

  def _serve_websocket (self):
    self._websocket_open = True
    self.close_connection = 1

    log.debug("Upgrading to websocket")
    self.send_response(101, "Switching Protocols")
    k = self.headers.get("Sec-WebSocket-Key", "")
    k += "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
    k = k.encode("UTF-8")
    k = base64.b64encode(hashlib.sha1(k).digest())
    k = k.decode("UTF-8")
    self.send_header("Sec-WebSocket-Accept", k)
    self.send_header("Upgrade", "websocket")
    self.send_header("Connection", "Upgrade")
    self.end_headers()

    self.parent.connections.append(self)

    self._send_initialize()

    def feeder ():
      data = b''
      old_op = None
      hdr = b''
      while self._websocket_open:
        while len(hdr) < 2:
          newdata = yield True
          if newdata: hdr += newdata

        flags_op,len1 = struct.unpack_from("!BB", hdr, 0)
        op = flags_op & 0x0f
        flags = flags_op >> 4
        fin = flags & 0x8
        if (len1 & 0x80) == 0: raise RuntimeError("No mask set")
        len1 &= 0x7f
        hdr = hdr[2:]

        while True:
          if len1 <= 0x7d:
            length = len1
            break
          elif len1 == 0x7e and len(hdr) >= 2:
            length = struct.unpack_from("!H", hdr, 0)
            hdr = hdr[2:]
            break
          elif len1 == 0x7f and len(hdr) >= 8:
            length = struct.unpack_from("!Q", hdr, 0)
            hdr = hdr[8:]
            break
          else:
            raise RuntimeError("Bad length")
          hdr += yield True

        while len(hdr) < 4:
          hdr += yield True

        mask = [_ord(x) for x in hdr[:4]]
        hdr = hdr[4:]

        while len(hdr) < length:
          hdr += yield True

        d = hdr[:length]
        hdr = hdr[length:]

        d = b"".join(_chr(_ord(c) ^ mask[i % 4]) for i,c in enumerate(d))

        if not fin:
          if op == self.WS_CONTINUE:
            if old_op is None: raise RuntimeError("Continuing unknown opcode")
          else:
            if old_op is not None: raise RuntimeError("Discarded partial message")
            old_op = op
          data += d
        else: # fin
          if op == self.WS_CONTINUE:
            if old_op is None: raise RuntimeError("Can't continue unknown frame")
            op = old_op
          d = data + d
          old_op = None
          data = b''
          if op == self.WS_TEXT: d = d.decode('utf8')

          if op in (self.WS_TEXT, self.WS_BINARY):
            self._ws_message(op, d)
          elif op == self.WS_PING:
            msg = self._frame(self.WS_PONG, d)
            self._send_real(msg)
          elif op == self.WS_CLOSE:
            if self._websocket_open:
              self._websocket_open = False
              #TODO: Send close frame?
          elif op == self.WS_PONG:
            pass
          else:
            pass # Do nothing for unknown type

    deframer = feeder()
    try:
      deframer.send(None)
    except StopIteration:
      pass # PEP 479?

    # This is nutso, but it just might work.
    # *Try* to read individual bytes from rfile in case it has some
    # buffered.  When it fails, switch to reading from connection.
    self.connection.settimeout(0)
    while True:
      try:
        deframer.send(self.rfile.read(1))
      except Exception:
        break

    import select
    while self._websocket_open:
      try:
        (rx, tx, xx) = select.select([self.connection], [], [self.connection],
                                     self.READ_TIMEOUT)
      except Exception:
        # sock died
        log.warn("Websocket died")
        break
      if len(xx):
        #TODO: reopen?
        break
      if len(rx):
        try:
          r = self.connection.recv(4096)
          deframer.send(r)
        except Exception:
          #TODO: reopen
          break

    log.debug("Done reading websocket")

    core.events._disconnect(self)

    #NOTE: We should probably send a close frame, but don't.
    self.server._disconnect(self)

  def do_GET (self):
    if self.headers.get("Upgrade") == "websocket":
      return self._serve_websocket()
    else:
      return super(WebHandler,self).do_GET()

  def _ws_message (self, opcode, data):
    self._process_incoming(data.encode("UTF-8"))

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

  @staticmethod
  def _frame (opcode, msg):
    def encode_len (l):
      if l <= 0x7d:
        return struct.pack("!B", l)
      elif l <= 0xffFF:
        return struct.pack("!BH", 0x7e, l)
      elif l <= 0x7FFFFFFFFFFFFFFF:
        return struct.pack("!BQ", 0x7f, l)
      else:
        raise RuntimeError("Bad length")

    op_flags = 0x80 | (opcode & 0x0F) # 0x80 = FIN
    hdr = struct.pack("!B", op_flags) + encode_len(len(msg))

    return hdr + msg

  def send_raw (self, msg):
    try:
      msg = self._frame(self.WS_TEXT, msg.encode())
      self._send_real(msg)
    except Exception as e:
      raise

  def _send_real (self, msg):
    try:
      self.wfile.write(msg)
      self.wfile.flush()
    except Exception:
      try:
        self.server._disconnect()
      except Exception:
        pass
      self._websocket_open = False
      #TODO: reopen?
      pass



ThreadingMixIn.daemon_threads = True


class WebInterface (ThreadingMixIn, HTTPServer):
  def __init__ (self):
    self.connections = []

    try:
      HTTPServer.__init__(self, (sim.config.remote_interface_address,
                                 sim.config.remote_interface_port),
                                WebHandler)
    except OSError as e:
      if e.errno == errno.EADDRINUSE:
        log.error("The webserver could not be started because the listening "
                  "port\nis already in use. "
                  "Try setting a different port by using the\n"
                  "--remote-interface-port=X option near the "
                  "start of the commandline,\nwhere X is a valid TCP port "
                  "number.")
        return
      raise


    self.thread = threading.Thread(target = self._start)
    self.thread.daemon = True
    self.thread.start()

    laddr = self.socket.getsockname()
    log.info("Webserver running at http://%s:%s",
             laddr[0],
             laddr[1])

  def _start (self):
    self.serve_forever()

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

interface = WebInterface