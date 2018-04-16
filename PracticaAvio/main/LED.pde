class LED extends Object {
  private color c;
  float lightRad;
  LED() {
    position = new Vector();
    c = color(0, 0, 0);
    lightRad = 10;
  }
  LED(float x, float y, float rad) {
    position = new Vector(x,y);
    c = color(0, 0, 0);
    lightRad = rad;
  }
  void SetColor(color clr) {
    c = clr;
  }
  color GetColor() {
    return c;
  }

  void Update() {
    
  }
  void Draw() {
    noStroke();
    fill(c);
    ellipseMode(RADIUS);
    ellipse(position.x, position.y, lightRad, lightRad);
  }
}
