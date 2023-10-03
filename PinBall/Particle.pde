class Particle {
  float x, y;       // Position of the particle
  float speedX, speedY; // Velocity of the particle
  float lifespan;   // Lifespan of the particle
  color col;        // Color of the particle
  
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    speedX = random(-5, 5);
    speedY = random(-10, -5);
    lifespan = 255; // Start with full opacity
    col = color(random(255), random(255), random(255));
  }
  
  void update() {
    x += speedX;
    y += speedY;
    speedY += 0.2; // Gravity effect
    lifespan -= 2; // Fade out over time
  }
  
  void display() {
    noStroke();
    fill(col, lifespan);
    ellipse(x, y, 10, 10);
  }
  
  boolean isDead() {
    return lifespan < 0;
  }
}