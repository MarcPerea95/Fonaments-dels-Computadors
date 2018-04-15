color red = color(255, 0, 0);
color green = color(0, 255, 0);

class HUD {
 
  LED led;
  Rectangle buttonUp;


  HUD() {
    led = new LED(width/2f, height/2f, 10);
    buttonUp = new Rectangle(width/4f, height/4f, 50f, 50f);
    led.SetColor(green);
  }

  void Update(InputManager im) {
    buttonUp.Update();
  }
  void Draw() {
    led.Draw();
    buttonUp.Draw();
  }
}
