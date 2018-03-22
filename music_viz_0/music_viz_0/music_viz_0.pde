// made with help of https://github.com/processing/processing-sound/issues/67 and processing sound libraryreference

import processing.sound.*;
SoundFile file;
int bands = 1024;
int numChannels = 2;
FFT[] fft = new FFT[numChannels];
AudioIn [] channels = new AudioIn[numChannels];
float[] spectrum = new float[bands];


void setup() {
  file = new SoundFile(this, "fruit-punch.mp3");
  size(512, 512);
  background(255);
  for (int ch=0; ch<numChannels; ch++) {
    channels[ch] = new AudioIn(this, ch);
    channels[ch].start();
    fft[ch] = new FFT(this, bands);
    fft[ch].input(channels[ch]);
  }
  file.loop();
}      

void draw() {
  background(255);
  float r = map(mouseX, 0.0 , height, 0.0, 255.0);
  float g = map(mouseY, 0.0, width, 0.0, 255.0);
  stroke(r,g,200);
  fill(200, r, g);
  for (int ch=0; ch<numChannels; ch++) {
    fft[ch].analyze(spectrum);
  }
  for(int i = 0; i < bands; i = i + 5){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  line( i*2, height, i*10, height - spectrum[i]*height*10);
  line(0, i-2*2, i*2, width - spectrum[i]*width*10);
  ellipse(i,i+1,spectrum[i]/10,spectrum[i]/100);
  }
}