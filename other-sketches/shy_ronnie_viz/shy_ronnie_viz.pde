//adapted from Open Processing: https://www.openprocessing.org/sketch/28755#


// ball vars
float _detail = 20;
int _ballRadius = 200;
float rotX = 0;
float rotY = PI/2;
float rotZ = 0;
int playButton = -1;

//arrow vars
float cpX, cpY;
int _factor = 15;

// Sound elements
import processing.sound.*;
SoundFile file;
int bands = 256;
int numChannels = 2;
FFT[] fft = new FFT[numChannels];
AudioIn [] channels = new AudioIn[numChannels];
float[] spectrum = new float[bands];

//debugger
int timeThing;
int counter = 0;

int matrixLength = 100;
// 71 is the magic number for some reason
float[] averageArray = new float[matrixLength];
float[][] theMatrix = new float[matrixLength][matrixLength];
float amp = 0.05;

void setup() {
  size(800, 800, P3D);
  file = new SoundFile(this, "shy-ronnie.aif");
  colorMode(HSB, 100);
  background(0);
  cpX = width - width/10;
  cpY = height - height/7;
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
  translate(width/2, height/2);
  rotateX(sin(rotX));
  rotateY(rotY % TWO_PI);
  //rotateZ(sin(rotZ));
  if (playButton == 1) {
    rotX = rotX + 0.005;
    rotY = rotY + 0.005;
  };
  stroke(255);
  noFill();
  beginShape();
  float x, y, z, h, s, l;
  for (int ch=0; ch<numChannels; ch++) {
    fft[ch].analyze(spectrum);
  }
  timeThing = 0;
  for (float zi = -_detail * PI / 2; zi < _detail * PI; zi++) {
    timeThing++;
    averagize(_ballRadius *spectrum[abs(int(zi))], timeThing -1);
    println(timeThing,frameRate);
    for (float r = 0; r < TWO_PI; r += TWO_PI / _detail) {
      x = cos(r);
      y = sin(r);
      z = zi / _detail;

      //HSL color mapping
      h = map(r, 0, TWO_PI, 0, 100);
      //s = map(r, 0, TWO_PI, 0, 100);
      l = map(r, 0, TWO_PI, 75, 100);
      stroke(h, 70, l);
      float heightMultiplier = sqrt(1 - sq(z-.5));
      curveVertex(x * heightMultiplier * _ballRadius, (y * heightMultiplier*_ballRadius) + (y * heightMultiplier*_ballRadius*averageArray[timeThing-1]), z * _ballRadius - _ballRadius/2);
    }
  }
  endShape();
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


// edit a giant ass array and another array of averages of the first
void averagize(float spectrumBandSize, int position) {
  if (counter == theMatrix[position].length - 1) {
    counter = 0;
  } else {
    counter = counter + 1;
  }

  theMatrix[position][counter] = spectrumBandSize;

  float avgBand = 0;
  float rollingBandSub = 0;
  for (int i = 0; i < theMatrix[position].length; i ++) {
    rollingBandSub = rollingBandSub + theMatrix[position][i];
  }
  avgBand = rollingBandSub/theMatrix[position].length;
  averageArray[position] = avgBand * amp * position;
}
