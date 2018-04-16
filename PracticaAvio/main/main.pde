

InputManager im;
HUD hud;
void setup() {
  size(512, 512);
  im = new InputManager();
  hud = new HUD();
  im.Setup();
}
void draw() {



  if (isPortConnected()) {
    hud.Update(im);


    hud.Draw();
  } else {
    im.ShutDown();
  }
}
