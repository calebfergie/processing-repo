// The world pixel by pixel 2018 - Daniel Rozin
// uses PXP methods in the bottom
// does a chroma key effect

import processing.video.*;
float keyR=0, keyG=255, keyB=0;
Capture video;
int threshold;

//setup colors matrix
int[] colorList = new color[6];
int[] colorThresholds = new int[6];


void setup() {
  size(640, 480);                                                  
  video = new Capture(this, width, height, 30);
  video.start();
  colorList[0] = color(255,0,0);
  colorList[1] = color(0,0,255);
  colorList[2] = color(255,255,0);
  colorList[3] = color(255,127,0);
  colorList[4] = color(0,255,0);
  colorList[5] = color(255,255,255);
  colorThresholds[0] = 161; // red
  colorThresholds[1] = 161; // blue
  colorThresholds[2] = 100; // yellow
  colorThresholds[3] = 161; // orange
  colorThresholds[4] = 161; // green
  colorThresholds[5] = 100; // white
}

void draw() {
  if (video.available()) video.read();
  loadPixels();                                                           // load the screen pixels                                                 
  video.loadPixels();                                                   // load the video pixels     
  threshold = 161;                                                     // moving the changes the threshold
  for (int y = 0; y < video.height; y++) {
    for (int x = 0; x < video.width; x++) {                                                                                               
      PxPGetPixel(x, y, video.pixels, width);               // get the RGB of the live video
      float redDistance = dist(R, G, B, 255, 0, 0);     // compare our pixel to the target,R,G,B
      float blueDistance = dist(R, G, B, 0, 0, 255);
      float greenDistance  = dist(R, G, B, 0, 255, 0);
      float yellowDistance  = dist(R, G, B, 255, 255, 0);
      float orangeDistance  = dist(R, G, B, 255, 127, 0);
      float whiteDistance  = dist(R, G, B, 255, 255, 255);
      if (redDistance < colorThresholds[0]) {                           // If that distance is greater than the threshold then place 
        PxPSetPixel(x, y, 255, 0, 0, 255, pixels, width);     // that pixel on the screen
      } else if (blueDistance < colorThresholds[1]) {                           // If that distance is greater than the threshold then place 
        PxPSetPixel(x, y, 0, 0, 255, 255, pixels, width);
      } else if (yellowDistance < colorThresholds[2]) {                           // If that distance is greater than the threshold then place 
        PxPSetPixel(x, y, 255, 255, 0, 0, pixels, width);
      } else if (orangeDistance < colorThresholds[3]) {                           // If that distance is greater than the threshold then place 
        PxPSetPixel(x, y, 255, 127, 0, 0, pixels, width);
      } else if (greenDistance < colorThresholds[4]) {                           // If that distance is greater than the threshold then place 
        PxPSetPixel(x, y, 0, 255, 0, 0, pixels, width);
      } else if (whiteDistance < colorThresholds[5]) {                           // If that distance is greater than the threshold then place 
        PxPSetPixel(x, y, 255, 255, 255, 0, pixels, width);
      } else {
        PxPSetPixel(x, y, R, G, B, 255, pixels, width);
      }
    }
  } 
  updatePixels();
  overlay();
}

void overlay() {
  for (int i = 0; i < colorThresholds.length; i++) {
    fill(colorList[i]);
    rect((width/colorThresholds.length)*i+(width/colorThresholds.length/2), height-(height/8), 15, 15);
    text(colorThresholds[i],(width/colorThresholds.length)*i+(width/colorThresholds.length/2),height-(height/8)-20);
  };
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
