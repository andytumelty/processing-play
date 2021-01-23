Ball[] balls;

// the ball radius
int radius = 12;

int pos_sd;
int rgb_sd;

// the number of balls to show. Increments once per iteration,
// if grow == true
int n_balls = 1;
// whether to show more balls on the next frame. Can be toggled with spacebar.
boolean grow = true;

boolean record = false;
boolean spin = false;
float zoom = 1;

void setup() {
  size(1000, 1000, P3D);
  frameRate(30);
  setupCamera(true);

  // standard deviations for position and colour
  pos_sd = width/10;
  rgb_sd = 20;

  // Pre-generate 1000 balls
  // We need to persist the ball locations and color so we can redraw their
  // positions on every frame, potentially from different camera angles.
  balls = new Ball[1000];
  for (int n = 0; n < balls.length; n++) {
    int r = int(random(255));
    int g = int(random(255));
    int b = int(random(255));
  
    int x = int((randomGaussian() * pos_sd) + width/2);
    int y = int((randomGaussian() * pos_sd) + height/2);
    int z = int(randomGaussian() * pos_sd);
    balls[n] = new Ball(radius, x, y, z, r, g, b, 50);
  }
}

void draw() {
  background(255);
  //lights();
  drawCamera(true);

  for (int n = 0; n < n_balls; n++) {
    balls[n].display();
  }

  if (grow && n_balls < balls.length){
    // show 1 more ball next frame
    n_balls++;
    println("n_balls", n_balls);
  }
  
  if (record) {
     saveFrame("output/frame_####.png"); 
  }
  
  if (spin) {
    cam_s -= 0.005;
  }

  cam_radius *= zoom;
  
  println("framerate", frameRate);
}

void keyPressed() {
  // pause/play the animation with spacebar
  if (key == ' '){
    grow = !grow;
  } else if (key == 's' || key == 'S') {
    spin = !spin;
  } else if (key == 'r' || key == 'R') {
    record = !record;
  } else if (key == 'i' || key == 'I') {
    zoom += 0.001;
  } else if (key == 'o' || key == 'O') {
    zoom = 1;
  } else if (key == 'p' || key == 'P') {
    zoom -= 0.001;
  }
}

void mouseWheel(MouseEvent event) {
  cam_radius += event.getCount();
  // println(cam_radius);
}

class Ball {
  int radius;
  int x;
  int y;
  int z;
  // TODO can this use a color class?
  int r;
  int g;
  int b;
  int a;
  
  Ball(int radius_, int x_, int y_, int z_, int r_, int g_, int b_, int a_){
    radius = radius_;
    x = x_;
    y = y_;
    z = z_;
    r = r_;
    g = g_;
    b = b_;
    a = a_;
  }
  
  void display() {
    noStroke();
    fill(r, g, b, a);
  
    pushMatrix();
    translate(x, y, z);
    sphere(radius);
    popMatrix();
  }
}
