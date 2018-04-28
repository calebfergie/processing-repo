// REVENGE OF LEFT SHARK SERIES
//beachball chromakey - calebfergie

// DIRECTIONS
// 1. USE NUMBER KEYS 1 - 6 TO HIGHLIGHT A COLOR
// 2. USE UP AND DOWN ARROW KEYS TO INCREASE OR DECREASE THAT COLOR'S THRESHOLD
// 3. TAP NUMBER 7 KEY TO CHANGE BACKGROUND TO BLACK

// Adapted from 'the world pixel by pixel' 2018 - Daniel Rozin
// uses PXP methods in the bottom

import processing.video.*;
float keyR=0, keyG=255, keyB=0;
Capture video;
int threshold;

//setup colors matrix
int[] colorList = new color[6];
int[] colorThresholds = new int[6];

//UI variable
int activeThreshold = 0;
int backgroundBlanket = 1;


void setup() {
  size(960, 720);                                                  
  video = new Capture(this, width, height, 30);
  video.start();
  colorList[0] = color(255, 0, 0);
  colorList[1] = color(0, 0, 255);
  colorList[2] = color(255, 255, 0);
  colorList[3] = color(255, 127, 0);
  colorList[4] = color(0, 255, 0);
  colorList[5] = color(255, 255, 255);
  colorThresholds[0] = 147; // red
  colorThresholds[1] = 180; // blue
  colorThresholds[2] = 125; // yellow
  colorThresholds[3] = 0; // orange - NOT WORKING WELL
  colorThresholds[4] = 188; // green
  colorThresholds[5] = 60; // white
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
      if (redDistance < colorThresholds[0]) {                            
        PxPSetPixel(x, y, 255, 0, 0, 255, pixels, width);     
      } else if (blueDistance < colorThresholds[1]) {                           
        PxPSetPixel(x, y, 0, 0, 255, 255, pixels, width);
      } else if (yellowDistance < colorThresholds[2]) {                           
        PxPSetPixel(x, y, 255, 255, 0, 0, pixels, width);
      } else if (orangeDistance < colorThresholds[3]) {                           
        PxPSetPixel(x, y, 255, 127, 0, 0, pixels, width);
      } else if (greenDistance < colorThresholds[4]) {                          
        PxPSetPixel(x, y, 0, 255, 0, 0, pixels, width);
      } else if (whiteDistance < colorThresholds[5]) {                           
        PxPSetPixel(x, y, 255, 255, 255, 0, pixels, width);
      } else if(backgroundBlanket == -1) {
        PxPSetPixel(x, y, 0, 0, 0, 255, pixels, width);
      } else {
        PxPSetPixel(x, y, R, G, B, 255, pixels, width);
      }
    }
  } 
  updatePixels();
  overlay();
}

void overlay() {

  //make a set of rects to represent the color thresholds
  for (int i = 0; i < colorThresholds.length; i++) {
    if (i == activeThreshold) {
      stroke(255, 255, 255);
    } else {
      stroke(127, 127, 127);
    };
    fill(colorList[i]);
    rect((width/colorThresholds.length)*i+(width/colorThresholds.length/2), height-(height/8), 15, 15);
    text(colorThresholds[i], (width/colorThresholds.length)*i+(width/colorThresholds.length/2), height-(height/8)-20);
  };

  //modify their values using the # keys (1-6) and Up/Down arrows
  if (keyPressed == true) {
    
    // change "active" threshold control with # keys
    if (key == '1') {
      activeThreshold = 0;
    }
    if (key == '2') {
      activeThreshold = 1;
    }
    if (key == '3') {
      activeThreshold = 2;
    }
    if (key == '4') {
      activeThreshold = 3;
    }
    if (key == '5') {
      activeThreshold = 4;
    }
    if (key == '6') {
      activeThreshold = 5;
    }
    
    if (key == '7') {
      backgroundBlanket = backgroundBlanket * -1;
    }
    
    // modify active threshold value with arrow keys
    if (keyCode == UP) {
      colorThresholds[activeThreshold] = constrain(colorThresholds[activeThreshold] + 2,0,255);
    }
    
    if (keyCode == DOWN) {
      colorThresholds[activeThreshold] = constrain(colorThresholds[activeThreshold] - 2,0,255);
    }
  }
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
