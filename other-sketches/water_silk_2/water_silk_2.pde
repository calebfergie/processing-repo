//adapted from - Open Processing: https://www.openprocessing.org/sketch/28755#
// thanks to this weird guy with the projector: https://www.youtube.com/watch?v=W8Jf9SVsT38

// PXP elements
float _detail, cpX, cpY;
int _factor = 15;
float _moire = 10;

// color and growth variabls
float fillVal = 0;
float fillRate = 5;
int strokeVal;
int hMod = 50;


void setup() {
  size(800, 800, P3D);
  background(0);
  rectMode(CENTER);
  smooth();

  //canvas-size-based variables
  _detail = (width / _factor) - 1;
  cpX = width - width/10;
  cpY = height - height/7;
}

void draw() {
  background(0);
  colorMode(HSB, 100);

  fillVal = fillVal + 3;

  if (fillVal > 20000 || fillVal < -20000) {
    fillRate = -fillRate;
  }

  float silk= map(fillVal, 0, 800, 0, _detail);
  noFill();
  for (int x = _factor; x<width; x+=_detail) {
    for (int y = _factor; y<height; y+=_detail) {
      float w = _detail/_moire;
      float h = _detail/TWO_PI;
      stroke((x+strokeVal)%35 + hMod, 70, 100);
      rect(x, y, w+silk, h);
      rect(x, y, 0, h);
      ellipse(x, y, w+silk, w+silk);
      ellipse(x, y, h, h);
    }
  }
  drawArrows();
}

void drawArrows() {
  noStroke();
  colorMode(RGB, 100, 100, 100, 1);
  //arrows
  fill(55, 55, 55, 1);
  //right arrow
  rect(cpX + (_factor * 2), cpY, _factor * 2, _factor);
  triangle(cpX + (_factor * 2), cpY + _factor, cpX + (_factor * 2), cpY - _factor, cpX + _factor * 4, cpY);
  //left arrow
  rect(cpX - (_factor * 2), cpY, _factor * 2, _factor);
  triangle(cpX - (_factor * 2), cpY + _factor, cpX - (_factor * 2), cpY - _factor, cpX - _factor * 4, cpY);
  //top arrow
  rect(cpX, cpY + (_factor * 2), _factor, _factor*2);
  triangle(cpX - _factor, cpY + (_factor *2), cpX + _factor, cpY + (_factor *2), cpX, cpY  + _factor * 4);
  //bottom arrow
  rect(cpX, cpY - (_factor * 2), _factor, _factor*2);
  triangle(cpX - _factor, cpY - (_factor *2), cpX + _factor, cpY - (_factor *2), cpX, cpY  - _factor * 4);

  if (keyPressed == true) {
    fill(200, 200, 200, 1);
    if (keyCode == RIGHT) {
      rect(cpX + (_factor * 2), cpY, _factor * 2, _factor);
      triangle(cpX + (_factor * 2), cpY + _factor, cpX + (_factor * 2), cpY - _factor, cpX + _factor * 4, cpY);
      fillVal = fillVal + fillRate;
    } else if (keyCode == LEFT) {
      rect(cpX - (_factor * 2), cpY, _factor * 2, _factor);
      triangle(cpX - (_factor * 2), cpY + _factor, cpX - (_factor * 2), cpY - _factor, cpX - _factor * 4, cpY);
      fillVal = fillVal - fillRate - 3;
    } else if (keyCode == UP) {
      rect(cpX, cpY - (_factor * 2), _factor, _factor*2);
      triangle(cpX - _factor, cpY - (_factor *2), cpX + _factor, cpY - (_factor *2), cpX, cpY  - _factor * 4);
      hMod = hMod + 1;
    } else if (keyCode == DOWN) {
      rect(cpX, cpY + (_factor * 2), _factor, _factor*2);
      triangle(cpX - _factor, cpY + (_factor *2), cpX + _factor, cpY + (_factor *2), cpX, cpY  + _factor * 4);
      hMod = hMod - 1;
    }
  }
}