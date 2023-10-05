import ddf.minim.*;

Minim minim;
AudioPlayer playerPing, playerFirework, playerStart, playEnd;

ArrayList<PImage> backgrounds = new ArrayList<PImage>();
int currentBackgroundIndex = 0;

ArrayList<Line> walls = new ArrayList<Line>();
ArrayList<Ball> circles = new ArrayList<Ball>();
ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Box> blocks = new ArrayList<Box>();
ArrayList<Particle> fireworks = new ArrayList<Particle>();

int ballNumber = 6;
float ballsize = 50;
int lives = ballNumber;
int blockNumber = ballNumber;
int hitCircle = 0;
int hitCircleCount = -1;
int hitBlock = 0;

FlipperL flipperL;
FlipperR flipperR;

int width = 800;
int height = 1000;
int minX = 20;
int minY = 20;
int maxX = width - minX;
int maxY = height - minY*8;

int score = 0;
int previousScore = 0;
boolean startGame = false;
boolean endGame = false;

float gravity = 0.2;

void setup() {
  size(1200, 1000);

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

	minim = new Minim(this);
	playerPing = minim.loadFile("./sounds/ping-82822.mp3");
	playerFirework = minim.loadFile("./sounds/firework-show-short-64657.mp3");
	playerStart = minim.loadFile("game-start-6104.mp3");
	playEnd = minim.loadFile("negatice_beeps-6008.mp3");

	for (int i = 0; i < ballNumber; i++) {
		balls.add(new Ball(random(minX+ballsize*2, maxX-ballsize*2), 50, 0, gravity, ballsize));
	}
	blocks.add(new Box(200, 500, 20, 20));
	
	circles.add(new Ball(width/2, height/4, 0, 0, 80));
	circles.add(new Ball(width/2-40, height/4+70, 0, 0, 80));
	circles.add(new Ball(width/2+40, height/4+70, 0, 0, 80));

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
	walls.add(new Line(minX+80, height/2, minX+80, maxY-100));
	walls.add(new Line(width/10, width/6, width/4, height/3));
	walls.add(new Line(width*9/10, height/2, width*7/10, height*3/4));

	flipperL = new FlipperL(width*1.5/6+4, maxY+24, 180);
	flipperR = new FlipperR(width*4.5/6-4, maxY+24, 180);
   
}

void draw() {
  frameRate(200);
  background(255, 255, 255);

	if (backgrounds.size() > 0) {
		// Display the current background image
		image(backgrounds.get(currentBackgroundIndex), 0, 0, width, height);
	}

	if (!startGame) {
		fill(0, 0, 0);
		textSize(48);
		textAlign(CENTER, CENTER);
		text("PinBall Game", 1000, height/2-50);
		textSize(24);
		text("Press 'Enter' to start game!", 1000, height/2);
	}
	else {
		if (!endGame) {
			// Draw balls
			for (int i = 0; i < balls.size(); i++) {
				Ball ball = balls.get(i);
				ball.move();

				// Check for collisions
				// moving balls collision
				for (int j = 0; j < balls.size(); j++) {
					if (i != j) {
						ball.checkCollisionBalls(balls.get(j));
					}
				}

				// balls and circular object collision
				for (Ball circle : circles) {
					hitCircle = ball.checkCollisionWithStaticBall(circle);
				}

				if (hitCircle > hitCircleCount && hitCircle != 0) {
					// play music when hit circles
					playerPing.play();
					hitCircleCount =hitCircle;
				}

				// balls and lines collision
				for (Line wall : walls) {
					ball.checkCollisionWithWall(wall);
				}

				// balls and blocks collision
				for (Box block : blocks) {
					ball.checkCollisionWithBox(block);
				}
				// progressive effect of moving blocks
				if (hitBlock == 1) {
					blocks.remove(0);
					blocks.add(new Box(400, 500, 20, 20));
				}
				else if (hitBlock ==2) {
					blocks.remove(0);
					blocks.add(new Box(600, 500, 20, 20));
				}
				else if (hitBlock == 3) {
					fill(0, 0, 0);
					textSize(24);
					textAlign(LEFT);
					text("Doing Great ", 850, 200);
				}
				
				// balls and flipper collision
				ball.checkCollisionWithFlipperL(flipperL);
				ball.checkCollisionWithFlipperR(flipperR);

				ball.display();

				// when if falls out of screen, lose one life
				if (ball.y > height) {
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

			for (int i = fireworks.size() - 1; i >= 0; i--) {
				Particle p = fireworks.get(i);
				p.update();
				p.display();

				// Remove particles when they go off-screen or reach their lifespan
    		if (p.isDead()) {
      		fireworks.remove(i);
    		}
			}
			
			if (score % 10 == 0 && score != previousScore) {
    		fireworks.add(new Particle(width/2, height/2));
				playerFirework.play();
			}

			

			// Draw flippers
			if (!keyPressed){
				flipperL.flipperLReturn();
				flipperR.flipperRReturn();
			}
			flipperL.display();
			flipperR.display();

			// Show scores and life
			fill(constrain(score*3, 0, 255), 0, 0);
			textSize(48);
			textAlign(LEFT);
			text("Life: ", 850, 60);
			text(lives, 1050, 60);
			text("Score: ", 850, 120);
			text(score, 1050, 120);
		}
		else { // game over
			fill(0, 0, 0);
			textSize(48);
			textAlign(CENTER, CENTER);
			text("GAME OVER", 1000, height/2-50);
			textSize(24);
			text("Press 'e' to exit game!", 1000, height/2);
		}
	}

}

void keyPressed() {
  if (keyCode == ENTER) {
		startGame = true;
	}
	else if (keyPressed && key == CODED && keyCode == LEFT) {
    flipperL.flipperLUpdate();
  }
	else if (keyPressed && key == CODED && keyCode == RIGHT) {
		flipperR.flipperRUpdate();
	}
  else if (key == 't' || key == 'T') {
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
