// The world pixel by pixel 2018
// adapted from grid of rectangles changing color with a sine wave Daniel Rozin


float cellSize= 51;                  // the size of each element
float count = 51;
float growth = 0.01;
void setup() {
  size(1000, 800);
}

void draw() {
  background (0);  
  if (cellSize > 200) {
    growth = -growth;
  }
  
  if (cellSize < 50) {
    growth = -growth;
  }
  
  count = count + count * growth;
  cellSize = count;
  print("cellsize is " + cellSize + '\n');
  for (int x = 0; x < width; x+=cellSize) {
    for (int y = 0; y < height; y+=cellSize) {
      fill(cellSize,cellSize+40,cellSize);
      stroke(128, cellSize, 254);
      rect(cellSize, cellSize, cellSize, cellSize);
      rect(width - cellSize*2, height - cellSize*2, cellSize, cellSize);
      rect(width - cellSize*2,  cellSize, cellSize, cellSize);
      rect(cellSize, height - cellSize*2, cellSize, cellSize);
      rect(width/2, cellSize-cellSize/2, cellSize, cellSize);

    }
  }
}