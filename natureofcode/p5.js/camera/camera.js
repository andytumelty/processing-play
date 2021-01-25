// FIXME this is a layover from the processing to p5.js migration: do we really
// need these to be global vars?

// TODO better keys, see keyPressed in gaussian_paint_dots_3d
// TODO capturing key presses here without needing to override keyPressed?

// how far away from the origin the camera is
var cam_radius;
// the angle in radians around the y-axis
var cam_s;
// the angle in radians down from y-axis
var cam_t;

var cam_x;
var cam_y;
var cam_z;

// how much a drag across the screen will rotate the camera
// dragging for a full width/height changes the rotation by 180deg
var drag_ratio;

// the "bounding" (not really, randomGaussian has no theoretical limit) box. More
// useful as a point of reference for rotating the camera.
var cam_box_size;

function drawCamera() {
  // by default, don't draw a bounding box or origin
  drawCamera(false, false);
}
function drawCamera(draw_bounding_box) {
  // by default, don't draw an origin
  drawCamera(draw_bounding_box, false);
}
function drawCamera(draw_bounding_box, draw_origin) {
  // TODO there's a better way of handling this. New camera object that stores
  // instance vars with a .draw() method?

  // check if vars have already been set, else default them.
  if (! cam_radius){
    // this is the default processing camera radius...
    cam_radius = (height/2.0) / Math.tan(PI*30.0 / 180.0);
    // ... but it's a bit close, so make it a bit bigger
    cam_radius *= 1.2;
  }

  // this is equivalent to the default camera location: front on
  if (! cam_s) {
    cam_s = 3*PI/2;
  }
  if (! cam_t) {
    cam_t = 3*PI/2;
  }
  if (! cam_box_size) {
    cam_box_size = width * 0.5;
  }

  // TODO expose this as sensitivity?
  drag_ratio = PI;
  // if the mouse is pressed (at this time) treat it as a drag and
  // move the camera based on the difference in mouse position to
  // the previous frame.
  if (mouseIsPressed) {
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
  cam_x = (cam_radius * Math.cos(cam_s) * Math.sin(cam_t));
  cam_y = - cam_radius * Math.cos(cam_t);
  cam_z = (cam_radius * Math.sin(cam_s) * Math.sin(cam_t));

  // println(cam_s*180/PI, cam_t*180/PI, cam_x, cam_y, cam_z);

  // if we rotate vertically past 180deg flip the camera so y is
  // in the direction we'd expect
  var upY = Math.pow(-1, 1 + abs(int(cam_t / PI)));

  camera(
    cam_x, cam_y, cam_z, // camera position
    0, 0, 0,  // eye centre
    0, upY, 0 // upX, upY, upZ
  );

  if (draw_bounding_box){
    // draw a containing box. Useful for orientating oneself in abstract
    // or blank cavases when rotating.
    stroke(0, 0.3*255);
    noFill();
    push();
    translate(0, 0, 0);
    box(cam_box_size);
    pop();
  }

  if (draw_origin){
    // draw an origin spot
    stroke(0, 100);
    strokeWeight(5);
    point(0, 0, 0);
    strokeWeight(1);
  }
}

function touchMoved() {
  // prevent default
  return false;
}