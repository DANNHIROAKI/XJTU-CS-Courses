
/*

a - set A marker
b - set B marker
p - ping from A to B
e - toggle edge between A and B

*/

Graph g;

//ControlWindow adjustWindow;
ControlGroup adjustWindow;

ControlGroup infoWindow;
Textarea infoText;
String prevInfoText;
Label infoTextLabel;

Slider zoomSlider;
Slider repulsionSlider;
Slider springSlider;
Slider centerSlider;

class BaseObject
{
}

class App extends JSONConnection
{
  ArrayList<Packet> packets = new ArrayList<Packet>();
  Node dragged;
  Node hovered;
  PApplet applet;

  App (PApplet applet)
  {
    size(600, 600);
    this.applet = applet;
    frame.setResizable(true);
    //g = buildRandomGraph(30, 25);
    g = new Graph();

    frameRate(20);
    smooth();

    CColor col = new CColor();
    col.setForeground(0xff8050f0);
    col.setBackground(0xff4020a0);
    col.setActive(0xff9070ff);

    control = new ControlP5(applet);
    //adjustWindow = control.addControlWindow("Adjustments", 230, 130);
    //adjustWindow.setBackground(0x7f6040a0);
    //adjustWindow.hideCoordinates();
    //adjustWindow.hide();

    Accordion accordion = control.addAccordion("Accordion");
    accordion.setPosition(0,0);
    accordion.setWidth(230);
    accordion.setCollapseMode(ControlP5.MULTI);

    adjustWindow = control.addGroup("Layout", 230, 130);
    //adjustWindow.setPosition(0,10);
    adjustWindow.close();
    adjustWindow.setBackgroundColor(0xff6040a0);
    adjustWindow.setBackgroundHeight(130);
    adjustWindow.setWidth(230);
    accordion.addItem(adjustWindow);


    infoWindow = control.addGroup("Info", 230, 130);
    infoWindow.close();
    infoWindow.setBackgroundColor(0xff6040a0);
    infoWindow.setBackgroundHeight(130);
    infoWindow.setWidth(230);
    accordion.addItem(infoWindow);


    zoomSlider = control.addSlider("Zoom", -2*5, 1);
    zoomSlider.linebreak();
    zoomSlider.setValue(0);
    zoomSlider.setColor(col);
//zoomSlider.setWindow(adjustWindow);
zoomSlider.setGroup(adjustWindow);
    repulsionSlider = control.addSlider("Repulsion", .5, 3);
    repulsionSlider.setValue(2);
    repulsionSlider.linebreak();
    repulsionSlider.setColor(col);
repulsionSlider.setGroup(adjustWindow);

    springSlider = control.addSlider("Spring", .005, 0.85);
    springSlider.setValue(0.05);
    springSlider.linebreak();
    springSlider.setColor(col);
springSlider.setGroup(adjustWindow);

    centerSlider = control.addSlider("Centerness", .005, 0.3);
    centerSlider.setValue(0.1);
    centerSlider.linebreak();
    centerSlider.setColor(col);
centerSlider.setGroup(adjustWindow);

    infoText = control.addTextarea("InfoText");
    //infoText.setPosition(0,0).setSize(200,100).setText("");
    infoText.setSize(230, 80);
    infoText.setGroup(infoWindow);

    infoTextLabel = new Label(control, "");
    infoTextLabel.hide();
    //infoText.setFont(infoTextLabel.getFont());

    infoText.setLineHeight(12);
    setInfoText("<No Info>");
    //connect();
    //server = new Server(applet, 4444);
    //new JSONConnection("localhost", 4444, true);
    connect("localhost", 4444, true);
  }

  void setInfoText (String s)
  {
    // Awful line-wrap version of this.

    if (s != null) s = s.trim();
    if (s == null || s.length() == 0) s = "<No Info>";

    if (prevInfoText != null && prevInfoText.equals(s)) return;
    prevInfoText = s;

    int l = 0;
    final int PAD = 16;
    String o = "";

    String[] lines = s.split("\n");
    for (int j = 0; j < lines.length; j++)
    {
      l++;
      s = lines[j].replaceAll("\\s+$", "");
      if (s.length() == 0)
      {
        o += "\n";
        continue;
      }
      String rest = "";

      rest = s;
      s = "";
      while (control.getFont().getWidthFor(s, infoText.getValueLabel(), applet.g)+PAD < infoText.getWidth())
      {
        s += rest.charAt(0);
        rest = rest.substring(1);
        if (rest.length() == 0) break;
      }
      if (control.getFont().getWidthFor(s, infoText.getValueLabel(), applet.g)+PAD >= infoText.getWidth())
      {
        // Okay, we've gone too far.  Back it off one character...
        rest = s.charAt(s.length() - 1) + rest;
        s = s.substring(0, s.length() - 1);
      }

      //println("*" + (control.getFont().getWidthFor(s, infoText.getValueLabel(), applet)+PAD) + " " + infoText.getWidth() + s + "!");
      if (rest.length() > 0 && rest.charAt(0) != ' ')
      {
        for (int i = 1; i < 9; i++)
        {
          if (s.charAt(s.length() - i) == ' ')
          {
            rest = (s.substring(s.length() - i) + rest).replaceAll("^\\s+", "");
            s = s.substring(0, s.length() - i);
            //done = true;
            break;
          }
        }
      }
      rest = rest.replaceAll("^\\s+", "");

      o += s + "\n";

      if (rest.length() > 0)
      {
        lines[j] = ".."+rest;
        j--;
      }
    }

    println("Lines: " + l);
    if (l > 40) l = 40;

    infoText.setText(o.trim());

    infoText.setHeight(2+12*l);
    infoWindow.setBackgroundHeight(infoText.getHeight());
    //println("Info: " + s);
  }

  String labelOf (Node n)
  {
    return (n != null) ? n.label : null;
  }

  synchronized void mousePressed (Vector2D pos)
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

  private Node getNode (json.JSONObject j, String key)
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

  private Node getNode (json.JSONArray j, int index)
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

  private int getColor (json.JSONObject msg, String key, int def)
  {
    try
    {
      if (msg.has(key))
      {
        json.JSONArray col = msg.getJSONArray(key);
        if (col.length() == 3 || col.length() == 4)
        {
          int r, g, b, a;
          r = constrain((int)(col.getDouble(0) * 255), 0, 255);
          g = constrain((int)(col.getDouble(1) * 255), 0, 255);
          b = constrain((int)(col.getDouble(2) * 255), 0, 255);
          if (col.length() == 4)
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

  public synchronized void process (json.JSONObject msg)
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
      json.JSONObject entities = msg.getJSONObject("entities");
      for (String k : json.JSONObject.getNames(entities))
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
      println("....");
      json.JSONArray links = msg.getJSONArray("links");
      for (int i = 0; i < links.length(); i++)
      {
        json.JSONArray l = links.getJSONArray(i);
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
    //background(0x00201030);
    background(0x00302050);

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
