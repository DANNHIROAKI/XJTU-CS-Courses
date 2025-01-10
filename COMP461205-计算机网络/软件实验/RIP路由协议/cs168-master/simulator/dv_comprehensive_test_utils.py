from collections import defaultdict
import weakref
from cs168.dv import RoutePacket
import sim.api as api
from sim.basics import BasicHost, Ping
import sim.cable

all_hosts = set()
all_cables = weakref.WeakSet()


class TestHost(BasicHost):
    ENABLE_PONG = False

    def __init__(self):
        super(TestHost,self).__init__()
        self.rxed_pings = defaultdict(list) # src -> list((packet, time))
        self.reset()
        all_hosts.add(self)

    def reset(self):
        self.for_me = 0
        self.not_for_me = 0
        self.unknown = 0
        self.routes = 0
        self.rxed_pings.clear()

    def handle_rx(self, packet, port):
        if isinstance(packet, RoutePacket):
            self.routes += 1
        elif isinstance(packet, Ping):
            self.rxed_pings[packet.src].append((packet, api.current_time()))
            if packet.dst is self:
                self.for_me += 1
            else:
                self.not_for_me += 1
        else:
            self.unknown += 1


DefaultHostType = TestHost


def _set_up_cable_tracking():
    old_new = sim.cable.Cable.__new__
    def new_new(*args, **kw):
        if old_new is object.__new__:
            # This should probably always be the case...
            o = old_new(args[0])
        else:
            o = old_new(*args, **kw)
        all_cables.add(o)
        return o

    sim.cable.Cable.__new__ = staticmethod(new_new)


_set_up_cable_tracking()
sim.cable.BasicCable.DEFAULT_TX_TIME = 0


def launch():
    pass

