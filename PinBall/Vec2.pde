public class Vec2 {
	float x, y;
	
	public Vec2(float x, float y) {
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

	float magnitude() {
		return sqrt(x * x + y * y);
	}
	
	Vec2 normalize() {
		float m = magnitude();
		return new Vec2 (x/m, y/m);
	}
	
	float dot(Vec2 v) {
		return x * v.x + y * v.y;
	}
	
}


