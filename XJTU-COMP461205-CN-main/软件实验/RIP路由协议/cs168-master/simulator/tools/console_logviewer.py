#!/usr/bin/env python

def out (s, level="INFO"):
  print s

def prog ():
  import socket
  import json
  import time
  while True:
    sock = None
    try:
      sock = socket.socket()
      sock.connect(('127.0.0.1', 4444))
      out("--- Connected ----------------------")
      d = ''
      while True:
        r = sock.recv(4096)
        if len(r) == 0: raise RuntimeError()
        d += r
        while d.find('\n') != -1:
          msg,d = d.split("\n", 1)
          msg = json.loads(msg)
          if msg.get("type") == "log":
            #print msg
            r = msg['asctime'].split(',',1)[0].split(' ', 1)[1]
            r += " "
            r += "%-10s" % (msg['levelname'],)
            r += ' '
            r += msg['message']
            if msg['name'] == 'user':
              r = "U " + r
            elif msg['name'] == 'simulator':
              r = "S " + r
            else:
              r = msg['name'][0].lower() + " " + r

            out(r,msg['levelname'])
    except:
      #import traceback
      #traceback.print_exc()
      try:
        sock.close()
      except:
        pass
      time.sleep(0.25)

if __name__ == '__main__':
  prog()
