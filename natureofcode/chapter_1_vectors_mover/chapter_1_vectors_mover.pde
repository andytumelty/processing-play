Mover mover;

void setup() {
  size(640, 360);
  mover = new Mover();
}

void draw() {
  background(255);

  mover.update();
  mover.checkEdges();
  mover.display();
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float max_velocity;
  
  // perlin
  PVector t;
   
  Mover() {
    /*
    // constant random velocity
    location = new PVector(random(width), random(height));
    velocity = new PVector(random(-2,2), random(-2,2));
    */
    
    max_velocity = 10;

    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);

    /*
    // constant acceleration
    acceleration = new PVector(
      random(-0.01, 0.01),
      random(-0.01, 0.01)
    );
    */
    
    // perlin -- different starting values for x and y
    // t = new PVector(0, 1000);
  }
  
  void update() {
    /*
    // random acceleration
    acceleration = PVector.random2D();

    // perlin acceleration
    // FIXME not sure if this is right?
    acceleration = new PVector(
      noise(t.x)-0.5,
      noise(t.y)-0.5
    );
    t.x++;
    t.y++;
    */
    
    // accelerate towards mouse
    PVector mouse = new PVector(mouseX, mouseY);
    PVector dir = PVector.sub(mouse, location);
    float mag = dir.mag();
    dir.normalize();
    dir.div(mag);
    acceleration = dir;
    
    velocity.add(acceleration);
    velocity.limit(max_velocity);
    location.add(velocity);
  }
  
  void display() {
    stroke(0);
    fill(175);
    ellipse(location.x, location.y, 16, 16);
  }
  
  void checkEdges() {
    if (location.x > width){
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height){
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
    }
  }
}
