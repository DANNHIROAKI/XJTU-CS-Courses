import java.math.*;


class Vector2D
{
  double x, y;

  Vector2D ()
  {
    this(0, 0);
  }

  Vector2D (Vector2D v)
  {
    this(v.x,v.y);
  }

  Vector2D (double x, double y)
  {
    this.x = x;
    this.y = y;
  }

  public String toString ()
  {
    return "(" + x + "," + y + ")";
  }

  Vector2D plus (Vector2D v) { return new Vector2D(x + v.x, y + v.y); }
  Vector2D plus (double xx, double yy) { return new Vector2D(x + xx, y + yy); }
  Vector2D minus (Vector2D v) { return new Vector2D(x - v.x, y - v.y); }
  Vector2D minus (double xx, double yy) { return new Vector2D(x - xx, y - yy); }
  Vector2D times (double n) { return new Vector2D(x * n, y * n); }
  Vector2D times (double xx, double yy) { return new Vector2D(x * xx, y * yy); }
  Vector2D dividedBy (double n) { return new Vector2D(x / n, y / n); }
  Vector2D dividedBy (double xx, double yy) { return new Vector2D(x / xx, y / yy); }

  double getMagnitude () { return Math.sqrt(x*x + y*y); }

  double getTheta () { return Math.atan2(y, x); }

  Vector2D trunc () { return new Vector2D((int)x, (int)y); }

  void drawCircle (double radius)
  {
    ellipse((float)x, (float)y, (float)radius, (float)radius);
  }
  void drawTriangle (double radius)
  {
    radius *= .65;
    Vector2D p1 = this.minus(0,radius);
    Vector2D p2 = polar(2.0943951023931953*1-PI/2, radius);
    Vector2D p3 = this.plus(p2.times(-1,1));
    p2 = this.plus(p2);

    triangle((float)p1.x,(float)p1.y,(float)p2.x,(float)p2.y,(float)p3.x,(float)p3.y);
  }
  void drawSquare (double extent, double rounding)
  {
    rectMode(CENTER);
    rect((float)x, (float)y, (float)extent, (float)extent, (float)rounding);
  }
  void drawSquare (double extent)
  {
    drawSquare(extent, 0);
  }
  void drawLineTo (Vector2D other)
  {
    line((float)x, (float)y, (float)other.x, (float)other.y);
  }
  void drawText (String message)
  {
    if (message == null) return;
    textSize(16);
    text(message, (float)x, (float)y);
  }
  void drawTextCentered (String message)
  {
    textAlign(CENTER, CENTER);
    drawText(message);
  }
  void vert ()
  {
    vertex((float)x, (float)y);
  }
}

Vector2D polar (double theta, double m)
{
  return new Vector2D(cos((float)theta)*m, sin((float)theta)*m);
}

