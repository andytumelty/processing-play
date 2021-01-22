float n;
float m;
float y_modifier;
float t;
float u;


void setup() {
  size(800, 600);
  n = 0.01;
  //m = 0.0005;
  y_modifier = 1;
  //noiseDetail(4, 0.6);
  t = 0;
  u = 0.003;
}

void draw() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      // float bright = random(255);
      float bright = map(noise(x*n,y*n*y_modifier,t),0,1,0,255);
      pixels[x+y*width] = color(bright);
    }
  }
  updatePixels();
  n += m;
  t += u;
}
