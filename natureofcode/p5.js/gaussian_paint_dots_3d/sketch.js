p5.disableFriendlyErrors = true; // disables FES

var balls = [];

// the ball radius
var radius = 12;

var pos_sd;
var rgb_sd;

// the number of balls to show. Increments once per iteration,
// if grow == true
var n_balls = 1;
// whether to show more balls on the next frame. Can be toggled with spacebar.
var grow = true;

// var record = false;
var spin = true;
var zoom = 1;

function setup() {
  var canvas = createCanvas(800, 600, WEBGL);
  canvas.parent('sketch');

  // standard deviations for position and colour
  pos_sd = width/10;
  rgb_sd = 20;

  // Pre-generate 100 balls
  // We need to persist the ball locations and color so we can redraw their
  // positions on every frame, potentially from different camera angles.
  for (var n = 0; n < 500; n++) {
    var r = int(Math.random() * 255);
    var g = int(Math.random() * 255);
    var b = int(Math.random() * 255);

    var x = int((randomGaussian() * pos_sd));
    var y = int((randomGaussian() * pos_sd));
    var z = int(randomGaussian() * pos_sd);
    balls[n] = new Ball(radius, x, y, z, r, g, b, 0.6*255);
  }
}

function draw() {
  background(255);
  // lights();
  drawCamera(true);
  // orbitControl(4, 4, 0.1);

  for (var n = 0; n < n_balls; n++) {
    balls[n].display();
  }

  if (grow && n_balls < balls.length){
    // show 1 more ball next frame
    n_balls++;
    document.getElementById('n_balls').innerText = n_balls;
  }

  // JS migration note: TODO
  // if (record) {
  //    saveFrame("output/frame_####.png");
  // }

  // JS migration note: camera control replaced with orbitControl()
  // if (spin) {
  //   cam_s -= 0.005;
  // }
  // cam_radius *= zoom;

  if (frameCount % 30 == 0){
    document.getElementById('framerate').innerText = frameRate();
  }
}

function keyPressed() {
  // pause/play the animation with spacebar
  if (key == ' '){
    grow = !grow;
  // JS migration note: camera control replaced with orbitControl();
  // } else if (key == 's' || key == 'S') {
  //   spin = !spin;
  // } else if (key == 'r' || key == 'R') {
  //   record = !record;
  // } else if (key == 'i' || key == 'I') {
  //   zoom += 0.001;
  // } else if (key == 'o' || key == 'O') {
  //   zoom = 1;
  // } else if (key == 'p' || key == 'P') {
  //   zoom -= 0.001;
  }
}

// function mouseWheel(e) {
//   cam_radius += e.getCount();
//   // println(cam_radius);
// }

class Ball {
  constructor(radius_, x_, y_, z_, r_, g_, b_, a_){
    this.radius = radius_;
    this.x = x_;
    this.y = y_;
    this.z = z_;
    this.r = r_;
    this.g = g_;
    this.b = b_;
    this.a = a_;
  }

  display() {
    noStroke();
    fill(this.r, this.g, this.b, this.a);

    push();
    translate(this.x, this.y, this.z);
    sphere(this.radius);
    pop();
  }
}
