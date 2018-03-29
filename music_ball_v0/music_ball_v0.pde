//adapted from Open Processing: https://www.openprocessing.org/sketch/28755#

float _detail = 25;
int _ballRadius = 200;
float rotX = 0;
float rotY = 0;
float rotZ = 0;

//arrow details
float cpX, cpY;
int _factor = 15;

//playback control
int playButton = -1;


void setup() {
  size(800, 800, P3D);
  colorMode(HSB, 100);
  background(0);
  cpX = width - width/10;
  cpY = height - height/7;
  smooth();
}

void draw() {
  background(0);
  translate(width/2, height/2);
    rotateX(sin(rotX));
    rotateY(rotY % TWO_PI);
  //rotateZ(sin(rotZ));
  if (playButton == 1) {
    rotX = rotX + 0.005;
    rotY = rotY + 0.005;};
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

  //translate(0,0);
  //rotateY(0);
  //fill(200, 200, 200, 1);
  if (keyPressed == true) {
    if (keyCode == RIGHT) {
      //rect(cpX + (_factor * 2), cpY, _factor * 2, _factor);
      //triangle(cpX + (_factor * 2), cpY + _factor, cpX + (_factor * 2), cpY - _factor, cpX + _factor * 4, cpY);
      rotY = rotY + 0.01;
    } else if (keyCode == LEFT) {
      //rect(cpX - (_factor * 2), cpY, _factor * 2, _factor);
      //triangle(cpX - (_factor * 2), cpY + _factor, cpX - (_factor * 2), cpY - _factor, cpX - _factor * 4, cpY);
      rotY = rotY - 0.01;
    } else if (keyCode == UP) {
      //rect(cpX, cpY - (_factor * 2), _factor, _factor*2);
      //triangle(cpX - _factor, cpY - (_factor *2), cpX + _factor, cpY - (_factor *2), cpX, cpY  - _factor * 4);
      rotX = rotX + 0.01;
    } else if (keyCode == DOWN) {
      //rect(cpX, cpY + (_factor * 2), _factor, _factor*2);
      //triangle(cpX - _factor, cpY + (_factor *2), cpX + _factor, cpY + (_factor *2), cpX, cpY  + _factor * 4);
      rotX = rotX - 0.01;
    }
  };
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == CONTROL) {
      playButton = playButton * -1;
      println(playButton);
    }
  }
}
