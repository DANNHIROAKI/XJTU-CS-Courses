class Packet extends BaseObject
{
  Edge e;
  boolean bToA;
  double duration;
  double startTime;
  int strokeColor = 0xFF000000, fillColor = 0;
  boolean drop;
  Vector2D fall_velocity;
  Vector2D oldpos, lastpos;
  boolean falling;

  Packet (Node start, Edge edge, double duration, boolean drop)
  {
    init(start, edge, duration, drop);
  }

  Packet (Node start, Node endOrEdge, double duration, boolean drop)
  {
    if (endOrEdge == null)
    {
      init(start, null, duration, drop);
      return;
    }
    else if (endOrEdge.getClass().getName() == "Edge")
    {
      init(start, endOrEdge, duration, drop);
      return;
    }

    for (Edge e : start.edges)
    {
      if ((e.a == start && e.b == endOrEdge)
       || (e.b == start && e.a == endOrEdge))
      {
        init(start, e, duration, drop);
        return;
      }
    }
    throw new RuntimeException("No edge for packet");
  }

  private void init (Node start, Edge edge, double duration, boolean drop)
  {
    e = edge;
    startTime = millis();
    if (e != null)
      bToA = start == e.b;
    else
    {
      duration = 1; // Already falling
      startTime -= 10;
    }
    this.duration = duration;
    this.drop = drop;
  }

  int fixColor (double alpha, int col)
  {
    int a = (col >> 24) & 0xff;
    a = ((int)(a * alpha)) << 24;
    return (col & 0xffFFff) | a;
  }

  boolean drawDrop ()
  {
    double p = (millis() - startTime) / duration;
    if (p > 1) return false;
    fall_velocity.y += 1;
    lastpos = lastpos.plus(fall_velocity);

    //double alpha = 1-p;
    double alpha = -pow(2.3,(float)((p-1)*3.3))+1;

    if ((strokeColor & 0xff000000) == 0)
      noStroke();
    else
      stroke(fixColor(alpha, strokeColor));
    if ((fillColor & 0xff000000) == 0)
      noFill();
    else
      fill(fixColor(alpha, fillColor));
    lastpos.drawCircle(10);

    return true;
  }

  boolean draw ()
  {
    if (falling)
    {
      return drawDrop();
    }
    double p = (millis() - startTime) / duration;
    if (p > 1)
    {
      if (drop)
      {
        // Initialize dropping phase
        falling = true;
        startTime = millis();
        this.duration = 500;
        if (lastpos != null && oldpos != null)
          fall_velocity = lastpos.minus(oldpos);
        else
          fall_velocity = new Vector2D();
        if (lastpos == null) lastpos = new Vector2D(bToA ? e.b.pos : e.a.pos);
        return drawDrop();
      }
      return false;
    }

    if (bToA) p = 1-p;
    Vector2D pos = e.a.pos.times(1-p).plus(e.b.pos.times(p));
    if ((strokeColor & 0xff000000) == 0)
      noStroke();
    else
      stroke(strokeColor);
    if ((fillColor & 0xff000000) == 0)
      noFill();
    else
      fill(fillColor);
    pos.drawCircle(10);
    oldpos = lastpos;
    lastpos = pos;
    return true;
  }
}

