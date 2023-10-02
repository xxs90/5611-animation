public class Box {
  float x, y;
  float width, height;
  float speedX;
  float angle = 0;

  public Box (float x, float y, float width, float height, float speedX) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.speedX = speedX;
  }
  
  void display() {
    noStroke();
    fill(125, 125, 125);
    rect(x, y, width, height);
  }

  void moveLeft() {
    x -= speedX;
  }

  void moveRight() {
    x += speedX;
  }
}
