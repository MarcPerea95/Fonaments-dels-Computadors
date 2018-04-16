color red = color(255, 0, 0);
color green = color(0, 255, 0);

class HUD {

  LED led;
  Rectangle buttonUp, buttonDown;

  int engineSpeedModifier;
  long altitude;


  HUD() {
    led = new LED(width/2f, height/2f, 10);
    buttonUp = new Rectangle(width/4f, height/4f, 50f, 50f);
    buttonDown = new Rectangle(width/4f, height - height/4f, 50f, 50f);
    led.SetColor(green);
    engineSpeedModifier = 0;
  }

  float GetEngineSpeedModifier() {
    return engineSpeedModifier;
  }

  void Update(InputManager im) {
    if (buttonUp.CheckMouse()) {
      engineSpeedModifier++;
      im.SendEngineSpeed(engineSpeedModifier);
      print(engineSpeedModifier+"\n");
    }
    if (buttonDown.CheckMouse()) {
      engineSpeedModifier--;
      im.SendEngineSpeed(engineSpeedModifier);
      print(engineSpeedModifier+"\n");
    }
    
    led.SetColor(im.GetCriticalSignal() ? green : red);
    
    altitude = im.GetAltitude();
  }
  void Draw() {
    textSize(32);
    textAlign(CENTER);
    text("Altutude: "+altitude, width/2, height/8);
    led.Draw();
    buttonUp.Draw();
    buttonDown.Draw();
  }
}
