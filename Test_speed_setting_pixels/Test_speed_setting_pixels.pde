
void setup() {
  size(1000, 700);
}

void draw() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float randomR= random(255);
      float randomG= random(255);
      float randomB= random(255);
      pixels[x+ y*width]= color(randomR, randomG, randomB);
    }
  }
  updatePixels();
  fill (255);
  rect(80, 80, 150, 40);
  fill (0);
  text("framerate="+frameRate, 100, 100);
}