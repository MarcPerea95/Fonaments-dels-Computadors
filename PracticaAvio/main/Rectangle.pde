
class Rectangle extends Object {
  float w, h;
  color c;


  boolean previousMouseState;

  Rectangle() {
    position = new Vector();
    w = 0;
    h = 0;
    c = color(255, 255, 255);

  }
  Rectangle(float x, float y, float w, float h) {
    position = new Vector(x, y);
    this.w = w;
    this.h = h;
    c = color(255, 255, 255);

  }

  boolean PointCollision(Vector p) {
    return false;
  }

  void Update() {
  }

  boolean CheckMouse() {
    //if (mousePressed && (mouseButton == LEFT)) {
    if (mouseX > position.x - w/2 && mouseX < position.x + w/2 && mouseY > position.y - h/2 && mouseY < position.y + h/2) {
      c = color(245, 245, 245);
      if (mousePressed && mouseButton == LEFT && previousMouseState == false) {
        c = color(230, 230, 230);
        //HAZ COSAS DE BOTON
        previousMouseState = mousePressed;
        return true;
      }
      previousMouseState = mousePressed;
      return false;
    } else {
      c = color(255, 255, 255);
      previousMouseState = mousePressed;
      return false;
    }
    //}
  }
  void Draw() {
    fill(c);
    rectMode(CENTER);
    rect(position.x, position.y, w, h);
  }
}
