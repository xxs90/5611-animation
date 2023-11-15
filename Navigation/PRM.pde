//Probablistic Roadmap Class
class PRM {
  int num;
  PVector[] mspos;
  boolean[][] adjacent;
  float[][] distance;
  float[] heuristic;

  PRM(int n) {
    num = n;
    initializeArrays();
    generateRandomPositions();
    addStartAndDestination();
    computeAdjacencyAndDistance();
    adjustAdjacentNodes();
  }

  // Initialize arrays
  void initializeArrays() {
    mspos = new PVector[num + 2];
    adjacent = new boolean[num + 2][num + 2];
    distance = new float[num + 2][num + 2];
    heuristic = new float[num + 2];
  }

  // Generate random positions within the scene
  void generateRandomPositions() {
    float r = obstacleRadius + agentRadius;
    for (int i = 1; i < num + 1; i++) {
      PVector randomPos = new PVector(sceneSize * random(-0.5, 0.5), sceneSize * random(-0.5, 0.5));
      randomPos = ensureRobustness(randomPos);
      mspos[i] = avoidSphericalObstacles(randomPos, r);
    }
  }

  // Ensure robustness of generated positions
  PVector ensureRobustness(PVector pos) {
    float boundary = 0.5 * sceneSize - agentRadius;
    pos.x = constrain(pos.x, -boundary, boundary);
    pos.y = constrain(pos.y, -boundary, boundary);
    return pos;
  }

  // Avoid spherical obstacles when generating positions
  PVector avoidSphericalObstacles(PVector position, float r) {
    for (PVector obstacle : obstacles) {
      PVector dir = PVector.sub(position, obstacle);
      if (dir.mag() < r) {
        dir.normalize();
        position = PVector.add(obstacle, PVector.mult(dir, 1.2 * r));
      }
    }
    return position;
  }

  // Add start and destination to the graph
  void addStartAndDestination() {
    mspos[0] = new PVector(agentPos.x, agentPos.y);
    mspos[num + 1] = new PVector(goalPos.x, goalPos.y);
  }

  // Compute adjacency list and edge distance
  void computeAdjacencyAndDistance() {
    float r = obstacleRadius + agentRadius;
    for (int i = 1; i < num + 1; i++) {
      for (int j = 1; j < num + 1; j++) {
        computeAdjacencyAndDistanceBetweenNodes(i, j, r);
      }
      computeStartAndGoalAdjacencyAndDistance(i, r);
    }
    adjustAdjacentNodes();
  }

  // Compute adjacency and distance between nodes
  void computeAdjacencyAndDistanceBetweenNodes(int i, int j, float r) {
    float dis = PVector.sub(mspos[i], mspos[j]).mag();
    adjacent[i][j] = (j != i) && (adjacent[j][i] || (dis < neighborRadius * sceneSize && accessible(mspos[i], mspos[j], r)));
    distance[i][j] = (adjacent[i][j]) ? dis : 0;
  }

  // Compute adjacency and distance for start and goal nodes
  void computeStartAndGoalAdjacencyAndDistance(int i, float r) {
    float dis;
    heuristic[i] = PVector.sub(goalPos, mspos[i]).mag();
    if (accessible(mspos[i], agentPos, r)) {
      dis = PVector.sub(mspos[i], agentPos).mag();
      adjacent[i][0] = true;
      adjacent[0][i] = true;
      distance[i][0] = distance[0][i] = dis;
    }
    if (accessible(mspos[i], goalPos, r)) {
      dis = heuristic[i];
      adjacent[i][num + 1] = true;
      adjacent[num + 1][i] = true;
      distance[i][num + 1] = distance[num + 1][i] = dis;
    }
  }

  // Adjust adjacency for start and goal nodes
  void adjustAdjacentNodes() {
    adjacent[0][0] = adjacent[num + 1][num + 1] = false;
    adjacent[0][num + 1] = adjacent[num + 1][0] = accessible(agentPos, goalPos, obstacleRadius + agentRadius);
  }
}


boolean accessible(PVector pos1, PVector pos2, float r){
	for (PVector pos : obstacles) {
    PVector v1 = PVector.sub(pos, pos1);
    PVector v2 = PVector.sub(pos, pos2);
    PVector v3 = PVector.sub(pos1, pos2);
    float len = v3.mag();
    v3.normalize();
    PVector v4 = v3.copy().mult(-1);
    PVector tmp = v3.copy().cross(v2);
    float len1 = abs(PVector.dot(v1, v4));
    float len2 = abs(PVector.dot(v2, v3));
    if (tmp.mag() < r && (len1 + len2 - len < 0.1)) {
      return false;
    }
  }
  return true;
}


// Simple Queue implementation
class SimpleQueue {
	private ArrayList<Integer> queue;

	public SimpleQueue() {
		this.queue = new ArrayList<>();
	}

	public void enqueue(int item) {
		queue.add(item);
	}

	public int dequeue() {
		if (!isEmpty()) {
			return queue.remove(0);
		}
		throw new RuntimeException("Queue is empty");
	}

	public boolean isEmpty() {
		return queue.isEmpty();
	}
}


// Path-searching function using BFS 
ArrayList<Integer> pathSearch() {
  ArrayList<Integer> result = new ArrayList<>();
  int[] pstep = new int[samples + 2];
  SimpleQueue queue = new SimpleQueue();

	// First step
	for (int i = 1; i < samples + 2; i++) {
		if (prm.adjacent[0][i]) {
			queue.enqueue(i);
			pstep[i] = -1;
		}
	}

	while (!queue.isEmpty()) {
		int current = queue.dequeue();
		if (current == samples + 1) break;
		
		for (int i = 1; i < samples + 2; i++) {
			if (prm.adjacent[current][i]) {
				if (pstep[i] == 0) {
					queue.enqueue(i);
					pstep[i] = current;
				}
			}
		}
	}

	int tmp = samples + 1;
	while (tmp != -1) {
		result.add(0, tmp);
		tmp = pstep[tmp];
	}

	result.add(0, 0);
	return result;
}
