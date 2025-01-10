import java.util.HashSet;

class Edge extends BaseObject
{
  // An edge is a connection between two Nodes that acts like a spring
  // governed by Hooke's Law.

  Node a, b; // The two ends
  int port_a, port_b;

  boolean equals (Object other)
  {
    if ((other instanceof Edge) == false) return false;
    Edge o = (Edge)other;
    if (o.a == a && o.b == b && o.port_a == port_a && o.port_b == port_b)  return true;
    return o.a == b && o.b == a && o.port_a == port_b && o.port_b == port_a;
  }

  Edge (Node a, int port_a, Node b, int port_b)
  {
    this.a = a;
    this.b = b;
    this.port_a = port_a;
    this.port_b = port_b;


    if (!a.edges.contains(this)) a.edges.add(this);
    if (!b.edges.contains(this)) b.edges.add(this);
  }

  public String toString ()
  {
    return a + "." + port_a + " <-> " + b  + "." + port_b;
  }

  void remove ()
  {
    a.edges.remove(this);
    b.edges.remove(this);
  }

  Node getOtherEnd (Node self)
  {
    if (a == self)
      return b;
    return a;
  }

  void draw ()
  {
    stroke(255,255,255,128);
    strokeWeight(5);
    a.pos.drawLineTo(b.pos);
  }
}
