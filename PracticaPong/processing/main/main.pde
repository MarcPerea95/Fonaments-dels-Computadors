import processing.serial.*;

static int WIN_SCORE = 10;

enum GameState {
  GAMEPLAY, ENDGAME
}

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

class Timer
{
  private long currentTime;
  public Timer() {
    currentTime = millis();
  }
  boolean Ready(int t)
  {
    if (millis() - currentTime >= t)
    {
      currentTime = millis();
      return true;
    } else {
      return false;
    }
  }
  float Remaining(int t)
  {
    return t - (millis() - currentTime);
  }
}

public class InputManager {
  boolean firstTime;
  int lightValue, rotatorValue, temperatureValue;
  int startTemperatureValue;
  Timer timer;
  
  InputManager() {
    timer = new Timer();
  }

  public void Setup() {
    commSetup();
    firstTime = true;
  }

  public void Update()
  {

    if ( dataAvailable (CHANNEL_1) ) {      
      lightValue = getData(CHANNEL_1);
      //println ("Llum: "+lightValue);
    }
    if ( dataAvailable (CHANNEL_2) ) {      
      rotatorValue = getData(CHANNEL_2);
      //println("Potenciometre: "+rotatorValue);
    }
    if ( dataAvailable (CHANNEL_3) ) {      
      if (firstTime) {
        startTemperatureValue = getData(CHANNEL_3);
        firstTime = false;
      } else temperatureValue = getData(CHANNEL_3);

      //println("Temperatura Inicial: "+startTemperatureValue);
      //println("Temperatura: "+temperatureValue);
    }
    
    if(timer.Ready(500))println("Temperatura: "+temperatureValue);
  }

  public float GetSpeedOnTempChange() {
    return (temperatureValue - startTemperatureValue) * 0.25;
  }

  public void ShutDown() {
    commManager();
  }

  public float GetTemperatureValue() {
    return GetSpeedOnTempChange();
    //return map(temperatureValue, startTemperatureValue - 5, startTemperatureValue + 5, 1, 4);
  }
  public float GetRotatorValue() {
    return map(rotatorValue, 0, 1023, height - height/10, height/10);
  }
  public float GetLightValue() {
    return map(lightValue, 50, 250, height - height/10, height/10);
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
    position.y = value;
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

  float baseSpeed, speed;
  vector direction;

  public Ball(float rad, vector pos, float bSpeed) {
    baseSpeed = bSpeed;
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
    speed = baseSpeed + (baseSpeed*s);
  }

  public void Update(InputManager im, Bar left, Bar right) {
    SetSpeed(im.GetTemperatureValue());
    //println("Ball Speed: "+speed);

    this.position.x = this.position.x + this.speed * this.direction.x;
    this.position.y += this.speed * this.direction.y;

    if (position.x > width-radius || position.x < radius) {
      if (direction.x > 0) {
        Reset();
        left.score++;
        if (left.score >= WIN_SCORE) {
          gameState = GameState.ENDGAME;
        }
      } else if (direction.x < 0) {
        Reset();
        right.score++;
        if (right.score >= WIN_SCORE) {
          gameState = GameState.ENDGAME;
        }
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

GameState gameState;
InputManager im;
Ball ball;
Bar barLeft, barRight;
HUD hud;

void setup() 
{
  size(640, 360);
  noStroke();
  frameRate(30);

  gameState = GameState.GAMEPLAY;
  hud = new HUD();
  im = new InputManager();
  ball = new Ball(20, new vector(width/2, height/2), 4);
  barLeft = new LeftBar(new vector(width/8, height/2), 10, 60);
  barRight = new RightBar(new vector(width - width/8, height/2), 10, 60);

  im.Setup();
}
void draw() 
{
  background(102);

  if ( isPortConnected()) {

    switch(gameState) {
    case GAMEPLAY:
      {//Update
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
      break;
    case ENDGAME:
      {
        if (barLeft.score >= WIN_SCORE) {
          text("LEFT PLAYER WINS!", width/4, height/2);
        } else text("RIGHT PLAYER WINS!", width/4, height/2);
      }
      break;
    }
  } else {
    im.ShutDown();
  }

  //clear();
}
