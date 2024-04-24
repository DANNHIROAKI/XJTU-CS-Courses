
abstract class Node extends BaseObject
{
  Vector2D pos;
  ArrayList<Edge> edges = new ArrayList<Edge>();
  boolean selected = false;
  boolean pinned = false;
  Vector2D pinOffset = new Vector2D();
  String label;

  abstract double getRadius ();

  Node ()
  {
    setRandomPos();
  }

  Node (Vector2D pos)
  {
    this.pos = pos;
  }

  private void setRandomPos ()
  {
    this.pos = new Vector2D(random(width), random(height));
  }

  boolean isConnectedTo (Node other)
  {
    for (Edge e : edges)
    {
      if (e.getOtherEnd(this) == other) return true;
    }
    return false;
  }

  void drawPin ()
  {
    strokeWeight(3);
    stroke(0x7fffffff);
    fill(0xFFffFFff);
    pos.trunc().plus(pinOffset).drawCircle(12);

    //noStroke();
    if (pinned) fill(0xff7f7f7f);

    pos.trunc().plus(pinOffset).drawCircle(9);
  }

  boolean click (Vector2D p)
  {

    double d = pos.plus(pinOffset).minus(p).getMagnitude();
    if (d < 12)
    {
      handle_click_pin();
      return true;
    }
    if (hit(p))
    {
      handle_click(p);
      return true;
    }
    return false;
  }

  void handle_click_pin ()
  {
    pinned = !pinned;
  }

  void handle_click (Vector2D p)
  {
    if (!selected)
    {
      if (edges.size() > 0)
      {
        int eNum = (int)random(edges.size());
        Edge e = edges.get(eNum);
        //app.packets.add(new Packet(this, e, 2000));
      }
    }

    for (Node n : g.nodes)
    {
      n.selected = false;
    }
    selected = true;
    app.dragged = this;
  }

  void drawLabel (Vector2D labelPos)
  {
    fill(0,0,0,64);
    labelPos.plus(1,1).drawTextCentered(label);
    fill(0,0,0);
    labelPos.drawTextCentered(label);
  }

  abstract double getCharge ();
  abstract boolean hit (Vector2D p);
  abstract void draw (Graph g);

  public String toString ()
  {
    String s = getClass().getName();
    if (label != null && label.length() > 0) s += " " + label;
    return "<" + s + ">";
  }

  void drawArrow ()
  {
    if (g.a == this)
    {
      double a = -PI/3;
      String l = "A";
      fill(0xffffffff);
      stroke(0xffffffff);
      drawArrow(pos.plus(polar(a, getRadius())), l, a, 0, false);
    }
    if (g.b == this)
    {
      double a = -PI + PI/3;
      String l = "B";
      fill(0);
      stroke(0xffffffff);
      drawArrow(pos.plus(polar(a, getRadius())), l, a, PI, true);
    }
  }

  void drawArrow (Vector2D pos, String label, double angle, float extra, boolean black)
  {

    //double angle = -Math.PI/3;
    double headLength = 12;
    double tailLength = headLength*.5;
    double headWidth = 15;
    double tailWidth = 7;
    Vector2D tip = pos;//new Vector2D(mouseX, mouseY);

    tip = tip.plus(polar(angle, 8 * (1 + sin(extra + (millis()) / 80.0))));

    Vector2D back = tip.plus(polar(angle, headLength));
    Vector2D wing1 = back.plus(polar(angle+HALF_PI, headWidth/2));
    Vector2D wing2 = back.plus(polar(angle-HALF_PI, headWidth/2));

    //tip.drawTriangle(10);

//    tip = tip.trunc();

    //tip.drawLineTo(wing1);
    //tip.drawLineTo(wing2);
    //wing2.drawLineTo(wing1);

    Vector2D box1 = back.plus(polar(angle+HALF_PI, tailWidth/2));
    Vector2D box2 = back.plus(polar(angle-HALF_PI, tailWidth/2));
    Vector2D box3 = box2.plus(polar(angle, tailLength));
    Vector2D box4 = box1.plus(polar(angle, tailLength));
    //box1.drawLineTo(box2);
    //box2.drawLineTo(box3);
    //box3.drawLineTo(box4);
    //box4.drawLineTo(box1);


    //if (black)
    {
      fill(0xff000000);
      stroke(0xff000000);
      strokeWeight(3);
      Vector2D b = new Vector2D(2,1);
      beginShape();
      b.plus(tip).vert();
      b.plus(wing1).vert();
      b.plus(box1).vert();
      b.plus(box4).vert();
      b.plus(box3).vert();
      b.plus(box2).vert();
      b.plus(wing2).vert();
      endShape(CLOSE);
    }
    if (black)
    {
    }
    else
    {
      fill(0xffffffff);
    }

    stroke(0xffffffff);
    strokeWeight(2);

    beginShape();
    tip.vert();
    wing1.vert();
    box1.vert();
    box4.vert();
    box3.vert();
    box2.vert();
    wing2.vert();
    endShape(CLOSE);

tip = tip.trunc();
    Vector2D textPos = tip.plus(polar(angle, headLength + tailLength + 6));
    textAlign(CENTER);
    textSize(16);
    fill(0xff000000);
    textPos.plus(1,1).drawText(label);
    fill(0xffffffff);
    textPos.drawText(label);
  }
}


class CircleNode extends Node
{
  CircleNode ()
  {
    super();
  }

  CircleNode (Vector2D pos)
  {
    super(pos);
  }

  double getCharge ()
  {
    return 3; //1 + 3* Math.log(max(1,edges.size())); // constant 3 works well too
  }

  boolean hit (Vector2D p)
  {
    return pos.minus(p).getMagnitude() <= getRadius()/2;
  }

  double getRadius ()
  {
    return (2 + Math.log(max(1,edges.size()))) * 15;
  }

  void draw (Graph g)
  {
    double radius = getRadius();
    strokeWeight(7);
    if (selected)
    {
      stroke(128,64,255);
      fill(255,255,255);
      pos.trunc().drawCircle(radius);
    }
    else
    {
      stroke(255,255,255,128);
      noFill();
      radius += 1;
      pos.trunc().drawCircle(radius);
      noStroke();
      fill(255,255,255);
      radius -= 4;
      pos.trunc().drawCircle(radius);
      radius += 3;
    }

    pinOffset = new Vector2D(radius/2.5, radius/2.5);
    drawPin();

    drawLabel(pos.trunc());
  }
}

class RoundedSquareNode extends Node
{
  RoundedSquareNode ()
  {
    super();
  }

  RoundedSquareNode (Vector2D pos)
  {
    super(pos);
  }

  double getCharge ()
  {
    return 3; //1 + 3* Math.log(max(1,edges.size())); // constant 3 works well too
  }

  boolean hit (Vector2D p)
  {
    return pos.minus(p).getMagnitude() <= getRadius()/2;
  }

  double getRadius ()
  {
    return (2 + Math.log(max(1,edges.size()))) * 15;
  }

  void draw (Graph g)
  {
    final int c = 8;
    double radius = getRadius();
    strokeWeight(7);
    if (selected)
    {
      stroke(128,64,255);
      fill(255,255,255);
      pos.trunc().drawSquare(radius, c);
    }
    else
    {
      stroke(255,255,255,128);
      noFill();
      radius += 1;
      pos.trunc().drawSquare(radius, c);
      noStroke();
      fill(255,255,255);
      radius -= 4;
      pos.trunc().plus(.5,.5).drawSquare(radius, c);
      radius += 3;
    }

    pinOffset = new Vector2D(radius/2, radius/2);
    drawPin();

    drawLabel(pos.trunc());
  }
}

class TriangleNode extends Node
{
  TriangleNode ()
  {
    super();
  }

  TriangleNode (Vector2D pos)
  {
    super(pos);
  }

  double getCharge ()
  {
    return 3; //1 + 3* Math.log(max(1,edges.size())); // constant 3 works well too
  }

  boolean hit (Vector2D p)
  {
    return pos.minus(p).getMagnitude() <= getRadius()/2;
  }

  double getRadius ()
  {
    return (2 + Math.log(max(1,edges.size()))) * 15;
  }

  void draw (Graph g)
  {
    double radius = getRadius();
    strokeWeight(7);
    if (selected)
    {
      stroke(128,64,255);
      fill(255,255,255);
      pos.trunc().drawTriangle(radius);
    }
    else
    {
      stroke(255,255,255,128);
      noFill();
      radius += 1;
      pos.trunc().drawTriangle(radius);
      noStroke();
      fill(255,255,255);
      radius -= 4;
      pos.trunc().drawTriangle(radius);
      radius += 3;
    }

    pinOffset = polar(2.0943951023931953*1-HALF_PI, radius*.65);
    drawPin();

    drawLabel(pos.trunc());
  }
}

