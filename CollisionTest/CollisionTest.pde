int canvasWidth = 800;
float s = canvasWidth / 10;
ArrayList<Circle> circles = new ArrayList<Circle>();
ArrayList<Line> lines = new ArrayList<Line>();
ArrayList<Box> boxes = new ArrayList<Box>();


double duration;
ArrayList<Double> durationList = new ArrayList<Double>(); 

void setup() {
  size(800, 800);
  surface.setTitle("Collision Detection Visulaize [CSCI 5611 HW1]");

  String[] FileName = {
    "1",
    // "2",
    // "3",
    // "4",
    // "5",
    // "6",
    // "7",
    // "8",
    // "9",
    // "10"
  };

  for (String file : FileName) {
    String inputFile = "./CollisionTasks/task" + file + ".txt";
    String outputFile = "./solutions/task" + file + "_solution.txt";
    readFile(inputFile);
    ArrayList<Integer> uniqueId = checkCollision();
    writeFile(outputFile, uniqueId); 
  } 

  exit();
  
}

ArrayList<Integer> checkCollision() {
  ArrayList<Integer> collisionId = new ArrayList<Integer>();
  // ArrayList<Integer> ccCollisionId = new ArrayList<Integer>();
  // ArrayList<Integer> clCollisionId = new ArrayList<Integer>();
  // ArrayList<Integer> cbCollisionId = new ArrayList<Integer>();
  // ArrayList<Integer> llCollisionId = new ArrayList<Integer>();
  // ArrayList<Integer> lbCollisionId = new ArrayList<Integer>();
  // ArrayList<Integer> bbCollisionId = new ArrayList<Integer>();
    
  long startTimes = System.nanoTime();

  // Iterate through Circles
  for (int i = 0; i < circles.size(); i++) {
    for (int j = i + 1; j < circles.size(); j++) {
      Circle circle1 = circles.get(i);
      Circle circle2 = circles.get(j);

      boolean collision = circleCircleCollision(circle1, circle2);
      
      // Display collision result
      if (collision) {
        collisionId.add(circle1.id);
        collisionId.add(circle2.id);
        // ccCollisionId.add(circle1.id);
        // ccCollisionId.add(circle2.id);
      }
      
    }
  }

  // Iterate through Circles and Lines
  for (int i = 0; i < circles.size(); i++) {
    for (int j = 0; j < lines.size(); j++) {
      Circle circle = circles.get(i);
      Line line = lines.get(j);

      boolean collision = circleLineCollision(circle, line);

      if (collision) {
        collisionId.add(circle.id);
        collisionId.add(line.id);
        // clCollisionId.add(circle.id);
        // clCollisionId.add(line.id);
      }

    }
  }

  // Iterate through Circles and Boxes
  for (int i = 0; i < circles.size(); i++) {
    for (int j = 0; j < boxes.size(); j++) {
      Circle circle = circles.get(i);
      Box box = boxes.get(j);

      boolean collision = circleBoxCollision(circle, box);

      if (collision) {
        collisionId.add(circle.id);
        collisionId.add(box.id);
        // cbCollisionId.add(circle.id);
        // cbCollisionId.add(box.id);
      }
    }
  }

  // Iterate through Lines
  for (int i = 0; i < lines.size(); i++) {
    for (int j = i + 1; j < lines.size(); j++) {
      Line line1 = lines.get(i);
      Line line2 = lines.get(j);

      boolean collision = lineLineCollision(line1, line2);
      
      if (collision) {
        collisionId.add(line1.id);
        collisionId.add(line2.id);
        // llCollisionId.add(line1.id);
        // llCollisionId.add(line2.id);
      }
    }
  }

  // Iterate through Lines and Boxes
  for (int i = 0; i < lines.size(); i++) {
    for (int j = 0; j < boxes.size(); j++) {
      Line line = lines.get(i);
      Box box = boxes.get(j);

      boolean collision = lineBoxCollision(line, box);
      
      if (collision) {
        collisionId.add(line.id);
        collisionId.add(box.id);
        // lbCollisionId.add(line.id);
        // lbCollisionId.add(box.id);
      }

    }
  }

  // Iterate through Boxes
  for (int i = 0; i < boxes.size(); i++) {
    for (int j = i + 1; j < boxes.size(); j++) {
      Box box1 = boxes.get(i);
      Box box2 = boxes.get(j);

      boolean collision = boxBoxCollision(box1, box2);
      
      if (collision) {
        collisionId.add(box1.id);
        collisionId.add(box2.id);        
        // bbCollisionId.add(box1.id);
        // bbCollisionId.add(box2.id);
      }
    }
  }
  
  duration = (System.nanoTime() - startTimes) / 1e6;
  durationList.add(duration);
  
  ArrayList<Integer> uniqueId = numCollision(collisionId);
  // ArrayList<Integer> ccUniqueId = numCollision(ccCollisionId);
  // ArrayList<Integer> clUniqueId = numCollision(clCollisionId);
  // ArrayList<Integer> cbUniqueId = numCollision(cbCollisionId);
  // ArrayList<Integer> llUniqueId = numCollision(llCollisionId);
  // ArrayList<Integer> lbUniqueId = numCollision(lbCollisionId);
  // ArrayList<Integer> bbUniqueId = numCollision(bbCollisionId);

  // println("Cirlce-cirlce collision: " + ccUniqueId.size());
  // println("Cirlce-line collision: " + clUniqueId.size());
  // println("Cirlce-box collision: " + cbUniqueId.size());
  // println("Line-line collision: " + llUniqueId.size()); 
  // println("Line-box collision: " + lbUniqueId.size());
  // println("Box-box collision: " + bbUniqueId.size());

  return uniqueId;
}

// unique the id list and format that in numerical order
ArrayList<Integer> numCollision(ArrayList<Integer> inputIdList) {
  ArrayList<Integer> uniqueList = new ArrayList<Integer>();

  for (Integer num : inputIdList) {
    // If the element is not already in the unique list, add it
    if (!uniqueList.contains(num)) {
      int index = 0;
      while (index < uniqueList.size() && uniqueList.get(index) < num) {
        index ++;
      }
      // insert the id to the correct position to follow the numerical order 
      uniqueList.add(index, num);
    }
  }
  return uniqueList;
}

// check the circle-circle collision
boolean circleCircleCollision(Circle circle1, Circle circle2) {
  float dx = circle1.centerX - circle2.centerX;
  float dy = circle1.centerY - circle2.centerY;
  float distance = sqrt(dx * dx + dy * dy);
  return distance < (circle1.radius + circle2.radius);
}

// check the circle-line collision
boolean circleLineCollision(Circle circle, Line line) {
  float d;
  // get distance from the circle's center to the line segment
  float lineLengthSquared = distSquared(line.x1, line.y1, line.x2,line.y2);
  if (lineLengthSquared == 0) {
    d = distSquared(circle.centerX, circle.centerY, line.x1, line.y1);
  }

  // calculate the t parameter (0 <= t <= 1) for the closest point on the line segment
  float t = ((circle.centerX - line.x1) * (line.x2 - line.x1) + (circle.centerY - line.y1) * (line.y2 - line.y1)) / lineLengthSquared;
  // clamp t to ensure it lies within the line segment
  t = max(0, min(1, t));
  
  // Calculate the coordinates of the closest point on the line segment
  float closestX = line.x1 + t * (line.x2 - line.x1);
  float closestY = line.y1 + t * (line.y2 - line.y1);
  
  // Calculate the squared distance from the point to the closest point on the line
  d = distSquared(circle.centerX, circle.centerY, closestX, closestY);

  // If the squared distance is less than the squared radius, there is an intersection
  return d <= pow(circle.radius, 2);
}

// Helper function to calculate the squared distance between two points.
float distSquared(float x1, float y1, float x2, float y2) {
  float dx = x2 - x1;
  float dy = y2 - y1;
  return dx * dx + dy * dy;
}

// check the circle-box collision
boolean circleBoxCollision(Circle circle, Box box) {
  float closestX = constrain(circle.centerX, box.centerX-box.widthBox/2, box.centerX+box.widthBox/2);
  float closestY = constrain(circle.centerY, box.centerY-box.heightBox/2, box.centerY+box.heightBox/2);
  float dx = circle.centerX - closestX;
  float dy = circle.centerY - closestY;
  float distance = sqrt(dx * dx + dy * dy);
  return distance < circle.radius;
}

// check line-line collision
boolean lineLineCollision(Line line1, Line line2) {
  // Calculate the direction vectors of the lines
  float dx1 = line1.x2 - line1.x1;
  float dy1 = line1.y2 - line1.y1;
  float dx2 = line2.x2 - line2.x1;
  float dy2 = line2.y2 - line2.y1;

  // Calculate the determinant of the direction vectors
  float det = dx1 * dy2 - dx2 * dy1;

  // Check if the lines are parallel (det ~= 0)
  if (abs(det) < 0.0001) {
    return false;
  }

  // Calculate parameters for the lines
  float t1 = ((line2.x1 - line1.x1) * dy2 - (line2.y1 - line1.y1) * dx2) / det;
  float t2 = ((line2.x1 - line1.x1) * dy1 - (line2.y1 - line1.y1) * dx1) / det;

  // Check if the intersection point is within the line segments
  return t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1;
}

// check the line-box collision
boolean lineBoxCollision(Line line, Box box) {
  
  float xMin = box.centerX-box.widthBox/2;
  float xMax = box.centerX+box.widthBox/2;
  float yMin = box.centerY-box.heightBox/2;
  float yMax = box.centerY+box.heightBox/2;
  // println("Box id is: " + box.id);
  // println("xMin: " + xMin);
  // println("xMax: " + xMax);
  // println("yMin: " + yMin);
  // println("yMax: " + yMax);

  // Check if the line is completely out of the box
  if (line.x1 < xMin && line.x2 < xMin) return false;
  if (line.x1 > xMax && line.x2 > xMax) return false;
  if (line.y1 < yMin && line.y2 < yMin) return false;
  if (line.y1 > yMax && line.y2 > yMax) return false;

  // Check if the line starts or end inside the box
  if ((line.x1 >= xMin && line.x1 <= xMax && line.y1 >= yMin && line.y1 <= yMax) || 
      (line.x2 >= xMin && line.x2 <= xMax && line.y2 >= yMin && line.y2 <= yMax)) { 
    return true;
  }

  // Check if the four line of box intersect with the box
  Line line1 = new Line(box.id, xMin, yMin, xMin, yMax);
  Line line2 = new Line(box.id, xMin, yMax, xMax, yMax);
  Line line3 = new Line(box.id, xMax, yMax, xMax, yMin);
  Line line4 = new Line(box.id, xMax, yMin, xMin, yMin);
  if (lineLineCollision(line, line1) || lineLineCollision(line, line2) || 
  lineLineCollision(line, line3) || lineLineCollision(line, line4)) {
    return true;
  }
  
  return false;
}

// check the box-box collision 
boolean boxBoxCollision(Box box1, Box box2) {
  return !(box1.centerX+box1.widthBox/2 < box2.centerX-box2.widthBox/2 || 
  box1.centerX-box1.widthBox/2 > box2.centerX+box2.widthBox/2 || 
  box1.centerY+box1.heightBox/2 < box2.centerY-box2.heightBox/2 || 
  box1.centerY-box1.heightBox/2 > box2.centerY+box2.heightBox/2);
}

// read file function
void readFile(String inputFilePath) {

  try {
    BufferedReader reader = createReader(inputFilePath);

    String dataType = null;
    int count = -1;
    int id = -1;

    String line;
    // read line by line 
    while ((line = reader.readLine()) != null) {
      // split the text input by space new line and :
      String[] parts = line.split("[\\s:]+");

      if (parts.length == 2) {
        dataType = parts[0];
        count = int(parts[1]);
      } else if (dataType != null && !parts[0].equals("#")) { // ignore the text hint here
        if (dataType.equals("Circles") && parts.length == 4) {
          Circle circleShape = new Circle(int(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]));
          circles.add(circleShape);
        } else if (dataType.equals("Lines") && parts.length == 5) {
          Line lineShape = new Line(int(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]), float(parts[4]));
          lines.add(lineShape);
        } else if (dataType.equals("Boxes") && parts.length == 5){
          Box boxShape = new Box(int(parts[0]), float(parts[1]), float(parts[2]), float(parts[3]), float(parts[4]));
          boxes.add(boxShape);
        } else {
          println("Not a valid shape input for detecting in this collision library");
        }
      }
    }

    reader.close();

  } catch (IOException e) {
    e.printStackTrace();
  }
}

// write file function
void writeFile(String outputFilePath, ArrayList<Integer> uniqueId) {
  PrintWriter writer = createWriter(outputFilePath);
  writer.println("Duration: " + duration + " ms");
  writer.println("Num Collisions: " + uniqueId.size());
    for (Integer i : uniqueId) {
      writer.println(i);
    }

  writer.flush();
  writer.close();
}

void draw() {
  background(255);

  strokeWeight(1);
  stroke(0);
  for (Line lineShape : lines) {
    line(lineShape.x1 * s, lineShape.y1 * s, lineShape.x2 * s, lineShape.y2 * s);
  }
  
  noStroke();
  fill(10, 120, 10);
  for (Circle circleShape : circles) {
    circle(circleShape.centerX * s, circleShape.centerY * s, circleShape.radius * 2 * s);
  }

  fill(180, 60, 40);
  for (Box boxShape : boxes) {
    quad((boxShape.centerX-boxShape.widthBox/2)*s, (boxShape.centerY-boxShape.heightBox/2)*s, 
    (boxShape.centerX-boxShape.widthBox/2)*s, (boxShape.centerY+boxShape.heightBox/2)*s,
    (boxShape.centerX+boxShape.widthBox/2)*s, (boxShape.centerY+boxShape.heightBox/2)*s,
    (boxShape.centerX+boxShape.widthBox/2)*s, (boxShape.centerY-boxShape.heightBox/2)*s);
  }
  

}