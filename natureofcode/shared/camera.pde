// how far away from the origin the camera is
float cam_radius;
// the angle in radians around the y-axis
float cam_s;
// the angle in radians down from y-axis
float cam_t;

float cam_x;
float cam_y;
float cam_z;

// how much a drag across the screen will rotate the camera
// dragging for a full width/height changes the rotation by 180deg
float drag_ratio = PI;

// the "bounding" (not really, randomGaussian has no theoretical limit) box. More
// useful as a point of reference for rotating the camera.
float cam_box_size;

// overload for default args
void setupCamera(){
  // by default, show the camera at the processing default location
  setupCamera(false);
}
void setupCamera(boolean offset){
  // this is the default processing camera radius
  cam_radius = (height/2.0) / tan(PI*30.0 / 180.0);
  if (offset){    
    // a slightly nicer starting offset
    // cam_radius = width*0.97;
    cam_s = 4.3;
    cam_t = 5;
  } else {
    // this is equivalent to the default camera location
    cam_s = 3*PI/2;
    cam_t = 3*PI/2;
  }
  cam_box_size = width * 0.6;
}

void drawCamera() {
  // by default, don't draw a bounding box or origin
  drawCamera(false, false);
}
void drawCamera(boolean draw_bounding_box) {
  // by default, don't draw an origin
  drawCamera(draw_bounding_box, false);
}
void drawCamera(boolean draw_bounding_box, boolean draw_origin) {
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
  
  if (draw_bounding_box){ 
    // draw a containing box. Useful for orientating oneself in abstract
    // or blank cavases when rotating. 
    stroke(0, 10);
    noFill();
    pushMatrix();
    translate(width/2, height/2, 0);
    box(cam_box_size);
    popMatrix();
  }
  
  if (draw_origin){
    // draw an origin spot
    stroke(0, 100);
    strokeWeight(5);
    point(width/2, height/2, 0);
    strokeWeight(1);
  }
}
