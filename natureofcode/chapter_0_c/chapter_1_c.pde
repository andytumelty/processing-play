float t = 0;

void setup() {
  size(640, 360);
}
 
void draw() {
  float n = noise(t) * width;
  t += 0.01;
  ellipse(n,180,16,16);
}
