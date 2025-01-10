def launch (logger=None, level="ERROR"):
  import logging
  level = level.upper()
  items = vars(logging)
  assert level in items
  level = items[level]
  assert type(level) is type(1)
  if logger:
    for logger in logger.split(","):
      logging.getLogger(logger).setLevel(level)
  else:
    logging.getLogger(logger).setLevel(level)
