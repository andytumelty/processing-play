Walker w;

void setup() {
  size(640, 360);
  w = new Walker();
  background(255);
}

void draw() {
  w.step();
  w.display();
}

class Walker {
  int x;
  int y;
  
  Walker() {
    x = width/2;
    y = height/2;
  }
  
  void display() {
    stroke(0);
    point(x,y);
  }
  
  void step() {
    /*
    int choice = int(random(4));
    if (choice == 0){
      x++;
    } else if (choice == 1){
      x--;
    } else if (choice == 2){
      y++;
    } else {
      y--;
    }
    */

    /*
    int stepx = int(random(3))-1;
    int stepy = int(random(3))-1;
    x += stepx;
    y += stepy;
    */

    /*
    // slightly better uniform random
    int stepx = int(round(random(-1,1)));
    int stepy = int(round(random(-1,1)));
    println(stepx);
    x += stepx;
    y += stepy;
    */

    /*
    float r = random(1);
    if (r < 0.4){
      x++;
    } else if (r < 0.6){
      x--;
    } else if (r < 0.8){
      y++;
    } else {
      y--;
    }
  }
  */
  /*
    float r = random(1);
    float mouse_r = 0.1;
    if (r < mouse_r){
      if (mouseX > x){
        x++;
      } else {
        x--;
      }
      if (mouseY > y){
        y++;
      } else {
        y--;
      }
    } else if (r < (mouse_r + (1-mouse_r)/4)){
      x++;
    } else if (r < (mouse_r + 2*(1-mouse_r)/4)){
      x--;
    } else if (r < (mouse_r + 3*(1-mouse_r)/4)){
      y++;
    } else {
      y--;
    }
    */

    /*
    // gaussian walk
    // println(randomGaussian());
    // without the 0.5 this seems to drift off... not sure why?
    x += randomGaussian() + 0.5;
    y += randomGaussian() + 0.5;
    */
    
    /*
    // levy step (sort of)
    float r = random(1);
    int stepx;
    int stepy;
    if (r < 0.01) {
      stepx = int(round(random(-100,100)));
      stepy = int(round(random(-100,100)));
    } else {
      stepx = int(round(random(-1,1)));
      stepy = int(round(random(-1,1)));
    }
    x += stepx;
    y += stepy;
    */
    
    // higher steps are linearly less likely to be taken
    // this drifts to the top left?
    int stepx = int(((1 - montecarlo()) * 10) - 5);
    int stepy = int(((1 - montecarlo()) * 10) - 5);
    x += stepx;
    y += stepy;

  }
}

float montecarlo() {
  while (true) {
    float r1 = random(1);
    float p = r1;
    float r2 = random(1);
    if (r2 < p) {
      return r1;
    }
  }
}
