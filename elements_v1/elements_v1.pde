//adapted from - Open Processing: https://www.openprocessing.org/sketch/28755#

float _detail = 25;
int _ballRadius = 200;
float rotX = 0;
float rotY = 0;
float rotZ = 0;


void setup() {
  size(800, 800, P3D);
  colorMode(HSB, 100);
  background(0);
  smooth();
}

void draw() {
  background(0);
  translate(width/2, height/2);
  rotateY(rotY % TWO_PI);
  rotY = rotY + 0.01;
  //rotateZ(sin(rotZ));
  //rotZ = rotZ + 0.1;
  rotateX(sin(rotX));
  rotX = rotX + 0.005;
  stroke(255);
  noFill();
  beginShape();
  float x, y, z, h, s, l;
  
  for (float zi = -_detail * PI / 2; zi < _detail * PI; zi++) {
    for (float r = 0; r < TWO_PI; r += TWO_PI / _detail) {
      x = cos(r);
      y = sin(r);
      z = zi / _detail;
      h = map(r, 0, TWO_PI, 0, 100);
      //s = map(r, 0, TWO_PI, 0, 100);
      l = map(r, 0, TWO_PI, 75, 100);
      stroke(h, 70, l);
      float heightMultiplier = sqrt(1 - sq(z-.5));
      curveVertex(x * heightMultiplier * _ballRadius, y * heightMultiplier * _ballRadius, z * _ballRadius - _ballRadius/2);
    }
  }
  endShape();
  //rect(100,100,200,200);
}