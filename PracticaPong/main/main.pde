/**
 * Bounce. 
 * 
 * When the shape hits the edge of the window, it reverses its direction. 
 */

int rad = 60;        // Width of the shape
float xpos, ypos;    // Starting position of shape    

float xspeed = 2.8;  // Speed of the shape
float yspeed = 2.2;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom

class vector {
  public float x, y;
  public vector() {
    x = 0;
    y = 0;
  }
  public vector(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

abstract class Object {
  abstract void Update();
  abstract void Draw();
}


class Ball/* extends Object */{
  float radius;
  vector position;
  vector speed;
  vector direction;

  public Ball(float rad, vector pos) {
    position = pos;
    radius = rad;

    //SetSpeed(1,1);
    //SetDirection(0,0);
    //SetSpeed(random(2),random(2));
    //SetDirection(random(1),random(1));
  }
  public void SetDirection(float x, float y) {
    direction.x = x;
    direction.y = y;
  }

  public void SetSpeed(float x, float y) {
    speed.x = x;
    speed.y = y;
  }

  public void Update() {
    position.x = position.x + speed.x * direction.x;
    position.y += speed.y * direction.y;
    //position.x = position.x + (speed.x * direction.x);
  }
  public void Draw() {
    ellipseMode(RADIUS);
    ellipse(position.x, position.y, radius, radius);
  }
}

Ball ball = new Ball(20, new vector(0, 0));

void setup() 
{
  size(640, 360);
  noStroke();
  frameRate(30);
  ellipseMode(RADIUS);
  // Set the starting position of the shape
  xpos = width/2;
  ypos = height/2;
}
void draw() 
{
  background(102);

  // Update the position of the shape
  //xpos = xpos + ( xspeed * xdirection );
  //ypos = ypos + ( yspeed * ydirection );

  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (xpos > width-rad || xpos < rad) {
    xdirection *= -1;
  }
  if (ypos > height-rad || ypos < rad) {
    ydirection *= -1;
  }
  ball.Update();
  // Draw the shape
  //ellipse(xpos, ypos, rad, rad);
  ball.Draw();
}
