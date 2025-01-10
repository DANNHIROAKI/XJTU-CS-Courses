#!/usr/bin/env python

from Tkinter import *
from ScrolledText import *
from tkFont import Font
from Queue import Queue, Empty

class LogWindow (Frame):
  def __init__ (self, master=None):
    Frame.__init__(self, master)
    self.master.title("Network Simulator Log")
    self.text = ScrolledText(self)
    self.text.pack(fill=BOTH,expand=1)
    self.pack(fill=BOTH,expand=1)
    self.text.config(
        background="black",
        foreground="white",
        font=Font(family="Courier", weight="bold"),
        #state=DISABLED,
        wrap=NONE,
        )

    self.text.tag_config("DEBUG", foreground="green")
    self.text.tag_config("ERROR", foreground="red")
    self.text.tag_config("CRITICAL", foreground="red")
    self.text.tag_config("EXCEPTION", foreground="red")
    self.text.tag_config("WARNING", foreground="yellow")
    self.text.tag_config("INFO", foreground="white")

    self.text.bind("<Key>", lambda e: 'break')
    self.text.bind("<Return>", self._clear)
    self.queue = Queue()
    self._update()

  def _clear (self, event):
    self.text.delete(1.0, END)
    return 'break'

  def _update (self):
    try:
      while True:
        text,level = self.queue.get(block=False)

        at_bottom = self.text.yview()[1] == 1.0
        #self.text.config(state=NORMAL)
        if len(self.text.get(1.0, END).strip()) != 0:
          text = "\n" + text
        self.text.insert(END, text, str(level))
        #self.text.config(state=DISABLED)
        if at_bottom:
          self.text.yview_moveto(1.0)
    except Empty:
      pass
    self.after(50, self._update)

  def append (self, entry, level="INFO"):
    self.queue.put((entry,level))


def prog (logWindow):
  import socket
  import json
  import time
  while True:
    sock = None
    try:
      sock = socket.socket()
      sock.connect(('127.0.0.1', 4444))
      logWindow.append("--- Connected ----------------------")
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

            logWindow.append(r,msg['levelname'])
    except:
      #import traceback
      #traceback.print_exc()
      try:
        sock.close()
      except:
        pass
      time.sleep(0.25)

import threading

def launch (logWindow):
  t = threading.Thread(target = prog, args=(logWindow,))
  t.daemon = True
  t.start()

if __name__ == '__main__':
  def launchLog ():
    logWindow = LogWindow()
    logWindow.after(100, lambda : launch(logWindow))
    logWindow.mainloop()
  launchLog()
