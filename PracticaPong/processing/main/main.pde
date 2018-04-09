import processing.serial.*;

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

public class InputManager {

  float lightValue, rotatorValue, temperatureValue;

  InputManager() {
  }

  public void Setup() {
    commSetup();
  }

  public void Update()
  {

    if ( dataAvailable (CHANNEL_1) ) {      
      println ("Llum: "+getData(CHANNEL_1)+" ");
      lightValue = getData(CHANNEL_1);
    }
    if ( dataAvailable (CHANNEL_2) ) {      
      println ("Potenciometre: "+getData(CHANNEL_2)+" ");
      rotatorValue = getData(CHANNEL_2);
    }
    if ( dataAvailable (CHANNEL_3) ) {      
      println ("Temperatura: "+getData(CHANNEL_3)+" ");
      temperatureValue = getData(CHANNEL_3);
    }
  }

  public void ShutDown() {
    commManager();
  }

  public float GetTemperatureValue() {
    return temperatureValue;
  }
  public float GetRotatorValue() {
    return rotatorValue;
  }
  public float GetLightValue() {
    return lightValue;
  }
}


abstract class Object {
  vector position;

  abstract void Update(InputManager im);
  abstract void Draw();
}

abstract class Bar extends Object {
  float w, h;
  int score;

  public Bar() {
  }
  public Bar(vector pos, float w, float h) {
    position = pos;
    this.w = w;
    this.h = h;
  }

  void UpdateVerticalPosition(float value) {
    position.y = map(value, 0, 1, height - h, h);
  }

  void CheckBallCollision(Ball ball) {
    if (ball.position.x + ball.radius > position.x - w/2 && ball.position.x - ball.radius < position.x + w/2 &&
      ball.position.y + ball.radius > position.y - h/2 && ball.position.y - ball.radius < position.y + h/2) {
      ball.direction.x = -ball.direction.x;
    }
  }


  void Draw() {
    rectMode(CENTER);
    rect(position.x, position.y, w, h);
  }
}

class LeftBar extends Bar {
  LeftBar(vector pos, float w, float h) {
    position = pos;
    this.w = w;
    this.h = h;
  }

  void Update(InputManager im) {
    UpdateVerticalPosition(im.GetLightValue());
  }
}

class RightBar extends Bar {
  RightBar(vector pos, float w, float h) {
    position = pos;
    this.w = w;
    this.h = h;
  }

  void Update(InputManager im) {
    UpdateVerticalPosition(im.GetRotatorValue());
  }
}

class Ball {
  float radius;
  vector position;
  
  float speedMultiplier, speed;
  vector direction;

  public Ball(float rad, vector pos, float speedMult) {
    speedMultiplier = speedMult;
    position = pos;
    radius = rad;
    speed = 5;

    direction = new vector();
    direction.x = random(1);
    direction.y = 1 - direction.x;

    //SetSpeed(1,1);
    //SetDirection(0,0);
    //SetSpeed(random(2),random(2));
    //SetDirection(random(1),random(1));
  }

  public void Reset() {
    position = new vector(width/2, height/2);
    direction.x = random(1);
    direction.y = 1 - direction.x;
  }

  public void SetDirection(float x, float y) {
    direction.x = x;
    direction.y = y;
  }

  public void SetSpeed(float s) {
    speed = s;
  }

  public void Update(InputManager im, Bar left, Bar right) {
    SetSpeed(im.GetTemperatureValue() * speedMultiplier);

    this.position.x = this.position.x + this.speed * this.direction.x;
    this.position.y += this.speed * this.direction.y;

    if (position.x > width-radius || position.x < radius) {
      if (direction.x > 0) {
        Reset();
        left.score++;
      } else if (direction.x < 0) {
        Reset();
        right.score++;
      }
      //direction.x *= -1;
    }
    if (position.y > height-radius || position.y < radius) {
      direction.y *= -1;
    }

    //position.x = position.x + (speed.x * direction.x);
  }
  public void Draw() {
    ellipseMode(RADIUS);
    ellipse(position.x, position.y, radius, radius);
  }
}

class HUD {
  private int scoreLeft, scoreRight;
  HUD() {
    scoreLeft = 0;
    scoreRight = 0;
  }
  public void Update(Bar left, Bar right) {
    scoreLeft = left.score;
    scoreRight = right.score;
    
  }
  public void Draw() {
    textSize(32);
    text(scoreLeft, width/4, height/8);
    text(scoreRight, width - width/4, height/8);
  }
}

InputManager im;
Ball ball;
Bar barLeft, barRight;
HUD hud;

void setup() 
{
  size(640, 360);
  noStroke();
  frameRate(30);

  hud = new HUD();
  im = new InputManager();
  ball = new Ball(20, new vector(width/2, height/2), 10);
  barLeft = new LeftBar(new vector(width/8, height/2), 10, 60);
  barRight = new RightBar(new vector(width - width/8, height/2), 10, 60);

  im.Setup();
}
void draw() 
{
  background(102);

  if ( isPortConnected() ) {
    //Update
    im.Update();
    barLeft.CheckBallCollision(ball);
    barLeft.Update(im);
    barRight.CheckBallCollision(ball);
    barRight.Update(im);
    ball.Update(im, barLeft, barRight);
    
    hud.Update(barLeft, barRight);

    //Draw
    barLeft.Draw();
    barRight.Draw();
    ball.Draw();
    
    hud.Draw();
  }

  im.ShutDown();
}
