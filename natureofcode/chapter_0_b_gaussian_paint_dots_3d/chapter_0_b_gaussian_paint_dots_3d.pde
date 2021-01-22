Ball[] balls;

// how far away from the origin the camera is
float cam_radius;
// the angle in radians around the z-axis
float cam_s;
// the angle in radians down from z-axis
float cam_t;
// how much a drag across the screen will rotate the camera
float drag_ratio;

float cam_x;
float cam_y;
float cam_z;

int radius;

int pos_sd;
int rgb_sd;

int n_balls;

int box_size;

boolean grow;

void setup() {
  size(500, 500, P3D);
  frameRate(30);

  // the ball size
  radius = 6;
  // whether to show more balls on the next frame. Can be toggled with spacebar.
  grow = true;
  
  // the "bounding" (not really, randomGaussian has no theoretical limit) box. More
  // useful as a point of reference for rotating the camera.
  box_size = 300;
  // this is the default camera z location
  cam_radius = (height/2.0) / tan(PI*30.0 / 180.0);
  // the default camera location, equivalent to x = 0 + width/2, y = 0 + width/2
  cam_s = 3*PI/2;
  cam_t = 3*PI/2;

  // dragging for a full width/height changes the rotation by 180deg
  drag_ratio = PI;

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
  
  // the number of balls to show. Increments once per iteration, if draw == true
  n_balls = 1;
}

void draw() {
  background(255);
  //lights();

   /*
  // draw an origin spot
  stroke(0, 100);
  strokeWeight(5);
  point(width/2, height/2, 0);
  strokeWeight(1);
  */
  
  // if the mouse is pressed (at this time) treat it as a drag and
  // move the camera based on the difference in mouse position to
  // the previous frame.
  if (mousePressed) {
    /*
    aaaaah maths
    The theory here is the camera is a point on a sphere. We can
    drag that sphere left and right, and up and down. We can also
    make it bigger (zoom out) and smaller (zoom in) (TODO.)
    Here we work out the x,y,z coordinates of the camera based on
    the angle around the (vertical) y-axis, cam_s and the angle down
    from the y-axis, cam_t. Dragging in the x axis changes cam_s,
    dragging in the y-axis changes cam_t.
    */

    cam_s = cam_s - (drag_ratio * (float(pmouseX - mouseX) / width));
    cam_t = cam_t - (drag_ratio * (float(pmouseY - mouseY) / width));
  }

  // always position the camera: the mouseWheel event may have tripped
  // TODO can we use a flag for this instead to save needing to always
  // run this?
  cam_x = (cam_radius * cos(cam_s) * sin(cam_t)) + (width/2);
  cam_y = - cam_radius * cos(cam_t) + (height/2);
  cam_z = (cam_radius * sin(cam_s) * sin(cam_t));
  
  // println(cam_s*180/PI, cam_t*180/PI, cam_x, cam_y, cam_z);

  // if we rotate vertically past 180deg flip the camera so y is
  // in the direction we'd expect
  float upY = pow(-1, 1 + abs(int(cam_t / PI)));

  camera(
    cam_x, cam_y, cam_z, // camera position
    width/2.0, height/2.0, 0,  // eye centre
    0, upY, 0 // upX, upY, upZ
  );

  // draw a containing box
  stroke(0, 10);
  noFill();
  pushMatrix();
  translate(width/2, height/2, 0);
  box(box_size);
  popMatrix();

  for (int n = 0; n < n_balls; n++) {
    balls[n].display();
  }

  if (grow && n_balls < balls.length){
    // show 1 more ball next frame
    n_balls++;
    println("n_balls", n_balls);
  }
}

void keyPressed() {
  // pause/play the animation with spacebar
  if (key == ' '){
    grow = ! grow;
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
