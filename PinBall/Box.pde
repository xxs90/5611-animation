public class Box {
  float x, y;
  float width, height;
  float angle = 0;

  public Box (float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
  
  void display() {
    noStroke();
    fill(255, 255, 255);
    rect(x, y, width, height);
  }
}
