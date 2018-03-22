color auburn;

void setup() {
  size(500, 500);
  auburn = color(193, 94, 89);
  background= 
}

void draw() {
  loadPixels();
  for (int x = 0; x < mouseX; x++) {
    for (int y = 0; y < mouseY; y++) {
      color c = color(mouseX, mouseY, 255);
      //stroke(x,y,255);
      int index = mouseX + mouseY*width;
      pixels[index] = c;
      //point(x,y);
    }
  }
  updatePixels();
}