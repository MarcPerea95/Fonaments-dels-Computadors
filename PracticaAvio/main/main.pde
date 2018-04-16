

InputManager im;
HUD hud;
void setup() {
  size(512, 512);
  im = new InputManager();
  hud = new HUD();
  im.Setup();
}
void draw() {

clear();

  if (isPortConnected()) {
    hud.Update(im);
    im.Update();

    hud.Draw();
  } 
  im.ShutDown();
  
}
