
import json.*;
import java.net.*;
import java.lang.reflect.*;
import java.io.InputStreamReader;

class JSONConnection extends Connection
{
  public void send (Object[][] kvs)
  {
    HashMap<String, Object> dict = new HashMap<String, Object>();
    for (Object[] kv : kvs)
    {
      assert(kv.length == 2);
      String k = kv[0].toString();
      dict.put(k, kv[1]);
    }
    //println(dict);
    //println(new JSONObject(dict).toString());
    send(new json.JSONObject(dict).toString() + "\n");
  }

  public void process (String msg)
  {
    process(new json.JSONObject(msg));
  }
  public void process (json.JSONObject msg)
  {
    println("Msg: " + msg);
  }

  JSONConnection ()
  {
    super();
  }

  JSONConnection (String addr, int port, boolean reconnect)
  {
    super(addr, port, reconnect);
  }
}

class Connection implements Runnable
{
  Socket sock;
  boolean reconnect;
  String addr;
  int port;

  public void process (String msg)
  {
  }

  void send (String raw)
  {
    try
    {
      sock.getOutputStream().write(raw.getBytes());
    }
    catch (Exception e)
    {
      println(e);
    }
  }

  private void doReconnect ()
  {
    this.sock = null;
    try
    {
      this.sock = new Socket(this.addr, this.port);
    }
    catch (Exception e)
    {
      //println("Connection failed: " + e);
    }
  }

  Connection ()
  {
  }

  Connection (String addr, int port)
  {
    this(addr, port, false);
  }

  Connection (String addr, int port, boolean reconnect)
  {
    connect(addr, port, reconnect);
  }

  void connect (String addr, int port, boolean reconnect)
  {
    this.reconnect = reconnect;
    this.addr = addr;
    this.port = port;
    if (reconnect)
    {
      begin(true);
    }
    else
    {
      doReconnect();
      begin(false);
    }
  }

  private void begin (boolean force)
  {
    if (this.sock != null || force)
    {
      Thread t = new Thread(this);
      t.start();
    }
  }

  Connection (Socket sock)
  {
    reconnect = false;
    this.sock = sock;
    begin(false);
  }

  public void run ()
  {
    while (true)
    {
      if (sock != null)
      {
        try
        {
          BufferedReader reader = new BufferedReader(new InputStreamReader(sock.getInputStream()));
          while (true)
          {
            String l = reader.readLine();
            if (l == null)
            {
              println("Socket has no more data");
              sock = null;
              break;
            }
            try
            {
              process(l);
            }
            catch (Exception e)
            {
              println("Bad input: " + l);
              println(e);
            }
          }
        }
        catch (Exception e)
        {
          println("Socket exception: " + e);
        }
      }
      this.sock = null;
      if (this.reconnect)
      {
        try
        {
          this.doReconnect();
        }
        catch (Exception ee)
        {
        }
        if (this.sock == null)
        {
          try
          {
            //println("Waiting to retry...");
            Thread.sleep(2000);
          }
          catch (Exception eee)
          {
          }
        }
        continue;
      }
      break;
    }
    println("Socket loop end");
  }
}
