class Vec2 {
	float x, y;
	
	Vec2(float x, float y) {
		this.x = x;
		this.y = y;
	}
	
	Vec2 add(Vec2 v) {
		return new Vec2(x + v.x, y + v.y);
	}
	
	Vec2 sub(Vec2 v) {
		return new Vec2(x - v.x, y - v.y);
	}
	
	Vec2 mult(float scalar) {
		return new Vec2(x * scalar, y * scalar);
	}
	
	float mag() {
		return sqrt(x * x + y * y);
	}
	
	Vec2 normalize() {
		float m = mag();
		if (m != 0) {
			return mult(1 / m);
		} else {
			return new Vec2(0, 0);
		}
	}
	
	float dot(Vec2 v) {
		return x * v.x + y * v.y;
	}
	
	Vec2 cross(Vec2 v) {
		return new Vec2(0, 0);
	}
}


