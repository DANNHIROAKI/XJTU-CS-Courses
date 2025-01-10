import sim
from . import loader

def launch (switch_type = sim.config.default_switch_type, host_type = sim.config.default_host_type):
    """
    Loads a square topology specified in cs168.square_asym.topo.
    """
    loader.launch("./cs168/loopy4.topo", switch_type=switch_type, host_type=host_type)
