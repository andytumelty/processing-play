int r;
int g;
int b;
int x;
int y;
int w;
int h;
int pos_sd;
int rgb_sd;

void setup() {
  size(500,500);
  w = 10;
  h = 10;
  pos_sd = width/8;
  rgb_sd = 20;
  background(255);
}

void draw() {

  r = int(random(255));
  g = int(random(255));
  b = int(random(255));

  /*
  r = int((randomGaussian() * rgb_sd) + 255/2);
  g = int((randomGaussian() * rgb_sd) + 255/2);
  b = int((randomGaussian() * rgb_sd) + 255/2);
  */

  x = int((randomGaussian() * pos_sd) + width/2);
  y = int((randomGaussian() * pos_sd) + height/2);
  noStroke();
  fill(r, g, b, 50);
  ellipse(x, y, w, h);
}
