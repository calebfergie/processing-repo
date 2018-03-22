/** inspired by minim examples
**/

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer song;
FFT fftLin;
FFT fftLog;

float spectrumScale = 4;

PShader chroma;
PFont font;

int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
PImage ourImage;
PImage fire;

void setup()
{
  size(355, 355, P2D);
   chroma = loadShader("chroma.glsl");
 chroma.set("u_res",(float)width,(float)height);
   ourImage= loadImage("album.jpg");
   fire= loadImage("fire.jpg");
   chroma.set("u_tex",ourImage);

  minim = new Minim(this);
  song = minim.loadFile("shy-ronnie.aif", 1024);
  
  // loop the file
  song.loop();
  
  // create an FFT object that has a time-domain buffer the same size as song's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be 1024. 
  // see the online tutorial for more info.
  fftLin = new FFT( song.bufferSize(), song.sampleRate() );
  
  // calculate the averages by grouping frequency bands linearly. use 30 averages.
  fftLin.linAverages( 30 );
  
  
  rectMode(CORNERS);
  font = loadFont("ArialMT-12.vlw");
}

void draw()
{
  background(0); 
  textFont(font);
  textSize( 12 );
  fftStuff();
}

void fftStuff() {
    // perform a forward FFT on the samples in song's mix buffer
  fftLin.forward( song.mix );

  noStroke();
  int bandRange = 64;
  int bandStart = constrain(mouseX - bandRange/2, 0, song.bufferSize());
  int bandEnd = constrain(mouseX + bandRange/2, 0, song.bufferSize());
  float average = 0;
  
  for (int i = bandStart; i < bandEnd; i++) {
    average = average + fftLin.getBand(i);
  }
  average = average/(bandEnd - bandStart);
  
  // draw the linear averages
    // since linear averages group equal numbers of adjacent frequency bands
    // we can simply precalculate how many pixel wide each average's 
    // rectangle should be.
    int w = int( width/fftLin.avgSize() );
    for(int i = 0; i < fftLin.avgSize(); i++)
    {
          fill(255);
      
      // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
      rect(i*w, height, i*w + w, height - fftLin.getAvg(i)*spectrumScale);
    }
    
   //visual info about the selector
  text(average, 10, 10);
  stroke(255,0,0);
  noFill();
  rect(bandStart, height - 25, bandEnd, height - 5);
}


void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                                // We are packing all 4 composents into one int
  g = g << 8;                                 // so we need to shift them to their places
  color argb = a | r | g | b;                 // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;          // finaly we set the int with te colors into the pixels[]
}