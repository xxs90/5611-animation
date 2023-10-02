import processing.sound.*;
Sound s;

ArrayList<PImage> backgrounds = new ArrayList<PImage>();
int currentBackgroundIndex = 0;
boolean showBackground = false;

ArrayList<Line> walls = new ArrayList<Line>();
ArrayList<Ball> circles = new ArrayList<Ball>();
ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Box> blocks = new ArrayList<Box>();

int ballNumber = 1;
int lives = ballNumber;
int blockNumber = ballNumber;

Flipper flipperL;
Flipper flipperR;

float ballsize = 40;
int paddleWidth = 60;
int paddleHeight = 10;
int paddleSpeed = 5;
float paddleX;

int boxWidthLimit = 100;
int boxHeightLimit = 50;

int width = 800;
int height = 1000;
int minX = 10;
int minY = 10;
int maxX = width - minX;
int maxY = height - 100;

int score = 0;
boolean startGame = false;
boolean endGame = false;

void setup() {
  size(800, 1000);

	// Load background images from a directory (you can customize this part)
	File folder = new File(sketchPath("./backgrounds/")); // Replace with your folder path
	File[] files = folder.listFiles();
	println(files);
	
	for (File file : files) {
		if (file.isFile() && file.getName().toLowerCase().endsWith(".jpg")) {
			PImage bg = loadImage(file.getAbsolutePath());
			backgrounds.add(bg);
		}
	}

	for (int i = 0; i < ballNumber; i++) {
		balls.add(new Ball(random(minX, maxX), 50, 0, 2, ballsize));
	}
	for (int i = 0; i < blockNumber; i++) {
		blocks.add(new Box(random(minX, maxX-5), random(minY, maxY-5), 10, 10, 0));
	}
	
	circles.add(new Ball(width/2, height/5, 0, 0, 120));
	circles.add(new Ball(width/4, height-200, 0, 0, 60));

	Line wallTop = new Line(minX, minY, maxX, minY);
	walls.add(wallTop);
	Line wallLeft = new Line(minX, minY, minX, maxY);
	walls.add(wallLeft);
	Line wallRight = new Line(maxX, minY, maxX, maxY);
	walls.add(wallRight);
	Line wallDownL = new Line(minX, maxY, width*1.5/6, maxY+20);
	walls.add(wallDownL);
	Line wallDownR = new Line(maxX, maxY, width*4.5/6, maxY+20);
	walls.add(wallDownR);
	Line wall1 = new Line(width/10, width/6, width/4, height/3);
	walls.add(wall1);
	Line wall2 = new Line(width*9/10, height/2, width*7/10, height*3/4);
	walls.add(wall2);
	
	paddleX = (width - paddleWidth) / 2;
	flipperL = new Flipper(width*1.5/6, maxY+20, width*2.75/6, maxY+60, PI/120);
	flipperR = new Flipper(width*4.5/6, maxY+20, width*3.25/6, maxY+60, PI/120);
   
}

void draw() {
  frameRate(120);
  background(255, 255, 255);

	if (!startGame) {
		fill(0, 0, 0);
		textSize(48);
		textAlign(CENTER, CENTER);
		text("PinBall Game", width/2, height/2-50);
		textSize(24);
		text("Press 'Enter' to start game!", width/2, height/2);
	}
	else {
		if (!endGame) {
			if (showBackground && backgrounds.size() > 0) {
				// Display the current background image
				image(backgrounds.get(currentBackgroundIndex), 0, 0, width, height);
			}

			// Draw balls
			for (int i = 0; i < balls.size(); i++) {
				Ball ball = balls.get(i);
				// println("Speed x " + ball.speedX);
				// println("Speed y " + ball.speedY);
				ball.move();
				// println("New Speed x " + ball.speedX);
				// println("New Speed y " + ball.speedY);

				// Check for collisions
				for (int j = 0; j < balls.size(); j++) {
					if (i != j) {
						ball.checkCollisionBalls(balls.get(j));
					}
				}

				for (Ball circle : circles) {
					ball.checkCollisionWithStaticBall(circle);
				}

				for (Box block : blocks) {
					ball.checkCollision(block);
				}
				
				for (Line wall : walls) {
					println("Before hit wall: x: " + ball.speedX + " m/s, y: " + ball.speedY + "m/s");
					ball.checkCollisionWithWall(wall);
				}
				
				ball.checkCollision(flipperL);
				ball.checkCollision(flipperR);

				ball.display();

				if (ball.y > maxY+60) {
					balls.remove(i);
					loseLife();
				}

			}

			// Draw blocks
			for (int i = 0; i < blocks.size(); i++) {
				blocks.get(i).display();
			}
			// Draw lines
			for (int i = 0; i < walls.size(); i++) {
				walls.get(i).display();
			}

			// Draw big balls
			for (int i = 0; i < circles.size(); i++) {
				circles.get(i).displayBigBall();
			}

			// Draw flippers
			if (!keyPressed){
				flipperL.rotateObjectBack();
				flipperR.rotateRObjectBack();
			}
			flipperL.display();
			flipperR.display();

			fill(0, 0, 0);
			textSize(12);
			textAlign(LEFT);
			text("Life: ", width-80, 25);
			text(lives, width-40, 25);
			text("Score: ", width-80, 35);
			text(score, width-40, 35);
		}
		else {
			fill(0, 0, 0);
			textSize(48);
			textAlign(CENTER, CENTER);
			text("GAME OVER", width/2, height/2-50);
			textSize(24);
			text("Press 'e' to exit game!", width/2, height/2);
		}
	}

}

void keyPressed() {
  if (keyCode == ENTER) {
		startGame = true;
	}
	else if (keyCode == LEFT) {
    flipperL.rotateObject();
  }// if the key 'z' is pressed, rotate the paddle.
	else if (keyCode == RIGHT) {
		flipperR.rotateRObject();
	}
  else if (key == 'y' || key == 'Y') {
    showBackground = true;
  }  
  else if (key == 'n' || key == 'N') {
    showBackground = false;
  }
  else if ((key == 't' || key == 'T') && showBackground) {
    if (backgrounds.size() > 0) {
      // Switch to the next background image when the "t" key is pressed
      currentBackgroundIndex = (currentBackgroundIndex + 1) % backgrounds.size();
    }
  }
	else if (key == 'e' || key == 'E') {
		exit();
	}
}

void loseLife() {
	lives--;

	if (balls.size() == 0) {
		endGame = true;
	}
}