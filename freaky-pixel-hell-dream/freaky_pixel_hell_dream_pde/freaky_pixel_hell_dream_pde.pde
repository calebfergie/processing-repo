// The world pixel by pixel 2018
// Daniel Rozin
// grid of rectangles changing color with a sine wave

int cellSize= 18;                  // the size of each element
float count = 0;
void setup() {
  size(1000, 800);
}

void draw() {
  //background (0);  
  count++;
  for (int x = 0; x < width; x+=cellSize) {
    for (int y = 0; y < height; y+=cellSize) {  
      
      float distanceToMouse= dist(500, 500, x, y);   //this one uses the mouse as center
      distanceToMouse+= count;                             // adds incremental growth  
      distanceToMouse/= 0.95;                                // make it into a smaller number            
      float newGray= map(sin(distanceToMouse),-1,1,0,255);       // get the sinus of the number in order to get a value that has a gratious movement
      fill(newGray, newGray/1.5, newGray/2);                               // sin() values go from -1 to 1 so we map that to 0 - 255
      rect(x, y, cellSize, cellSize);
    }
  }
}