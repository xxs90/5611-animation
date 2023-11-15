//Initialize obstacles, agent and destination
ArrayList<PVector> obstacles = new ArrayList<PVector>();
PShape obstacle;
float obstacleRadius = 1.2;
PVector agentPos;
PShape agent;
float agentRadius = 0.8;
PVector goalPos;
PShape goal;

//PRM Setup
int samples = 150; 
float neighborRadius = 0.5; 
PRM prm;
ArrayList<Integer> path;
boolean reached;

// Dafault Setup
float sceneSize = 30;
int height = 80;
PImage image;
boolean topDownView;
int round = 0;
float velocity = 5;
int index;


//Create Window
void setup() {
  size(800, 800, P3D);
	image = loadImage("clear-ocean-water-texture.jpg");
  surface.setTitle("Friends finding under the sea");
  camera(0, 220, 0, 0, 0, 0, 0, 0, 1);
  init();
}


void init() {
	// from a top-down view, x is left to right, y is up and down
	//						y-
	// x+ <----------------- x-
	//						y+
  obstacles.add(new PVector(1, -6));
  obstacles.add(new PVector(9, -9));
	obstacles.add(new PVector(7, -2));
	obstacles.add(new PVector(-8, -6));
	obstacles.add(new PVector(5, 6));
	obstacles.add(new PVector(-10, 8));
	obstacles.add(new PVector(-4, 5));
  
	obstacle = loadShape("Seaweed.obj");

	if (round == 0) { 
  	agentPos = new PVector(-10, -10);
  	goalPos = new PVector(10, 10);
	}
	else if (round == 1) {
		agentPos = new PVector(4, -10);
  	goalPos = new PVector(-10, 3);
	}
	else if (round == 2) {
		agentPos = new PVector(-10, 0);
  	goalPos = new PVector(9, 8);
	}
	else if (round == 3) {
		agentPos = new PVector(0, 7);
		goalPos = new PVector(-12, -9);
	}
	agent = loadShape("Fish.obj");
	// rotate the load shape to make it face the right direction (it is lay down in the original file)
	agent.rotateX(-PI/2);
	goal = loadShape("Turtle.obj");

	topDownView = true;
  prm = new PRM(samples);
  reached = false;
  path = pathSearch();
  index = 1;
}


void update(float dt){
  if (index < path.size()){ // not reached destination
    PVector dir = PVector.sub(prm.mspos[path.get(index)], agentPos).normalize();
    agentPos.add(PVector.mult(dir,velocity*dt));
    if (PVector.sub(prm.mspos[path.get(index)], agentPos).mag()<0.05 ||
    (index < path.size()-1 &&
    accessible(agentPos, prm.mspos[path.get(index+1)],obstacleRadius+agentRadius)))
    index++;
  }
}


//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  // Static Scene
  background(150,200,215);
  ambientLight(128, 128, 128);
  directionalLight(128, 128, 128, 0, -1, 0);
  lightSpecular(0, 0, 0);

	// draw a image to show the ground
	pushMatrix();
	beginShape(QUADS);
	texture(image);
	translate(0, -height/2, 0);
	vertex(-sceneSize*6, 0, -sceneSize*6, 0, 0);
	vertex(sceneSize*6, 0, -sceneSize*6, image.height, 0);
	vertex(sceneSize*6, 0, sceneSize*6, image.height, image.width);
	vertex(-sceneSize*6, 0, sceneSize*6, 0, image.width);
	endShape();
	popMatrix();

	// draw the obstacles
  update(.01);
  noFill();
  stroke(200);
  noStroke();
  fill(200, 200, 200);
  for (PVector obs : obstacles) {
    pushMatrix();
    translate(10*obs.x, -height/2, 10*obs.y);
		scale(5, 5, 15);
		shape(obstacle, 0, 0);
    popMatrix();
  }

	// Agent Visualization
	PVector dir;
	if (index < path.size()-1) {
		dir = PVector.sub(prm.mspos[path.get(index)], prm.mspos[path.get(index-1)]).normalize();
	}
	else {
		// keep the agent facing the destination
		dir = PVector.sub(goalPos, agentPos).normalize();
	}
	pushMatrix();
	// let the agent turn 90 degrees to face the left direction
	translate(10*agentPos.x, height/8, 10*agentPos.y);
	rotateY(atan2(dir.x, dir.y)+PI/2);
	shape(agent, 0, 0);
	rotateZ(-PI);
	popMatrix();

	// Destination Visualization
	pushMatrix();
	translate(10*goalPos.x, -height/4, 10*goalPos.y);
	scale(20);
	shape(goal, 0, 0);
	popMatrix();
  
  // PRM Visualization
  stroke(50, 50, 50);
  strokeWeight(4);
	// Start defining points
	beginShape(POINTS); 
	for (int i = 0; i < samples + 2; i++) {
		vertex(10 * prm.mspos[i].x, -height / 2, 10 * prm.mspos[i].y);
	}
	endShape(); 
	// Start defining connections
	strokeWeight(1);
	beginShape(LINES); 
	for (int i = 0; i < samples + 2; i++) {
		for (int j = i + 1; j < samples + 2; j++) {
			if (prm.adjacent[i][j]) {
				vertex(10 * prm.mspos[i].x, -height / 2, 10 * prm.mspos[i].y);
				vertex(10 * prm.mspos[j].x, -height / 2, 10 * prm.mspos[j].y);
			}
		}
	}
	endShape(); 
	// Path Visualization
	stroke(255, 255, 0);
  strokeWeight(2);
	beginShape(LINES);
  for (int i = 0; i < path.size() - 1; i++) {
    vertex(10 * prm.mspos[path.get(i)].x, -height / 2, 10 * prm.mspos[path.get(i)].y);
    vertex(10 * prm.mspos[path.get(i + 1)].x, -height / 2, 10 * prm.mspos[path.get(i + 1)].y);
  }
  endShape();
  
}

// Key Pressed Function
void keyPressed() {
	// press enter for reset
  if (keyCode == ENTER) {
		print(round);
		round = (round + 1) % 4;
		init();
	}
	// press space for top down view toggle
	else if (key == ' ') {
		if (topDownView) camera(0, 50, 300, 0, -100, -300, 0, -1, 0);
		else camera(0, 220, 0, 0, 0, 0, 0, 0, 1);
		topDownView = !topDownView;
  }
}




