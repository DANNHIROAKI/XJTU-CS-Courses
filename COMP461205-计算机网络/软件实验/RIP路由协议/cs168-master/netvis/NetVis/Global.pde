import controlP5.*;

ControlP5 control;

double scaleFactor = 1;
double translationX;
double translationY;

App app;

PFont[] fonts = new PFont[3];

void setup ()
{
  for (int i = 0; i < fonts.length; i++)
  {
    int pt = 12 * (int)pow(2,i);
    fonts[i] = loadFont("LucidaGrande-Bold-" + pt + ".vlw");
  }
  textFont(fonts[fonts.length-1]);

  app = new App(this);
}

void draw ()
{
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

  if (scaleFactor < 0.75)
    textFont(fonts[0]);
  else if (scaleFactor < 1.5)
    textFont(fonts[1]);
  else
    textFont(fonts[2]);

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
