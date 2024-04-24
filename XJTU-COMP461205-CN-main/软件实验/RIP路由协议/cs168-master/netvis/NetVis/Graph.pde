
class Graph
{
  Node a, b;

  ArrayList<Node> nodes = new ArrayList<Node>();

  boolean running = true;
  boolean layout = true;

  double iterate ()
  {
    // Iterates the position of elements in the graph.
    // Returns the total movement of this iteration (so that you can stop
    // iterating when the graph stabilizes).

    if (!layout) return 0;

    double totalForce = 0; // Used to track how much force is actual exterted

    // We spring all nodes to something *like* the center.  This is
    // actually a combination of the center of the window and the centeroid
    // of all the nodes' positions.
    Vector2D centeroid = new Vector2D();
    for (Node a : g.nodes) centeroid = centeroid.plus(a.pos);
    centeroid = centeroid.dividedBy(g.nodes.size());

    // Center of window
    Vector2D center = new Vector2D(width,height).times(0.5);

    // Something center-ish
    center = center.times(0.75).plus(centeroid.times(0.25));

    for (Node a : g.nodes)
    {
      Vector2D f = new Vector2D(0, 0);

      // All nodes are sprung to the center-ish
      {
        Vector2D x = a.pos.minus(center);
        double m = x.getMagnitude();
        //double l = (((CircleNode)a).getRadius()/2) * .5;
        double l = 10;
        m = (m - l) / m;

        x = x.times(m);
        if (m > 1) continue;

        Vector2D F = x.times(centerSlider.getValue());
        f = f.minus(F);
      }


      // Calculate spring forces along edges
      // Use modified Hooke's Law: F = -kx (where x is displacement)

      for (Edge e : a.edges)
      {
//        final double k = 0.05; // Spring constant
double k = springSlider.getValue();
        Vector2D x = a.pos.minus(e.getOtherEnd(a).pos);
        double m = x.getMagnitude();
        Node b = e.getOtherEnd(a);
        double l = a.getRadius()/2+b.getRadius()/2;
        l *= 2;
        m = (m - l) / m;

        x = x.times(m);
        //if (m > 1) continue;

        Vector2D F = x.times(-k);
        f = f.plus(F);

        //Vector2D x = a.pos.minus(e.getOtherEnd(a).pos);
        //double m = x.getMagnitude();
        //x = x.times((m - spring_length) / m); // Make this a ratio
        //Vector2D F = x.times(-k);
        //f = f.plus(F);
      }

      // Calculate Coulumb repulsion between all nodes
      // F = ke*((q1*q2)/r^2)
      //  where ke is the Coulomb constant, ms are the masses, r is distance between masses
      for (Node b : g.nodes)
      {
        Vector2D d = a.pos.minus(b.pos);
        double rSquared = d.getMagnitude();
        rSquared *= rSquared;

        if (rSquared > 0)
        {
          final double ke = 30;
          Vector2D F = d.times(ke).times(a.getCharge() * b.getCharge() / rSquared);

          double factor = repulsionSlider.getValue();

          //if (a.isConnectedTo(b))
          //  factor = 2;
          //else
          //  factor = 2;

          f = f.plus(F.times(factor));
        }
      }

      if (a != app.dragged && !a.pinned)// && !a.selected)
      {
        a.pos = a.pos.plus(f);
        totalForce += f.getMagnitude();
      }
    }
    return totalForce;
  }

  Edge findEdge (Node a, Node b)
  {
    for (Node n : nodes)
    {
      if (n == a)
      {
        for (Edge e : n.edges)
        {
          if (e.getOtherEnd(n) == b) return e;
        }
      }
    }
    return null;
  }

  void drawLinks ()
  {
    if (running || (((int)random(12)) == 0))
    {
      running = iterate() > .6;//.25;
      //if (!running) println("Idle " + (int)random(1,100));
    }
//running = true;
    HashMap<Edge,bool> drawn = new HashMap<Edge,bool>();
    for (Node n : nodes)
    {
      for (Edge e : n.edges)
      {
        if (!drawn.containsKey(e))
        {
          e.draw();
          drawn.put(e,true);
        }
      }
    }
  }

  void drawNodes ()
  {
    for (Node n : nodes) n.draw(this);
  }
}

