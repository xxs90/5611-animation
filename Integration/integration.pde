
ArrayList<Node> nodes = new ArrayList<Node>();
int num_nodes = 20; 
float link_length = 0.2; 

Vec2 gravity = new Vec2(0, 10);
Vec2 initialPos = new Vec2(5, 5);

// Scaling factor for the scene
float scene_scale = width / 10.0f;

// Physics Parameters
int relaxation_steps = 10;
int sub_steps = 10;

String outputFile = "relaxation_" + relaxation_steps + "_sub_" + sub_steps + ".txt";  
PrintWriter writer;
float recordTime = 30;

void setup() {
  size(500, 500);
  surface.setTitle("x-Pendulum");
  scene_scale = width / 10.0f;

  // Create nodes
  for (int i = 0; i < num_nodes; i++) {
    nodes.add(new Node(initialPos.plus(new Vec2(i * link_length, 0))));
  }

  writer = createWriter(outputFile);
}

void update_physics(float dt) {

  // Update positions
  for (int i = 1; i < nodes.size(); i++) {
    Node node = nodes.get(i);
    node.last_pos = node.pos;
    node.vel = node.vel.plus(gravity.times(dt));
    node.pos = node.pos.plus(node.vel.times(dt));
  }

  // Constrain the distance between nodes to the link length
  for (int i = 0; i < relaxation_steps; i++) {
    for (int j = 1; j < nodes.size(); j++) {
      Vec2 delta = nodes.get(j).pos.minus(nodes.get(j - 1).pos);
      float delta_len = delta.length();
      float correction = delta_len - link_length;
      Vec2 delta_normalized = delta.normalized();
      nodes.get(j).pos = nodes.get(j).pos.minus(delta_normalized.times(correction / 2));
      nodes.get(j - 1).pos = nodes.get(j - 1).pos.plus(delta_normalized.times(correction / 2));
    }
  }
  nodes.get(0).pos = initialPos;

  // Update the velocities (PBD)
  for (Node node : nodes) {
    node.vel = node.pos.minus(node.last_pos).times(1 / dt);
  }

}

// computer the energy of the system
void computeEnergy() {

  // Compute the total energy (should be conserved)
  float kinetic_energy = 0;
  float potential_energy = 0; 
  float total_energy = 0;

  for (int i = 0 ; i < nodes.size(); i++) {
    Node node = nodes.get(i);
    // KE = (1/2) * m * v^2
    // println("Velocity: ", node.vel.lengthSqr());
    kinetic_energy += 0.5 * node.vel.lengthSqr();
    
    // PE = m * g * h
    float node_height = (height - node.pos.y * scene_scale) / scene_scale;
    potential_energy += gravity.y * node_height;
  }
  // println("kinetic_energy: ", kinetic_energy);
  // println("potential_energy: ", potential_energy);

  total_energy = kinetic_energy + potential_energy;
  // println("t:", time, " energy:", total_energy);

  writer.println("Time: " + time + " s");
  writer.println("Total energy: " + total_energy + " J");
}

// computer the length error of the system
void computeLengthError() {
  float total_length_error = 0;
  
  for (int i = 1; i < nodes.size(); i++) {
    Vec2 delta = nodes.get(i).pos.minus(nodes.get(i - 1).pos);
    float delta_len = delta.length();
    total_length_error += (delta_len - link_length);
  }
  
  // println("t:", time, " length_error:", total_length_error);
  writer.println("Total length error: " + total_length_error + " m");
}

float time = 0;
void draw() {
  float dt = 1.0 / 20; //Dynamic dt: 1/frameRate;
  
  if (time < recordTime) {
    for (int i = 0; i < sub_steps; i++) {
      time += dt / sub_steps;
      update_physics(dt / sub_steps);
    }
  }
  else {
    writer.flush();
    writer.close();
    exit();
  }

  computeEnergy();
  computeLengthError();

  background(255);
  stroke(0);
  strokeWeight(2);

  // Draw Nodes (green with black outline)
  fill(0, 255, 0);
  stroke(0);
  strokeWeight(0.02 * scene_scale);

  for (Node node : nodes) {
    ellipse(node.pos.x * scene_scale, node.pos.y * scene_scale, 0.1 * scene_scale, 0.1 * scene_scale);
  }

  // Draw Links (black)
  stroke(0);
  strokeWeight(0.02 * scene_scale);
  for (int i = 0; i < nodes.size() - 1; i++) {
    line(nodes.get(i).pos.x * scene_scale, nodes.get(i).pos.y * scene_scale,
         nodes.get(i + 1).pos.x * scene_scale, nodes.get(i + 1).pos.y * scene_scale);
  }

 }




