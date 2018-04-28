//kenyan coffee
//krungthep
//phosphate inline
//silom

PFont font1;
PFont font2;
PFont font3;
PFont font4;

void setup() {
size(300,300);

// The font must be located in the sketch's 
// "data" directory to load successfully
font1 = loadFont("KenyanCoffeeRg-Bold-32.vlw");
font2 = loadFont("Krungthep-32.vlw");
font3 = loadFont("Phosphate-Inline-32.vlw");
font4 = loadFont("Silom-32.vlw");
}

void draw() {
  background(255);
  fill(0);
textFont(font1);
text("PERFECT", 10, 50);
textFont(font2);
text("PERFECT", 10, 100);
textFont(font3);
text("PERFECT", 10, 150);
textFont(font4);
text("PERFECT", 10, 200);
}
