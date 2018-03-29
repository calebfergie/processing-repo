// The world pixel by pixel 2018
// Daniel Rozin
// grid of rectangles changing color with a sine wave

int cellSize= 75;                  // the size of each element
float count = 0;


int[] palate = new int[6];
int palateRotator = 0;
float counter = 0;
int currentColor  = 0;
int segment;
int time = 0;

void setup() {
  size(600, 600);
  colorMode(RGB, 100);
  segment = int(height/palate.length);
  palate[0] = color(236, 170, 18, 75);  // Assign value to first element in the array
  palate[1] = color(156, 97, 58, 75); // Assign value to second element in the array
  palate[2] = color(179, 170, 18, 75);  // Assign value to third element in the array
  palate[3] = color(236, 97, 27, 75); 
  palate[4] = color(143, 81, 60, 75);  
  palate[5] = color(81, 58, 68, 75);
}

void draw() {
  background (0);
  time = time + 1;
  if (counter % 1 == 0) {
    counter = 0;
    println("triggered", time);
    if (currentColor == palate.length - 1) {
      currentColor = 0;
    } else {
      currentColor = currentColor + 1;
    }
  } else {
    counter = counter +0.00000001;
  }
  println(currentColor, time);
   fill(palate[currentColor]);



  for (int x = 0; x < width; x+=cellSize) {
    for (int y = 0; y < height; y+=cellSize) {  
      //float newRed= map(x, 0, height, 0, 255); // get the sinus of the number in order to get a value that has a gratious movement
      //float newGreen = map(y, 0, height, 0, 255);
      //float newBlue = map(x, 0, height, 0, 255);
      //int colorPic = int(x%palate.length+1);
      //int colorFlit = int(y%palate.length+1);
      //if (colorFlit%2 == 0) {
      //  fill(palate[colorPic+ 1]);
      //} else {
      //  fill(palate[colorPic]);
      //}   
      // sin() values go from -1 to 1 so we map that to 0 - 255
      rect(x, y, cellSize/1.5, cellSize/1.5);
    }
    //    if (palateRotator == palate.length -1) {
    //  palateRotator = 0;
    //} else {palateRotator = palateRotator +1;};
  }
}