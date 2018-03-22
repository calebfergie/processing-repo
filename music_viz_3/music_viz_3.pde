// made with help of https://github.com/processing/processing-sound/issues/67 and processing sound libraryreference

import processing.sound.*;
SoundFile file;
int bands = 512;
int numChannels = 2;
FFT[] fft = new FFT[numChannels];
AudioIn [] channels = new AudioIn[numChannels];
float[] spectrum = new float[bands];

PImage album;

int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()

void setup() {
  file = new SoundFile(this, "shy-ronnie.aif");
  album = loadImage("album.jpg");
  size(355, 355);
  album.resize(width,height);
  album.loadPixels();
  
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
  //image(album,0,0);
  stroke(220,220,220);
  fill(220);
    for (int ch=0; ch<numChannels; ch++) {
    fft[ch].analyze(spectrum);
  }
  for(int i = 0; i < bands; i++){
    line(i,height,i, height - spectrum[i]*100000);
  }
    loadPixels();
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x,y,album.pixels, width); 
      
    }
  }
  
  updatePixels();
  
}

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}

  //float r = map(mouseX, 0.0 , height, 0.0, 255.0);
  //float g = map(mouseY, 0.0, width, 0.0, 255.0);
  //stroke(r,g,200);
  //fill(200, r, g);

  //for(int i = 0; i < bands; i = i + 5){
  //// The result of the FFT is normalized
  //// draw the line for frequency band i scaling it up by 5 to get more amplitude.
  //line( i*2, height, i*10, height - spectrum[i]*height*10);
  //line(0, i-2*2, i*2, width - spectrum[i]*width*10);
  //ellipse(i,i+1,spectrum[i]/10,spectrum[i]/100);
  //}