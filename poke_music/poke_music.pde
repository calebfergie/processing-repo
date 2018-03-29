//adapted from - Open Processing: https://www.openprocessing.org/sketch/28755#
// thanks to this weird guy with the projector: https://www.youtube.com/watch?v=W8Jf9SVsT38

// Sound elements
import processing.sound.*;
SoundFile file;
int bands = 1024;
int numChannels = 2;
FFT[] fft = new FFT[numChannels];
AudioIn [] channels = new AudioIn[numChannels];
float[] spectrum = new float[bands];
float average;

// PXP elements
int _factor = 15;
float _moire = 10;

// color and growth variabls
float fillVal = 0;
float fillRate = 5;
int strokeVal;
int hMod = 50;

// Canvas elemens 
int windowSize = 600;
int _detail = (windowSize / _factor) - 1;
float  cpX = windowSize - windowSize/10;
float  cpY = windowSize - windowSize/7;
float[] aech = new float[_detail];

void setup() {
  file = new SoundFile(this, "fruit-punch.mp3");
  size(600, 600, P3D);
  background(0);
  rectMode(CENTER);
  smooth();
  for (int ch=0; ch<numChannels; ch++) {
    channels[ch] = new AudioIn(this, ch);
    channels[ch].start();
    fft[ch] = new FFT(this, bands);
    fft[ch].input(channels[ch]);
  }
  file.loop();
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
      ellipse(x, y, average, average);
      ellipse(x, y, h, h);
    }
  }
  musicRead();
  drawArrows();
}

void musicRead() {
  float total = 0;
  for (int ch=0; ch<numChannels; ch++) {
    fft[ch].analyze(spectrum);
  }
  for (int i = 0; i < bands; i++) {
    // The result of the FFT is normalized
    total = spectrum[i] + total;
  }
  average = total / bands;
      // draw the line for frequency band i scaling it up by 5 to get more amplitude.
    //  if (i < aech.length) {
    //  aech[i] = spectrum[i];
    //}
    //line( i, height, i, height - spectrum[i]*height*10);
    //line(0, i-2*2, i*2, width - spectrum[i]*width*10);
    //ellipse(i,i+1,spectrum[i]/10,spectrum[i]/100);
  
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