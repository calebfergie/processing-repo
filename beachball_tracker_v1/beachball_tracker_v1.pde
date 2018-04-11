// The world pixel by pixel 2018
// Based on work by Daniel Rozin
// uses PXP methods in the bottom

//Chromakey

import processing.video.*;

Capture ourVideo;                                  // variable to hold the video
int targetR=255,targetG=255,targetB=0;            // these will hold the RGB we are looking for
void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);       // open default video in the size of window
  ourVideo.start();                                  // start the video
}

void draw() {
  image(ourVideo, 0, 0);
  if (ourVideo.available())  ourVideo.read();       // get a fresh frame of video as often as we can
  ourVideo.loadPixels();                            // load the pixels array of the video 

  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, ourVideo.pixels, width);    // Get the RGB of each pixel
      checkRed(0.1,R,G,B,x,y);
    }
  }
  updatePixels(); 
}

void checkRed(float pct, int r, int g, int b, int x, int y) {
  if(dist(r,g,b,255,0,0) < 255*pct) {PxPSetPixel(x, y, 255, 0, 0, 255, pixels, width);};
}

void mousePressed(){
   PxPGetPixel(mouseX, mouseY, ourVideo.pixels, width);    // Get the RGB of pixel under the mouse
   targetR=R;                                              // set the RGB under the mouse to the target
   targetG=G;
   targetB=B;
  
}

// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
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
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
