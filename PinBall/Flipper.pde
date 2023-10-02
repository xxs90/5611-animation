public class Flipper {
  float x1, y1, x2, y2;
  float x, y;
  float width, height;
  float speedX = 5;
  float jitter = PI/360;
  float jitter_current = 0;
  float angle = 0;
  boolean flipPaddle = false;

  public Flipper (float x1, float y1, float x2, float y2, float jitter) {
    this.x1 = x1; this.y1 = y1;
    this.x2 = x2; this.y2 = y2;
    this.x = (x1 + x2) / 2;
    this.y = (y1 + y2) / 2;
    this.width = x1-x2;
    this.height = y1-y2;
    this.speedX = 3;
    this.jitter = jitter;
  }

  void display() {
    stroke(150, 100, 200);
	strokeWeight(4);
    line(x1, y1, x2, y2);
  }

  void moveLeft() {
    x1 -= speedX;
    x2 -= speedX;
  }

  void moveRight() {
    x1 += speedX;
    x2 += speedX;
  }

  // write a rotate function using matrix transformation for the line segment.
  void rotateObject() {
    if (angle < 50){
      Vec2 v = new Vec2(x2 - x1, y2 - y1);
      float length = v.mag();
      jitter_current = jitter;
      v.x = v.x * cos(jitter_current) - v.y * sin(jitter_current);
      v.y = v.x * sin(jitter_current) + v.y * cos(jitter_current);
      x2 = x1 + v.normalize().mult(length).x;
      y2 = y1 + v.normalize().mult(length).y;
      angle += 1;
      // println(angle);
    }
    if (angle == 50){
      jitter_current = 0;
    }
    // calculate the transform matrix for the line segment and apply it to the line segment.
  }

  void rotateObjectBack() {
    if (angle > 0){
      Vec2 v = new Vec2(x2 - x1, y2 - y1);
      float length = v.mag();
      jitter_current = -2*jitter;
      v.x = v.x * cos(jitter_current) - v.y * sin(jitter_current);
      v.y = v.x * sin(jitter_current) + v.y * cos(jitter_current);
      x2 = x1 + v.normalize().mult(length).x;
      y2 = y1 + v.normalize().mult(length).y;
      angle -= 2;
    }
    if (angle == 0){
      jitter_current = 0;
    }
    // calculate the transform matrix for the line segment and apply it to the line segment.
  }

  
  // void flipPaddle() {
  //     if (flipPaddle) {
  //         if (paddle.angle < radians(60)) {
  //         paddle.angle += radians(5);                     
  //         }
  //     }
  // }

  // // check if the line segment intersects with the rectangle
  // boolean intersects(Rectangle r) {
  //     // check if the line segment intersects with any of the four sides of the rectangle
  //     LineSegment top = new LineSegment(r.x, r.y, r.x + r.width, r.y);
  //     LineSegment bottom = new LineSegment(r.x, r.y + r.height, r.x + r.width, r.y + r.height);
  //     LineSegment left = new LineSegment(r.x, r.y, r.x, r.y + r.height);
  //     LineSegment right = new LineSegment(r.x + r.width, r.y, r.x + r.width, r.y + r.height);

  //     return intersects(top) || intersects(bottom) || intersects(left) || intersects(right);
  // }

  // // check if the line segment intersects with another line segment
  // boolean intersects(LineSegment l) {
  //     // check if the two line segments are parallel
  //     float denominator = (l.y2 - l.y1) * (x2 - x1) - (l.x2 - l.x1) * (y2 - y1);
  //     if (denominator == 0) {
  //         return false;
  //     }

  //     // calculate the intersection point
  //     float ua = ((l.x2 - l.x1) * (y1 - l.y1) - (l.y2 - l.y1) * (x1 - l.x1)) / denominator;
  //     float ub = ((x2 - x1) * (y1 - l.y1) - (y2 - y1) * (x1 - l.x1)) / denominator;

  //     // check if the intersection point is on both line segments
  //     if (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1) {
  //         return true;
  //     }

  //     return false;
  // }
}
