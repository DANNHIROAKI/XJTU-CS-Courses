import sim
try:
  from gutil import gutil
except ImportError:
  import gutil

def launch (filename, switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type):
  g = gutil.get_graph(filename)

  for n,d in g.nodes(data=True):
    t = d.get("entity_type", "switch")
    if t.lower() == "switch":
      t = switch_type
    elif t.lower() == "host":
      t = host_type
    else:
      try:
        t = sim._find_host_type(t)
      except RuntimeError:
        try:
          t = sim._find_switch_type(t)
        except RuntimeError:
          raise RuntimeError("Unknown entity_type: " + str(t))
    name = n
    e = t.create(n)
    d['_entity'] = e

  for u,v,d in g.edges(data=True):
    uu = g.node[u]['_entity']
    vv = g.node[v]['_entity']
    extra = {}
    if 'latency' in d: extra['latency'] = float(d['latency'])
    uu.linkTo(vv, **extra)
