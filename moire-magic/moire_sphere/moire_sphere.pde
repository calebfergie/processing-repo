//adapted from Open Processing: https://www.openprocessing.org/sketch/28755#


// ball vars
float _detail = 20;
int _ballRadius = 200;
float rotX = 0;
float rotY = PI/2;
float rotZ = 0;

// Sound elements
import processing.sound.*;
SoundFile file;
int bands = 256;
int numChannels = 2;
FFT[] fft = new FFT[numChannels];
AudioIn [] channels = new AudioIn[numChannels];
float[] spectrum = new float[bands];


int matrixLength = 200;
// 71 is the magic number for some reason
float[] averageArray = new float[matrixLength];
float[][] theMatrix = new float[matrixLength][matrixLength];
float amp = 1;

void setup() {
  size(800, 800, P3D); // canvas
  file = new SoundFile(this, "i-cant-take-it.aiff"); //load music file
  colorMode(HSB, 100); //set colormode
  background(0);       //black background
  smooth();            //smoothing built in function
  
  //set up and play (loop) audio file
  for (int ch=0; ch<numChannels; ch++) {
    channels[ch] = new AudioIn(this, ch);
    channels[ch].start();
    fft[ch] = new FFT(this, bands);
    fft[ch].input(channels[ch]);
  }
  file.loop();
  
}

void draw() {
  background(0); //black background
  
  //translate & rotate
  translate(width/2, height/2);
  rotateX(sin(rotX));
  rotateY(rotY % TWO_PI);
  rotateZ(sin(rotZ));
  
  //reset stroke and fill
  stroke(255);
  noFill();
  
  //start drawing shape
  beginShape();
  float x, y, z, h, s, l; //variables for position (xyz) and color (hsl)
  
  //math magic
  for (float zi = -_detail * PI / 2; zi < _detail * PI; zi++) {
    for (float r = 0; r < TWO_PI; r += TWO_PI / _detail) {
      x = cos(r);
      y = sin(r);
      z = zi / _detail;

      //HSL color mapping
      h = map(r, 0, TWO_PI, 0, 100);
      //s = map(r, 0, TWO_PI, 0, 100); //not necessary for full brightness
      l = map(r, 0, TWO_PI, 75, 100);
      stroke(h, 70, l);
      
      //more math
      float heightMultiplier = sqrt(1 - sq(z-.5));
      
      //draw the shape piece
      curveVertex(x * heightMultiplier * _ballRadius, (y * heightMultiplier*_ballRadius) - (y * heightMultiplier), z * _ballRadius - _ballRadius/2);
    }
  }
  endShape();
  
  //user controls
  
  if (keyPressed == true) {
    if (keyCode == RIGHT) {
      rotY = rotY + 0.01;
    } else if (keyCode == LEFT) {
      rotY = rotY - 0.01;
    } else if (keyCode == UP) {
      rotX = rotX + 0.01;
    } else if (keyCode == DOWN) {
      rotX = rotX - 0.01;
    }
  };
}
