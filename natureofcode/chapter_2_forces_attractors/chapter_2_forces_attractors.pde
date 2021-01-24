Mover movers[] = new Mover[10];
Attractor attractors[] = new Attractor[3];

boolean play = true;
float c = 0.01;

Attractor dragging;

void setup() {
  size(800, 800);
  float bounce = 0.9;
  
  for (int i = 0; i < movers.length; i++) {
    float size = random(10, 30);
    movers[i] = new Mover(
      random(50, width-50),
      random(50, height-50),
      size,
      bounce
    );
    // setup movers with a random acceleration
    movers[i].applyForce(new PVector(random(2)-1,random(2)-1));
    movers[i].update();
  }
  
  for (int i = 0; i < attractors.length; i++) {
    float size = random(10, 50);
    attractors[i] = new Attractor(
      random(100, width-100),
      random(100, height-100),
      size
    );
  }
}

void draw() {
  if (play){
    background(255);
    if (mousePressed && dragging != null){
      // use diff between mouseX and pmouseX to moce the
      // object as the mouse probably isn't dragging from
      // the centre, so e.g. dragging.location.x != mouseX 
      dragging.location.x += mouseX - pmouseX;
      dragging.location.y += mouseY - pmouseY;
    }

    for (int i = 0; i < attractors.length; i++) {
      Attractor attractor = attractors[i];
      attractor.display();
      
      for (int j = 0; j < movers.length; j++) {
        Mover mover = movers[j];
        PVector f = attractor.attract(mover);
        mover.applyForce(f);
      }
    }

    for (int i = 0; i < movers.length; i++) {
      Mover mover = movers[i];
      mover.update();
      mover.display();
    }
  }
  // println(frameRate);
}

void keyPressed(){
 if (key == ' '){
   play = !play;
 }
}

void mousePressed(){
  for (int i = 0; i < attractors.length; i++) {
    Attractor a = attractors[i];
    if(a.isInside(mouseX, mouseY)){
      dragging = a;
      // if we've found an attractor we're dragging
      // we don't need to check any more
      return;
    }
  }
}

void mouseReleased(){
  dragging = null;
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float max_velocity;

  color colour_fill;
  color colour_stroke;
  float size;
  
  float bounce;
  float mass;
   
  Mover(float x_, float y_, float size_, float bounce_) {
    size = size_;
    mass = size_/16;

    colour_fill = color(227, 188, 245);
    colour_stroke = color(188, 153, 204);

    // how much this object bounces off something, a number
    // between 0 and 1. 0 is a sponge, and 1 is the bounciest
    // of balls.
    bounce = bounce_;
    max_velocity = 10;

    location = new PVector(x_, y_);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(max_velocity);
    // println(acceleration, velocity);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    stroke(colour_stroke);
    strokeWeight(2);
    fill(colour_fill, 80);
    ellipse(location.x, location.y, size, size);
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  //void checkEdges() {
  //  // if an object hits an immovable wall, it will bounce off.
  //  // The minimum force to acheive that is f = ma = m * -1 * v
  //  // which will cause the obejct to stop (e.g. if the object is
  //  // a sponge which obsorbs the reaction.)

  //  if (location.x > width - size/2){
  //    applyForce(new PVector((-1 - bounce) * velocity.x * mass, 0));
  //    location.x = width - size/2;
  //  } else if (location.x < size/2){
  //    applyForce(new PVector((-1 - bounce) * velocity.x * mass, 0));
  //    location.x = size/2;
  //  }

  //  if (location.y > height - size/2){
  //    applyForce(new PVector(0, (-1 - bounce) * velocity.y * mass));
  //    location.y = height - size/2;
  //  }
  //  //if (location.y < size/2){
  //  //  applyForce(new PVector(0, (-1 - bounce) * velocity.y * mass));
  //  //  //FIXME this is needed if the object goes beyond the boundary
  //  //  //with a small velocity, that velocity won't be enough to bounce
  //  //  //it back into bounds, so this will start to constantly flip that
  //  //  //small velocity. Could fix this by checking the force we're
  //  //  //adding is in the right "direction"?
  //  //  location.y = size/2;
  //  //}
  //}
  
  boolean isInside(float x, float y){
    // return whether the given co-ordinates are within the mover's area
    PVector offset = PVector.sub(
      location,
      new PVector(x, y)
    );
   return offset.mag() <= size;
  }
}

class Attractor {
  float size;
  float mass;
  PVector location;
  
  float G;
  
  color colour_fill;
  color colour_stroke;
  
  Attractor(float x_, float y_, float size_) {
    colour_fill = color(255, 232, 199);
    colour_stroke = color(224, 152, 47);

    location = new PVector(x_, y_);
    size = size_;
    // attractors are denser than movers
    mass = size/2;
    
    // fairly arbitrary gravitational constant
    G = 1;
  }
  
  void display() {
    stroke(colour_stroke);
    strokeWeight(2);
    fill(colour_fill, 80);
    ellipse(location.x, location.y, size, size);
  }

  PVector attract(Mover mover) {
    // F = ((G * m1 * m2)/(r^2))*r_unit
    PVector f = PVector.sub(location, mover.location);
    // limit distance to prevent super huge or super small forces
    float r = constrain(f.mag(), 5, 100);
    f.normalize();
    f.mult((G * mass * mover.mass)/(r * r));
    return f;
  }

  boolean isInside(float x, float y){
    // return whether the given co-ordinates are within the objects's area
    PVector offset = PVector.sub(
      location,
      new PVector(x, y)
    );
   return offset.mag() <= size;
  }
}
