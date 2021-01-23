Mover movers[] = new Mover[10];
PVector gravity;
float t = random(100);
boolean play = true;

void setup() {
  size(640, 360);
  float bounce = 0.8;
  
  for (int i = 0; i < movers.length; i++) {
    float size = random(5, 100);
    movers[i] = new Mover(50, 50, size, bounce);
  }
  // negative y is "up"
  gravity = new PVector(0, 1);
}

void draw() {
  if (play){
    background(255);

    PVector wind = new PVector((noise(t)-0.2)*random(0.6,1), 0);
    t++;
  
    for (int i = 0; i < movers.length; i++) {
      Mover mover = movers[i];
      mover.applyForce(gravity);
      mover.applyForce(wind);
      mover.checkEdges();
      mover.update();
      mover.display();
    }
  }
  println(frameRate);
}

void keyPressed(){
 if (key == ' '){
   play = !play;
 }
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
    mass = size_;

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
  
  void checkEdges() {
    // if an object hits an immovable wall, it will bounce off.
    // The minimum force to acheive that is f = ma = m * -1 * v
    // which will cause the obejct to stop (e.g. if the object is
    // a sponge which obsorbs the reaction.)

    if (location.x > width - size/2){
      applyForce(new PVector((-1 - bounce) * velocity.x * mass, 0));
      location.x = width - size/2;
    } else if (location.x < size/2){
      applyForce(new PVector((-1 - bounce) * velocity.x * mass, 0));
      location.x = size/2;
    }

    if (location.y > height - size/2){
      applyForce(new PVector(0, (-1 - bounce) * velocity.y * mass));
      location.y = height - size/2;
    }
    //if (location.y < size/2){
    //  applyForce(new PVector(0, (-1 - bounce) * velocity.y * mass));
    //  //FIXME this is needed if the object goes beyond the boundary
    //  //with a small velocity, that velocity won't be enough to bounce
    //  //it back into bounds, so this will start to constantly flip that
    //  //small velocity. Could fix this by checking the force we're
    //  //adding is in the right "direction"?
    //  location.y = size/2;
    //}
  }
}
