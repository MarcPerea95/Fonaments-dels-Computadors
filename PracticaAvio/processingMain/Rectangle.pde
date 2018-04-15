class Rectangle extends Object {
  float w, h;
  color c;
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
    //if (mousePressed && (mouseButton == LEFT)) {
    if (mouseX > position.x - w/2 && mouseX < position.x + w/2 && mouseY > position.y - h/2 && mouseY < position.y + h/2) {
      c = color(245, 245, 245);
      if (mousePressed && mouseButton == LEFT) {
        c = color(230, 230, 230);
        
      }
    } else {
      c = color(255, 255, 255);
    }
    //}
  }
  void Draw() {
    fill(c);
    rectMode(CENTER);
    rect(position.x, position.y, w, h);
  }
}
