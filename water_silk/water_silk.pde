//adapted from - Open Processing: https://www.openprocessing.org/sketch/28755#
// thanks to this weird guy with the projector: https://www.youtube.com/watch?v=W8Jf9SVsT38

float _detail = 25;
float _moire = 2;
int _ballRadius = 200;


void setup() {
  size(800, 800, P3D);
  colorMode(HSB, 100);
  background(0);
  smooth();
}

void draw() {
  background(0);
  float silk= map(mouseX, 0 , 800, 0, _detail);
  float water= map(mouseY, 0 , 800, 0, _detail);
  noFill();
  for (int x = 0; x<width; x+=_detail) {
    for (int y = 0; y<height; y+=_detail) {
      stroke(65, 70, 100);
      //rect(x, y, _detail, _detail);
      float w = _detail/_moire;
      float h = _detail;
      stroke(15, 70, 100);
      rect(x,y,w+silk,h+water);
      rect(x,0, w+silk,h+water);
    }
  }
}