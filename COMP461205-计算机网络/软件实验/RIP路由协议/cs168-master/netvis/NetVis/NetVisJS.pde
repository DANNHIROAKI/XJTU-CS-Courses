// Hasty port to ProcessingJS
// MM 2018

Graph g;


String prevInfoText;

Slider zoomSlider;
Slider repulsionSlider;
Slider springSlider;
Slider centerSlider;

interface Slider
{
  double getValue ();
  void setValue (double val);
  void lineBreak ();
  void setColor (int col);
}


interface Control
{
  Slider addSlider (String name, double low, double high);
  void setGroup (Object o);
}

interface Sender
{
  void send (Object o);
}

interface JSMisc
{
  void setInfoText (String s);
  void println (Object o);
}


Control control;
Sender sender;
JSMisc jsMisc;

App app;

void println (Object o)
{
  if (jsMisc) jsMisc.println(o);
}

void realInit (Control o, Sender s, JSMisc m)
{
  control = o;
  sender = s;
  jsMisc = m;
  app = new App(this);
}

//import processing.opengl.*;

class ClassInfo
{
  String name;
  ClassInfo (String name)
  {
    this.name = name
  }
  String getName ()
  {
    return name;
  }
}

class BaseObject
{
  static HashMap<String,ClassInfo> _classinfo = new HashMap<String,ClassInfo>();
  ClassInfo getClass ()
  {
    String n = jsMisc.getClassName(this);
    if (_classinfo.containsKey(n)) return _classinfo.get(n);
    ClassInfo r = new ClassInfo(n);
    _classinfo.put(n, r);
    return r;
  }
}

class JSONConnection extends BaseObject
{
  void send (Object o)
  {
    if (sender) sender.send(o);
  }
}

class App extends JSONConnection
{
  ArrayList<Packet> packets = new ArrayList<Packet>();
  Node dragged;
  Node hovered;
  PApplet applet;

  Graph buildCycleGraph (int points)
  {
    Graph g = new Graph();
    Node first = new TriangleNode();
    g.nodes.add(first);
    return g;
    Node prev = first;
    Node cur = null;
    for (int i = 1; i < points; i++)
    {
      cur = TriangleNode();
      Edge e = new Edge(prev, 0, cur, 1);
      prev = cur;
    }
    Edge f = new Edge(prev, 0, first, 1);
    return g;
  }

  App (PApplet applet)
  {
    size(600, 600, P2D); // P2D or OPENGL
    this.applet = applet;
    //frame.setResizable(true);
    //g = buildCycleGraph(4);
    g = new Graph();

    randomSeed(42);

    frameRate(20);
    smooth();
    strokeJoin(ROUND);
    strokeCap(ROUND);

    //CColor col = new CColor();
    //col.setForeground(0xff8050f0);
    //col.setBackground(0xff4020a0);
    //col.setActive(0xff9070ff);

    int col = 42; // Not used

    Object adjustWindow = "Layout";

    //control = new ControlP5(applet);

    zoomSlider = control.addSlider("Zoom", -2*5, 1);
    zoomSlider.linebreak();
    zoomSlider.setValue(0);
    zoomSlider.setColor(col);
    //zoomSlider.setGroup(adjustWindow);

    repulsionSlider = control.addSlider("Repulsion", .5, 3);
    repulsionSlider.setValue(2);
    repulsionSlider.linebreak();
    repulsionSlider.setColor(col);
    //repulsionSlider.setGroup(adjustWindow);

    springSlider = control.addSlider("Spring", .005, 0.85);
    springSlider.setValue(0.05);
    springSlider.linebreak();
    springSlider.setColor(col);
    //springSlider.setGroup(adjustWindow);

    centerSlider = control.addSlider("Centerness", .005, 0.3);
    centerSlider.setValue(0.1);
    centerSlider.linebreak();
    centerSlider.setColor(col);
    //centerSlider.setGroup(adjustWindow);
  }

  void setInfoText (String s)
  {
    // Awful line-wrap version of this.

    if (s != null) s = s.trim();
    if (s == null || s.length() == 0) s = "<No Info>";

    if (prevInfoText != null && prevInfoText.equals(s)) return;
    prevInfoText = s;

    if (jsMisc) jsMisc.setInfoText(s);
  }

  String labelOf (Node n)
  {
    return (n != null) ? n.label : null;
  }

  void mousePressed (Vector2D pos)
  {
    boolean missed = true;
    Node old_selected = null;
    Node new_selected = null;
    dragged = null;
    for (Node n : g.nodes)
    {
      if (n.selected) old_selected = n;
      n.selected = false;
      if (n.click(pos))
      {
        if (n.selected) new_selected = n;
        missed = false;
        break;
      }
    }
    if (old_selected != new_selected)
    {
      send(new Object[][]{{"type","selection"}, {"update","selected"}, {"selected",labelOf(new_selected)}, {"unselected",labelOf(old_selected)}, {"a",labelOf(g.a)}, {"b",labelOf(g.b)}});
    }
  }

  synchronized void keyPressed (int k)
  {
    if (k == 'a' || k == 'b')
    {
      for (Node n : g.nodes)
      {
        if (n.selected)
        {
          if (k == 'a')
          {
            if (g.a == n)
              g.a = null;
            else
              g.a = n;
            send(new Object[][]{{"type","selection"}, {"update","a"}, {"selected",labelOf(n)}, {"a",labelOf(g.a)}, {"b",labelOf(g.b)}});
          }
          else
          {
            if (g.b == n)
              g.b = null;
            else
              g.b = n;
            send(new Object[][]{{"type","selection"}, {"update","b"}, {"selected",labelOf(n)}, {"a",labelOf(g.a)}, {"b",labelOf(g.b)}});
          }
          break;
        }
      }
    }
    else if (k == 'd')
    {
      for (Node n : g.nodes)
      {
        if (n.selected)
        {
          send(new Object[][]{{"type","disconnect"}, {"node",n.label}});
        }
      }
    }
    else if (k == 'e')
    {
      if (g.a != null && g.b != null && g.a != g.b)
      {
        if (g.a.isConnectedTo(g.b))
          send(new Object[][]{{"type","delEdge"}, {"node1",g.a.label}, {"node2",g.b.label}});
        else
          send(new Object[][]{{"type","addEdge"}, {"node1",g.a.label}, {"node2",g.b.label}});
      }
    }
    else if (k == 'p')
    {
      if (g.a != null && g.b != null && g.a != g.b)
      {
        send(new Object[][]{{"type","ping"}, {"node1",g.a.label}, {"node2",g.b.label}});
      }
    }
    else if (k == 'o' || k == 'O')
    {
      for (Node n : g.nodes)
      {
        n.pinned = k == 'o';
      }
    }
    else if (k == 'x')
    {
      if (g.a != null && g.b != null)
      {
        Node temp = g.a;
        g.a = g.b;
        g.b = temp;

        send(new Object[][]{{"type","selection"}, {"update","a"}, {"a",labelOf(g.a)}, {"b",labelOf(g.b)}});
        send(new Object[][]{{"type","selection"}, {"update","b"}, {"a",labelOf(g.a)}, {"b",labelOf(g.b)}});
      }
    }
    else if (k == 'l')
    {
      g.layout = !g.layout;
      println("running: " + g.layout);
    }
    else if ("!@#$%^&*()".indexOf(k) != -1)
    {
      int index = ")!@#$%^&*(".indexOf(k);
      println("Send function " + index);
      send(new Object[][]{{"type","function"}, {"which", index}});
    }
  }

  synchronized void mouseReleased (Vector2D pos)
  {
    g.running = true;
    dragged = null;
  }

  synchronized void mouseMoved (Vector2D pos)
  {
  }

  synchronized void mouseDragged (Vector2D pos)
  {
    g.running = true;
    if (dragged != null)
    {
      dragged.pos = pos;
    }
  }

  private Node getNode (jsonJSONObject j, String key)
  {
    try
    {
      String name = j.getString(key.toLowerCase(), null);
      if (name == null) return null;
      for (Node n : g.nodes)
      {
        if (n.label.equals(name)) return n;
      }
    }
    catch (Exception e)
    {
    }
    return null;
  }

  private Node getNode (jsonJSONArray j, int index)
  {
    try
    {
      String name = j.getString(index);
      if (name == null) return null;
      for (Node n : g.nodes)
      {
        if (n.label.equals(name)) return n;
      }
    }
    catch (Exception e)
    {
    }
    return null;
  }

  private int getColor (jsonJSONObject msg, String key, int def)
  {
    try
    {
      if (msg.has(key))
      {
        jsonJSONArray col = msg.getJSONArray(key);
        if (col.getLength() == 3 || col.getLength() == 4)
        {
          int r, g, b, a;
          r = constrain((int)(col.getDouble(0) * 255), 0, 255);
          g = constrain((int)(col.getDouble(1) * 255), 0, 255);
          b = constrain((int)(col.getDouble(2) * 255), 0, 255);
          if (col.getLength() == 4)
            a = constrain((int)(col.getDouble(3) * 255), 0, 255);
          else
            a = 255;
          return (r << 16) | (g << 8) | (b << 0) | (a << 24);
        }
      }
    }
    catch (Exception e)
    {
    }
    return def;
  }

  public synchronized void process (jsonJSONObject msg)
  {
    String type = msg.getString("type","");

    Node node = getNode(msg, "node");
    Node node1 = getNode(msg, "node1");
    Node node2 = getNode(msg, "node2");

    if (type.equals("addEntity"))
    {
      String kind = msg.getString("kind", "circle").toLowerCase();
      Node n;
      if (kind.equals("square"))
        n = new RoundedSquareNode();
      else if (kind.equals("triangle"))
        n = new TriangleNode();
      else
        n = new CircleNode();
      n.label = msg.getString("label", "");
      //node oldNode = null;
      for (Node oldn : g.nodes)
      {
        if (oldn.label.equals(n.label))
        {
          if (oldn.getClass() == n.getClass())
          {
            // Reuse;
            println("Reusing a node");
            n = null;
            break;
          }
          else
          {
            println("Removing a node");
            g.nodes.remove(oldn);
            break;
          }
        }
      }
      if (n != null) g.nodes.add(n);
      g.running = true;
    }
    else if (type.equals("delEntity"))
    {
      g.running = true;
      ArrayList<Edge> dead = new ArrayList<Edge>(node.edges);
      for (Edge e : dead)
      {
        e.remove();
      }
      g.nodes.remove(node);
      if (g.a == node) g.a = null;
      if (g.b == node) g.b = null;
    }
    else if (type.equals("link"))
    {
      if (node1 == null || node2 == null)
        println("Asked to add bad link: " + msg);
      else
        new Edge(node1, (int)msg.getDouble("node1_port"), node2, (int)msg.getDouble("node2_port"));
      g.running = true;
    }
    else if (type.equals("unlink"))
    {
      Edge e = g.findEdge(node1, node2);
      if (e != null)
        e.remove();
      else
        println("no edge for " + node1 + "<->" + node2);
      g.running = true;
    }
    else if (type.equals("packet"))
    {
      double t = 1000;
      boolean drop = msg.has("drop") ? msg.getBoolean("drop") : false;
      if (msg.has("duration")) t = msg.getDouble("duration");
      Packet p = new Packet(node1, node2, t, drop);
      p.strokeColor = getColor(msg, "stroke", 0xffFFffFF);
      p.fillColor = getColor(msg, "fill", 0);//0x7fffffff);
      app.packets.add(p);
    }
    else if (type.equals("initialize"))
    {
      g.running = true;
      g.nodes.clear();
      g.a = null;
      g.b = null;
//      jsonJSONObject
      Object entities = msg.getJSONObject("entities");
      for (String k : entities.getNames())
      {
        //JSONObject msg = entities.getJSONObject(k);
        //String kind = msg.getString("kind", "circle");
        String kind = entities.getString(k, "circle");
        Node n;
        if (kind.equals("square"))
          n = new RoundedSquareNode();
        else if (kind.equals("triangle"))
          n = new TriangleNode();
        else
          n = new CircleNode();
        g.nodes.add(n);

        //n.label = msg.getString("label", "");
        n.label = k;
      }
      //println("....");
      jsonJSONArray links = msg.getJSONArray("links");
      for (int i = 0; i < links.getLength(); i++)
      {
        jsonJSONArray l = links.getJSONArray(i);
        node1 = getNode(l, 0);
        node2 = getNode(l, 2);
        int node1_port = (int)l.getDouble(1);
        int node2_port = (int)l.getDouble(3);
        new Edge(node1, node1_port, node2, node2_port);
      }
    }
    else if (type.equals("clear"))
    {
      g.nodes.clear();
      g.a = null;
      g.b = null;
    }
    else if (type.equals("info"))
    {
      setInfoText(msg.getString("text", "<No Info>"));
    }
  }

  synchronized void draw ()
  {
    background(0xff302050);

    if (g != null) g.drawLinks();

    ArrayList<Packet> nextPackets = new ArrayList<Packet>();
    for (Packet p : packets)
    {
      if (p.draw()) nextPackets.add(p);
    }
    packets = nextPackets;

    if (g != null)
    {
      g.drawNodes();
      if (g.a != null) g.a.drawArrow();
      if (g.b != null) g.b.drawArrow();
    }
  }
}




// --------------------------------------------------------------------------
// Global
// --------------------------------------------------------------------------
//import controlP5.*;

//ControlP5 control;

double scaleFactor = 1;
double translationX;
double translationY;


//PFont[] fonts = new PFont[3];

void process (Object o)
{
  app.process(o);
}

void setup ()
{
}

void draw ()
{
  if (zoomSlider == null) return;
  double z = zoomSlider.getValue();
  double oz = z;
  if (z < 0)
    z = 1 / (-z + 1);
  else
    z += 1;
  //print(oz + " " + z + "\n");
  translate((float)(-width*z/2+width/2), (float)(-height*z/2+height/2));
  scaleFactor = z;
  translationX = -width*z/2+width/2;
  translationY = -height*z/2+height/2;
  scale((float)z);
  //print((width*z) + "\n");
  background(0);
  fill(255,255,255);
  //(new Vector2D(300,300)).drawCircle(30);

  app.draw();
  resetMatrix();
}

Vector2D getMousePos ()
{
  return new Vector2D(mouseX-translationX, mouseY-translationY).dividedBy(scaleFactor);
}

void mousePressed ()
{
  app.mousePressed(getMousePos());
}

void mouseMoved ()
{
  app.mouseMoved(getMousePos());
}

void mouseReleased ()
{
  app.mouseReleased(getMousePos());
}

void keyPressed ()
{
  app.keyPressed(key);
}

void mouseDragged ()
{
  app.mouseDragged(getMousePos());
}
