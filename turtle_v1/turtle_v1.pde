PImage ourImage;

// Lens properties
int lsize = 90, lsize2 = lsize * lsize;
float mag = 3.0f;
float k = -0.00016f;



int border, borderViaLens;

public void setup() {
  size(800, 800);
  cursor(CROSS);
  ourImage = loadImage("https://vignette.wikia.nocookie.net/toriko-fan-fiction/images/5/56/World_Turtle.jpg");
  
  ourImage.resize (width, height);
  ourImage.loadPixels();   
  // border colours
  border = color(200);
  borderViaLens = color(180);
}

public void draw() {
  frameRate(12);
  background(200);
  image(ourImage, 0, 0);
  showLens(mouseX, mouseY);
}

public void showLens(int x, int y) {
  int u, v, r2;
  float f;
  //loop into pixels of lense
  for (int vd = - lsize; vd < lsize; vd++) {
    for (int ud = - lsize; ud < lsize; ud++) {
      
      r2 = ud*ud + vd*vd;
      if (r2 <= lsize2) {
        f = mag + k * r2;
        u = floor(ud/f) + x;
        v = floor(vd/f) + y;
        if (u >= 0 && u < ourImage.width && v >=0 && v < ourImage.height)
          set(ud + x, vd + y, ourImage.get(u, v));
        else 
          set(ud + x, vd + y, borderViaLens);
      }
    }
  }
}