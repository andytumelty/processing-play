int radius;

// TODO change to use vectors
float x;
float y;
float z;
PVector l;

float v_x;
float v_y;
float v_z;
PVector v;

int max_z;
PVector bounds;

color c;

void setup() {
  size(800, 600, P3D);
  frameRate(30);

  // the box is 800x600x600
  max_z = 600;
  radius = 20;

  x = width/2;
  y = height/2;
  z = 0;

  v_x = 3;
  v_y = 2;
  v_z = 1;

  c = color(random(255), random(255), random(255));
}

void draw() {
  // TODO smaller bounds so you can see it
  // TODO rotate the view so it's on a slight angle
  // TODO draw box around the bounds
  if ((x > width) || (x < 0)) {
    v_x = v_x * -1;
  }
  if ((y > height) || (y < 0)) {
    v_y = v_y * -1;
  }
  if ((z > max_z/2) || (z < -max_z/2)) {
    v_z = v_z * -1;
  }

  background(200);
  lights();

  noStroke();
  fill(c);

  pushMatrix();
  translate(x, y, z);
  sphere(radius);
  popMatrix();
  
  x += v_x;
  y += v_y;
  z += v_z;
}
