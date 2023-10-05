public class FlipperL {
  float x1, y1;
  float x2, y2;
  int line_length;
  float startAngleLeft = PI/6;
  float endAngleLeft = -PI/6;
  float angle = startAngleLeft;
  float angular_velocity = 0.5;

  public FlipperL (float x1, float y1, int line_length) {
    this.x1 = x1; 
    this.y1 = y1;
    this.line_length = line_length;
  }

  void display() {
    stroke(240, 200, 95);
	  strokeWeight(6);
    line(x1, y1, x2, y2);
  }

  void flipperLUpdate() {
    angular_velocity = -abs(angular_velocity);
    
    if (angle > endAngleLeft) {
      angle += angular_velocity;
    }
    else {
      angle = endAngleLeft;
    }
  }

  void flipperLReturn() {
    angular_velocity = abs(angular_velocity);
    
    if (angle < startAngleLeft) {
      angle += angular_velocity;
    }
    else {
      angle = startAngleLeft;
    }
  }
  
}

public class FlipperR {
  float x1, y1;
  float x2, y2;
  int line_length;
  float startAngleRight = PI*5/6;
  float endAngleRight = PI*7/6;
  float angle = startAngleRight;
  float angular_velocity = 0.5;

  public FlipperR (float x1, float y1, int line_length) {
    this.x1 = x1; 
    this.y1 = y1;
    this.line_length = line_length;
  }

  void display() {
    stroke(240, 200, 95);
	  strokeWeight(6);
    line(x1, y1, x2, y2);
  }

   void flipperRUpdate() {
    angular_velocity = -abs(angular_velocity);
    
    if (angle > endAngleRight) {
      angle += angular_velocity;
    }
    else {
      angle = endAngleRight;
    }
  }

  void flipperRReturn() {
    angular_velocity = abs(angular_velocity);
    
    if (angle < startAngleRight) {
      angle += angular_velocity;
    }
    else {
      angle = startAngleRight;
    }
  }

  
}
