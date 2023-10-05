public class Ball {
	float x, y;
	float speedX, speedY;
	float radius;

	public Ball(float x, float y, float speedX, float speedY, float size) {
		this.x = x;
		this.y = y;
		this.speedX = speedX;
		this.speedY = speedY;
		this.radius = size/2;
	}

	void move() {
		x += speedX;
		speedY += gravity;
		y += (speedY + 1);
		// println("Speed x" + x);
		// println("Speed y" + y);
	}

	// check the collision between the ball and the other Rectangle.
	int checkCollisionWithBox(Box r) {
		// check if the ball intersects with the for sides of the rectangle
		Line top = new Line(r.x, r.y, r.x + r.width, r.y);
		Line bottom = new Line(r.x, r.y + r.height, r.x + r.width, r.y + r.height);
		Line left = new Line(r.x, r.y, r.x, r.y + r.height);
		Line right = new Line(r.x + r.width, r.y, r.x + r.width, r.y + r.height);

		if (checkCollisionWithWall(top) || checkCollisionWithWall(bottom) || checkCollisionWithWall(left) || checkCollisionWithWall(right)) {
			score += 5;
			hitBlock += 1;
		}

		return hitBlock;
	}

	// check the collision between two balls by commparing the distance between the centers of the two balls and the sum of their radius.
	void checkCollisionBalls(Ball b) {
		float restitution = 0.8;

		Vec2 distance_v = new Vec2(x - b.x, y - b.y);
		float distance = distance_v.magnitude();

		if (distance <= radius + b.radius) {
			float r = radius + b.radius;
			Vec2 mid = new Vec2((x + b.x) / 2, (y + b.y) / 2);
			Vec2 ball1 =  distance_v.normalize().mult(r/1.5).add(mid);
			Vec2 ball2 =  mid.sub(distance_v.normalize().mult(r/1.5));
			x = ball1.x;
			y = ball1.y;
			b.x = ball2.x;
			b.y = ball2.y;
			
			// calculate the reflecting velocity of the two balls.
			Vec2 v1 = new Vec2(speedX, speedY);
			Vec2 v2 = new Vec2(b.speedX, b.speedY);
			Vec2 n = new Vec2(distance_v.x, distance_v.y).normalize();
			Vec2 r1 = v1.sub(n.mult(2 * v1.dot(n)));
			Vec2 r2 = v2.sub(n.mult(2 * v2.dot(n)));
			speedX = r1.x;
			speedY = r1.y;
			b.speedX = r2.x * restitution;
			b.speedY = r2.y * restitution;
		}
	}

	// check the collision between stationary ball and moving ball.
	int checkCollisionWithStaticBall(Ball ball) {
		float dx = x - ball.x;
		float dy = y - ball.y;
		float distance = sqrt(dx * dx + dy * dy);

		if (distance <= radius + ball.radius) {
			playerPing.play();

			// Calculate the collision normal (unit vector pointing from stationaryBall to movingBall)
			float nx = dx / distance;
			float ny = dy / distance;

			// Calculate dot product of relative velocity and normal vector
			float dotProduct = speedX * nx + speedY * ny;

			// Calculate impulse (change in velocity)
			float impulseX = 1.6 * dotProduct * nx;
			float impulseY = 1.6 * dotProduct * ny;

			// Update the moving ball's velocity
			speedX -= impulseX;
			speedY -= impulseY;

			// Separate the balls to avoid overlap
			float overlap = (radius + ball.radius) - distance;
			float pushX = (overlap / 2.0) * nx;
			float pushY = (overlap / 2.0) * ny;

			speedX += pushX;
			speedY += pushY;

			score += 1;
			hitCircle += 1;
		}
		return hitCircle;
	}

	boolean checkCollisionWithWall(Line l){
		float damping = 0.6;
		// Calculate the vector components of the line segment
		float dx = l.x2 - l.x1;
		float dy = l.y2 - l.y1;

		// Calculate the length of the line segment
		double d = sqrt(dx * dx + dy * dy);

		// Calculate the parameter 'u' that determines the closest point on the line to the ball
		float u = ((x - l.x1) * dx + (y - l.y1) * dy) / ((float)d * (float)d);
		
		// Clamp 'u' to the range [0, 1] to ensure it's within the line segment
  	u = constrain(u, 0, 1);

		// Calculate the coordinates of the closest point on the line
		float closestX = l.x1 + u * dx;
		float closestY = l.y1 + u * dy;

		// Calculate the distance between the ball's center and the closest point on the line
		float distanceX = closestX - x;
		float distanceY = closestY - y;
		double distance = sqrt(distanceX * distanceX + distanceY * distanceY);

		// Check if a collision occurs by comparing the distance to the ball's radius
		if (distance <= radius) {
			// Calculate the reflecting velocity of the ball
			Vec2 v = new Vec2(speedX, speedY); // Ball's velocity vector
			Vec2 n = new Vec2((float)distanceX, (float)distanceY).normalize(); // Normal vector at collision point
			Vec2 r = v.sub(n.mult(2 * v.dot(n))); // Reflecting velocity
			
			// Apply damping only to the perpendicular component of velocity
			Vec2 dampingVector = n.mult(-2 * v.dot(n) * (1 - damping));
			r.add(dampingVector);

			// Update the ball's position to just touch the line
			x = (float)closestX - (float)distanceX / (float)distance * radius;
			y = (float)closestY - (float)distanceY / (float)distance * radius;
			
			// Update the ball's velocity to the reflecting velocity
			speedX = r.x;
			speedY = r.y;

			return true;
		}

		return false; 
	}



	// Check the collision between the ball and flippers
	void checkCollisionWithFlipperL(FlipperL flipper){
		float restitution = 0.7;

		Vec2 flipper_base = new Vec2(flipper.x1, flipper.y1);
		
		// Find the closest point on the line segment
  	flipper.x2 = flipper_base.x + flipper.line_length*cos(flipper.angle);
  	flipper.y2 = flipper_base.y + flipper.line_length*sin(flipper.angle);
		Vec2 tip = new Vec2(flipper.x2, flipper.y2); 

		Vec2 ball_pos = new Vec2(x, y);
		Vec2 ball_vel = new Vec2(speedX, speedY);

		// Calculate the vector components of the line segment
		float dx = flipper.x2 - flipper.x1;
		float dy = flipper.y2 - flipper.y1;

		// Calculate the length of the line segment
		double d = sqrt(dx * dx + dy * dy);

		// Calculate the parameter 'u' that determines the closest point on the line to the ball
		float u = ((x - flipper.x1) * dx + (y - flipper.y1) * dy) / ((float)d * (float)d);
		
		// Clamp 'u' to the range [0, 1] to ensure it's within the line segment
  	u = constrain(u, 0, 1);

		// Calculate the coordinates of the closest point on the line
		float closestX = flipper.x1 + u * dx;
		float closestY = flipper.y1 + u * dy;
		Vec2 closest = new Vec2(closestX, closestY);		
		
		// Calculate the distance between the ball's center and the closest point on the line
		float distanceX = closestX - x;
		float distanceY = closestY - y;
		double distance = sqrt(distanceX * distanceX + distanceY * distanceY);

		// Check if a collision occurs by comparing the distance to the ball's radius
		if (distance <= radius) {
			// Calculate the reflecting velocity of the ball
			Vec2 v = new Vec2(speedX, speedY); // Ball's velocity vector
			Vec2 n = new Vec2((float)distanceX, (float)distanceY).normalize(); // Normal vector at collision point
			
			// Update the ball's position to just touch the line
			x = (float)closestX - (float)distanceX / (float)distance * radius;
			y = (float)closestY - (float)distanceY / (float)distance * radius;

			// Velocity of the flipper at the point of contact
			Vec2 flipper_radius = closest.sub(flipper_base);
			Vec2 surfaceVel = new Vec2(0,0);
			if (flipper_radius.magnitude() > 0) {
				surfaceVel = (new Vec2(-flipper_radius.y, flipper_radius.x)).normalize().mult(flipper.angular_velocity * flipper_radius.magnitude());
			}

			// Calculate the new ball velocity
			float v_ball = ball_vel.dot(n);
			float v_flip = surfaceVel.dot(n);
			float m1 = 1;
			float m2 = 10; // Give the flipper a big mass compared to the ball 

			// Conservation of momentum
			float new_v = (m1 * v_ball + m2 * v_flip - m2 * (v_ball - v_flip) * restitution) / (m1 + m2);

			// Update the ball's velocity to the reflecting velocity
			ball_vel.add(n.mult(new_v - v_ball)); 
			speedX = -ball_vel.x;
			speedY = -ball_vel.y;
		}   

	}

		// Check the collision between the ball and flippers
	void checkCollisionWithFlipperR(FlipperR flipper){
		float restitution = 0.7;

		Vec2 flipper_base = new Vec2(flipper.x1, flipper.y1);
		
		// Find the closest point on the line segment
  	flipper.x2 = flipper_base.x + flipper.line_length*cos(flipper.angle);
  	flipper.y2 = flipper_base.y + flipper.line_length*sin(flipper.angle);
		Vec2 tip = new Vec2(flipper.x2, flipper.y2); 

		Vec2 ball_pos = new Vec2(x, y);
		Vec2 ball_vel = new Vec2(speedX, speedY);

		// Calculate the vector components of the line segment
		float dx = flipper.x2 - flipper.x1;
		float dy = flipper.y2 - flipper.y1;

		// Calculate the length of the line segment
		double d = sqrt(dx * dx + dy * dy);

		// Calculate the parameter 'u' that determines the closest point on the line to the ball
		float u = ((x - flipper.x1) * dx + (y - flipper.y1) * dy) / ((float)d * (float)d);
		
		// Clamp 'u' to the range [0, 1] to ensure it's within the line segment
  	u = constrain(u, 0, 1);

		// Calculate the coordinates of the closest point on the line
		float closestX = flipper.x1 + u * dx;
		float closestY = flipper.y1 + u * dy;
		Vec2 closest = new Vec2(closestX, closestY);		
		
		// Calculate the distance between the ball's center and the closest point on the line
		float distanceX = closestX - x;
		float distanceY = closestY - y;
		double distance = sqrt(distanceX * distanceX + distanceY * distanceY);

		// Check if a collision occurs by comparing the distance to the ball's radius
		if (distance <= radius) {
			// Calculate the reflecting velocity of the ball
			Vec2 v = new Vec2(speedX, speedY); // Ball's velocity vector
			Vec2 n = new Vec2((float)distanceX, (float)distanceY).normalize(); // Normal vector at collision point
			
			// Update the ball's position to just touch the line
			x = (float)closestX - (float)distanceX / (float)distance * radius;
			y = (float)closestY - (float)distanceY / (float)distance * radius;

			// Velocity of the flipper at the point of contact
			Vec2 flipper_radius = closest.sub(flipper_base);
			Vec2 surfaceVel = new Vec2(0,0);
			if (flipper_radius.magnitude() > 0) {
				surfaceVel = (new Vec2(-flipper_radius.y, flipper_radius.x)).normalize().mult(flipper.angular_velocity * flipper_radius.magnitude());
			}

			// Calculate the new ball velocity
			float v_ball = ball_vel.dot(n);
			float v_flip = surfaceVel.dot(n);
			float m1 = 1;
			float m2 = 10; // Give the flipper a big mass compared to the ball 

			// Conservation of momentum
			float new_v = (m1 * v_ball + m2 * v_flip - m2 * (v_ball - v_flip) * restitution) / (m1 + m2);

			// Update the ball's velocity to the reflecting velocity
			ball_vel.add(n.mult(new_v - v_ball)); 
			speedX = -ball_vel.x;
			speedY = -ball_vel.y;
		}   
		                                                                                                                                        
	}


	void display() {
		fill(25, 175, 155);
		noStroke();
		circle(x, y, radius*2);
	}

	void displayBigBall() {
		fill(120, 175, 70);
		noStroke();
		circle(x, y, radius*2);
	}

}
