// made with help of https://github.com/processing/processing-sound/issues/67 and processing sound libraryreference

//sound
import processing.sound.*;
SoundFile file;
int bands = 1024;
int numChannels = 2;
FFT[] fft = new FFT[numChannels];
AudioIn [] channels = new AudioIn[numChannels];
float[] spectrum = new float[bands];

// shape and array math
int barW = bands/8;
float[] rollingBand1 = new float[barW];


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
  //reset vars
  background(255);
  float r = map(mouseX, 0.0, height, 0.0, 255.0);
  float g = map(mouseY, 0.0, width, 0.0, 255.0);
  float bar1a = 0;
  float denom = 0;
  stroke(r, g, 200);
  fill(200, r, g);

  for (int ch=0; ch<numChannels; ch++) {
    fft[ch].analyze(spectrum);
  }

  for (int i = 0; i < bands; i = i + 5) {
    // The result of the FFT is normalized
    // draw the line for frequency band i scaling it up by 5 to get more amplitude.
    line( i, height, i, height - spectrum[i]*height*500);

    //check if in first bar
    if (i >= 0 && i < barW - 1) {
      bar1a = bar1a + spectrum[i];
      denom+=1;
      rollingBand1[i] = rollingBand1[i+1];
    }
  }
  float bar1h = bar1a/denom*100000;

  //calculate the average of the last barW samples of sound
  float avgBand1 = 0;
  float rollingBandSub = 0;
  rollingBand1[rollingBand1.length-1] = bar1h;
  for (int i = 0; i < rollingBand1.length; i ++) {
    rollingBandSub = rollingBandSub + rollingBand1[i];
  }
  avgBand1 = (rollingBandSub / rollingBand1.length)*200;
  fill(200);
  rect(0, avgBand1, barW, height); 
  println (frameRate, avgBand1);
}
