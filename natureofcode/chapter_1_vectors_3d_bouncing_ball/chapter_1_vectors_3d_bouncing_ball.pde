int ball_radius;
color ball_colour;

PVector ball_location;
PVector ball_velocity;

PVector box_size;
PVector max_bounds;
PVector min_bounds;

void setup() {
  size(800, 600, P3D);
  frameRate(30);

  setupCamera(true);

  ball_radius = 20;
  ball_colour = color(random(255), random(255), random(255));

  // start the ball in the middle of the canvas
  ball_location = new PVector (width/2, height/2, 0);
  ball_velocity = new PVector(
    random(0.5, 4),
    random(0.5, 4),
    random(0.5, 4)
  );

  // where the "walls" are
  box_size = new PVector(400, 300, 300);

  // pre-calculate where the max-min co-ordinates are for ball
  min_bounds = new PVector(
    width/2 - box_size.x/2 + ball_radius,
    height/2 - box_size.y/2 + ball_radius,
    0 - box_size.z/2 + ball_radius
  );
  max_bounds = new PVector(
    width/2 + box_size.x/2 - ball_radius,
    height/2 + box_size.y/2 - ball_radius,
    0 + box_size.z/2 - ball_radius
  );

}

void draw() {
  background(240);
  lights();
  
  drawCamera();
  
  // draw the bounding box
  noFill();
  stroke(0, 10);
  pushMatrix();
  translate(width/2, height/2, 0);
  box(box_size.x, box_size.y, box_size.z);
  popMatrix();

  noStroke();
  fill(ball_colour);
  pushMatrix();
  translate(ball_location.x, ball_location.y, ball_location.z);
  sphere(ball_radius);
  popMatrix();
  
  if ((ball_location.x > max_bounds.x) || (ball_location.x < min_bounds.x)) {
    ball_velocity.x *= -1;
  }
  if ((ball_location.y > max_bounds.y) || (ball_location.y < min_bounds.y)) {
    ball_velocity.y *= -1;
  }
  if ((ball_location.z > max_bounds.z) || (ball_location.z < min_bounds.z)) {
    ball_velocity.z *= -1;
  }

  ball_location.add(ball_velocity);
  
  println(frameRate);
}
