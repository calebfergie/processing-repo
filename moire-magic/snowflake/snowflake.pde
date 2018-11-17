// The world pixel by pixel 2018
// Daniel Rozin
// grid of rectangles changing color with a sine wave

int cellSize= 24;                  // the size of each element
float count = 0;
void setup() {
  size(1000, 800);
}

void draw() {
  background (0); 
  float mouseMove = mouseX*mouseY;
  count++;
  for (int x = 0; x < width; x+=cellSize) {
    for (int y = 0; y < height; y+=cellSize) {  
      
      float snowflake = dist(500, 400, x, y);   //this one uses the mouse as center
      snowflake += count;                             // adds incremental growth  
      snowflake /= 4;                                // make it into a smaller number            
      float newRed= map(sin(snowflake),-1,1,0,255); // get the sinus of the number in order to get a value that has a gratious movement
      float newGreen = map(cos(snowflake),-1,1,0,255);
      float newBlue = map(mouseMove,0,80000,0,255);
      //println(newRed, newGreen, newBlue);
      fill(newRed/2, newGreen/2, newBlue/2);                               // sin() values go from -1 to 1 so we map that to 0 - 255
      rect(x, y, cellSize/1.5, cellSize/1.5);
    }
  }
}