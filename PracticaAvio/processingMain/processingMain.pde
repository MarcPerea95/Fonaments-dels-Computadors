

InputManager im;
HUD hud;
void setup() {
  size(512, 512);
  im = new InputManager();
  hud = new HUD();
  //im.Setup();
}
void draw() {
  
  hud.Update(im);
  
  
  hud.Draw();
  /*
  if (isPortConnected()) {
    //LOOP
  }
  */
}
