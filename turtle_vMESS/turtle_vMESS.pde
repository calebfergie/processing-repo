// The world pixel by pixel 2018
// Daniel Rozin
// apply a 3x3 convolution

int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
PImage ourImage;
int lsize = 90, lsize2 = lsize * lsize;

float  matrix[]={
  -0.5, -0.5, -0.5, 
  -0.5,   5,  -0.5, 
  -0.5, -0.5, -0.5};  // sharpen  , make sure they all together = plus 1
  
 //float matrix[]={ 2,  1,   1,  1,  0, -1,  1,  -1, -3};  // embose 
 //float matrix[]={  1.0/9,   1.0/9,    1.0/9,   1.0/9,  1.0/9,  1.0/9,  1.0/9,  1.0/9,  1.0/9};  // blur 

void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("https://vignette.wikia.nocookie.net/toriko-fan-fiction/images/5/56/World_Turtle.jpg");
  ourImage.resize (width, height);
  ourImage.loadPixels();                              // load the pixels array of the image
}

void draw() {
  image(ourImage, 0, 0);
  
  loadPixels();  // load the pixels array of the window  
  //loop into pixels of lense
  for (int vd = - lsize; vd < lsize; vd++) {
    for (int ud = - lsize; ud < lsize; ud++) {
      
      r2 = ud*ud + vd*vd;
      if (r2 <= lsize2) {
        f = mag + k * r2;
        u = floor(ud/f) + x;
        v = floor(vd/f) + y;
      }

          PxPGetPixel(u, v, ourImage.pixels, width);      // get the RGB of our pixel and place in RGB globals
          //resultR += float(R) * matrix[countMatrix];              // multiply each neighbor with its value in the matrix
          //resultG += float(G) * matrix[countMatrix];  
          //resultB += float(B) * matrix[countMatrix];  

          //countMatrix++;

      //R= constrain(int (resultR), 0, 255);                      // make sure were between 0-255
      //G= constrain(int(resultG), 0, 255);
      //B= constrain(int(resultB), 0, 255);


      PxPSetPixel(x, y, R, G, B, 255, pixels, width);    // sets the R,G,B values to the window
    }
  updatePixels();                                     //  must call updatePixels oce were done messing with pixels[]
  println (frameRate);
}








// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution

void PxPGetPixel(int u, int v, int[] pixelArray, int pixelsWidth) {
  //int thisPixel=pixelArray[u+v*pixelsWidth];     // getting the colors as an int from the pixels[]
  //A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  //R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  //G = (thisPixel >> 8) & 0xFF;   
  //B = thisPixel & 0xFF;
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