//LEFT SHARK REVENGE - testing of blob responsiveness and blue tracking instead of red
// Made with code from Daniel Shiffman + Danny Rozin, teaching me the future
// Specifically blobs + PxPGet

//Libriaries
import processing.video.*;
import ddf.minim.*;
Capture video;
Minim minim; 
AudioPlayer introSong;
AudioPlayer song;

//Left and righthand targets for game
Target leftTarget = new Target(-100, -100, 75, true);
Target rightTarget = new Target(1300, -100, 75, true);

//timing & choreography variables
int tbb = 1920; // higher = slower an estimation of the time between beats (inverse BPM)
int tempo = 1; // higher number = higher speed multplier
int tpb = tbb/tempo; // miltiplied tbb (TIME PER BEAT)

int choreoDelay = 7000; // delay before starting target prompts: should be ~14000 millis before beat drop 
int throwawaySection = 2000; //workaround
int[] timeSection = {throwawaySection, choreoDelay, 15000, 15000, 17000, 14000, 16000, 1000}; // millis marks to move to next routine (i.e. seconds in chorus1, chorus 2)

int[][][] leftRoutines = {//xy coordinates of various left hand routines
  {{-100, -100}}, //throwaway value
  {{-100, -100}}, //hidden songintro
  {{300,100},{200,350}}, 
  {{300,550},{300,150},{200,350}}, 
  {{550,350},{200,350}}, 
  {{300,600},{300,100}}, 
  {{200,350},{550,50}}
};

int[][][] rightRoutines = {//xy coordinates of various right hand routines
    {{-100, 1300}}, //throwaway value
  {{-100, 1300}}, //hidden songintro
  {{900, 100}, {1000, 350}}, 
  {{900, 550}, {900, 100}, {1000, 350}}, 
  {{650, 350}, {1000, 350}}, 
  {{900, 100}, {900, 600}}, 
  {{1000, 350}, {650, 50}}
};

int phase, section, sectionTimer, leftTimer, leftStep, rightTimer, rightStep, danceTimer; //timers for stepping between sections and phases of routines

int m, danceM; // ITS MILLIS BETCH - timing vars
boolean updateStatus = false; //programming is a series of compromises and band-aid solutions - used to counter millis lag issue when sketch firsts loads
boolean tallyStatus = false; //programming is a series of compromises and band-aid solutions - used to counter millis lag issue when sketch firsts loads


// UI variables
int screenSection, leftTextX, leftTextY, rightTextX, rightTextY, leftAlpha, rightAlpha; //text-variables
color[] gradeColors = {color(243, 93, 10), color(241, 157, 7), color(242, 205, 12), color(54, 217, 211), color(115, 236, 156)}; //text colors
String[] gradeWords ={"MISS", "BOO", "GOOD", "GREAT", "PERFECT"}; //text contents
boolean devMode = false; //developer view overlay

//Game scoring variables
int leftGrade, rightGrade;
ArrayList<Score> score = new ArrayList<Score>();
int perfectCount, greatCount, goodCount, booCount, missCount, subTotal, avgScore, salutation;
String[] salutationList ={"That was awful, Left Shark is not impressed", "Not your best, better luck next time", "Good Job, Left Shark approves", "Awesome job! Left Shark is proud of you", "WOW! Amazing job. Left Shark is Jealous"}; //text contents

//blob variables
int blobCounter = 0;
float threshold = 160;
float distThreshold = 90;
ArrayList<Blob> blobs = new ArrayList<Blob>();

//PXP variables
int R, G, B, A;
int realX; //the non-flipped X value for making the targets with a mirror display
float greenScreenThreshold = 81;

//greenscreen
PImage secondImage;
PImage introImage;

//fonts
PFont font1;
PFont font1small;
PFont font1med;
PFont font1big;

void setup() {
  size(1200, 900, P3D); //only likes really clean 4:3 multipes

  //webcam setup
  video = new Capture(this, width, height);       // open default video in the size of window
  video.start();

  //greenscreen image/video setup
  secondImage = loadImage("https://i.imgur.com/sSruyPo.jpg");
  secondImage.resize(width, height);

  introImage = loadImage("https://i.imgur.com/WkyQ9nF.jpg");
  introImage.resize(width, height);

  // Sound setup
  minim = new Minim(this);
  song = minim.loadFile("left-shark-revenge_mixdown.mp3", 1024);
  introSong = minim.loadFile("cigarettes-and-coffee.mp3", 1024);

  //font setup
  font1small = loadFont("Phosphate-Inline-24.vlw");
  font1 = loadFont("Phosphate-Inline-32.vlw");
  font1med = loadFont("Phosphate-Inline-42.vlw");
  font1big = loadFont("Phosphate-Inline-64.vlw");
  textFont(font1);
  //textSize(32);
  // for computer perfomance improvements: remove printls and overlay, manage fonts
  
}

//threshold controls and interactive
void keyPressed() {
  if (key == 'a') {
    distThreshold+=5;
  }//increase of how fine the blob is
  else if (key == 's') {
    distThreshold-=5;
  }//decrease how fine the blob is
  if (key == 'z') { 
    threshold+=5;
  } //increase how easily any pixel is blobbed up
  else if (key == 'x') {
    threshold-=5;
  } //increase how easily any pixel is blobbed up
  else if (key == 'o') {
    devMode = !devMode;
  } //toggle "developer mode" to see backend stats
  else if (key == 'q') {
    greenScreenThreshold-=3;
  } //increase how easily any pixel is greenscreened
  else if (key == 'w') {
    greenScreenThreshold+=3;
  } //increase how easily any pixel is greenscreened
  else if (keyCode == ENTER) {
    if (screenSection == 2) {screenSection =0;} else {screenSection++;}
    rightTimer = m; //set the timers to the current time
    leftTimer = m;
    danceTimer = m;
    //screenSection = 1;
  } //"Start game" prompt
}

void draw() {
  m = millis(); //a milli a milli a a a a milli (timing)
  if (screenSection == 0) {//show the intro scene, play the intro music
    runIntro();
  }
  if (screenSection == 1) {//launch the game- danceM
    introSong.pause();
    danceM = m; //define a new relative millis time
    runGame();
  }

  if (screenSection == 2) {
    song.pause();
    runGameOver();
  }

  if (devMode == true) {
    overlay();
  }
} //end draw


void overlay() {
  for (Blob b : blobs) {
    b.show();
  }
  fill(0, 0, 0, 255);
  textAlign(LEFT);
  fill(255);
  text("distance threshold: " + distThreshold, 10, 25);
  text("color threshold: " + threshold, 10, 50);  
  text("green screen threshold: " + greenScreenThreshold, 10, 75);
  text("framerate: " + frameRate, 10, 100);
}

void runIntro() {
  if (m >= 500 && !introSong.isPlaying()) {
    introSong.play();
  } //wait half a second before playing the song

  // load the screen pixels
  if (video.available()) video.read();
  image(introImage, 0, 0);   
  loadPixels();                                                          
  video.loadPixels();
  for (int x = 0; x < video.width; x++ ) {
    realX = width - x; // re-define a "real X" that has an origin of 0,0
    for (int y = 0; y < video.height; y++ ) {
      PxPGetPixel(x, y, video.pixels, width);        // get the RGB of the live video (          int loc = x + y * video.width;  color currentColor = video.pixels[loc];
      float gd = distSq(R, G, B, 219, 205, 165); //hardcoded GREEN or wall color
      if (gd > sq(greenScreenThreshold)) {
        PxPSetPixel(realX-1, y, R, G, B, 255, pixels, width); //loads the pixels of the second image or video
      }
    }
  }
  updatePixels();
  textAlign(CENTER, CENTER);
  textFont(font1big);
  fill(gradeColors[3]);
  //textSize(64);
  text("REVENGE OF LEFT SHARK", width/2, height/2 - 300);
  textFont(font1small);
  //textSize(24);
  fill(200);
  text("In 2015, during the Super Bowl Halftime show with Katy Perry", width/2, height/2 - 150);
  text("one brave shark danced to his own rhythm ", width/2, height/2 - 100);
  text("Years later, left shark is still training for it's second-chance.", width/2, height/2-50);
  textFont(font1med);
  //textSize(42);
  fill(gradeColors[4]);
  text("TIME TO DANCE!", width/2, height/2+100);
  text("BEGIN BY PRESSING ENTER/RETURN", width/2, height/2 + 150);
  textFont(font1);
}

void runGame() {
  if (danceM >= 5000 && updateStatus==false) { //update status workaround. may not be necessary
    rightTimer = rightTimer + (tpb/2);
    updateStatus = true;
  }
  if (danceM - danceTimer >= 500 && !song.isPlaying()) {
    song.play();
  } //wait half a second before playing the song

  if (danceM - danceTimer >= 92000) { //pause the song and move on after 1.5 minutes
    song.pause();
    screenSection=2;
  }

  // load the screen pixels
  if (video.available()) video.read();
  image(secondImage, 0, 0);   
  loadPixels();                                                          
  video.loadPixels();

  // timer system to advance to next series of choreography
  if (danceM - sectionTimer >= timeSection[section]) {   // move from phase to phase with a section timer
    if (section == timeSection.length-1 || section == leftRoutines.length-1 || section == rightRoutines.length-1) {
      section = 0;
    } else { //go to the next section
      section++;
    } 
    if (phase == leftRoutines.length-1 || phase == rightRoutines.length-1) {
      phase=0;
    } else {
      phase++;
    } // go to the next phase
    sectionTimer = danceM; // bump up the timer to the current time
    if (section == 4) {
      rightTimer = leftTimer; //estimated resync - might need to be tweaked
      tpb = tpb/2; //double the speed
    };

    rightStep =0; //reset the stepper counter
    leftStep =0;
  };

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>(); //make a list of current blobs

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    realX = width - x; // re-define a "real X" that has an origin of 0,0
    for (int y = 0; y < video.height; y++ ) {
      PxPGetPixel(x, y, video.pixels, width);          // get the RGB of the live video (replacing int loc = x + y * video.width;  color currentColor = video.pixels[loc];
      //BLOB STUFF
      float d = distSq(R, G, B, 255, 0, 0); //hardcoded RED
      if (d < threshold*threshold) { 
        boolean found = false;
        for (Blob b : currentBlobs) {
          if (b.isNear(realX, y)) {
            b.add(realX, y);
            found = true;
            break;
          }
        }
        if (!found) {
          Blob b = new Blob(realX, y);
          currentBlobs.add(b);
        }
      }
      // GREENSCREEN STUFF
      float gd = distSq(R, G, B, 219, 205, 165); //hardcoded GREEN or wall 219, 205, 127
      if (gd > sq(greenScreenThreshold)) {
        PxPSetPixel(realX-1, y, R, G, B, 255, pixels, width);
      }
    }
  }

  updatePixels();

  // MORE BLOB STUFF
  for (int i = currentBlobs.size()-1; i >= 0; i--) {
    if (currentBlobs.get(i).size() < 500) {
      currentBlobs.remove(i);
    }
  }

  // There are no blobs!
  if (blobs.isEmpty() && currentBlobs.size() > 0) {
    //println("Adding blobs!");
    for (Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()) {
    // Match whatever blobs you can match
    for (Blob b : blobs) {
      float recordD = 1000000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !cb.taken) {
          recordD = d; 
          matched = cb;
        }
      }
      matched.taken = true;
      b.become(matched);
    }

    // Whatever is leftover make new blobs
    for (Blob b : currentBlobs) {
      if (!b.taken) {
        b.id = blobCounter;
        blobs.add(b);
        blobCounter++;
      }
    }
  } else if (blobs.size() > currentBlobs.size()) {
    for (Blob b : blobs) {
      b.taken = false;
    }


    // Match whatever blobs you can match
    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !b.taken) {
          recordD = d; 
          matched = b;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.become(cb);
      }
    }

    for (int i = blobs.size() - 1; i >= 0; i--) {
      Blob b = blobs.get(i);
      if (!b.taken) {
        blobs.remove(i);
      }
    }
  }

  // END BLOB STUFF

  //blob and target collision detection
  for (Blob b : blobs) {
    if (distSq(b.getCenter().x, b.getCenter().y, leftTarget.xCenter, leftTarget.yCenter) < b.size()) {
      leftAlpha = 255;
      leftGrade = leftTarget.grade(leftTimer, danceM, tpb); // give a grade
      leftTextX = leftTarget.xCenter; //text position x
      leftTextY = leftTarget.yCenter; //text position y
      score.add(new Score(gradeWords[leftGrade]));
      leftTarget.hide(); //hide it until the next beat and location
    }

    if (distSq(b.getCenter().x, b.getCenter().y, rightTarget.xCenter, rightTarget.yCenter) < b.size()) {
      rightAlpha = 255;
      rightGrade = rightTarget.grade(rightTimer, danceM, tpb); // give a grade
      rightTextX = rightTarget.xCenter; //text position x
      rightTextY = rightTarget.yCenter; //text position y
      score.add(new Score(gradeWords[rightGrade]));
      rightTarget.hide(); //hide it until the next beat and location
    }
  }


  triggerAnimation(); //Advance targets through choreography
  textAnimation(); //Control the target's alpha and text values that appear on the screen
}

void runGameOver() {
  textAlign(CENTER, CENTER);
  fill(0);
  textFont(font1big);
  //textSize(64);
  text("GAME OVER!", width/2, 150);
  textFont(font1med);
  tallyScore();
  int testDist = width/gradeWords.length;
  fill(gradeColors[4]);
  text("Perfect moves:"+perfectCount,testDist, height/2);
  fill(gradeColors[3]);
  text("Great moves:"+greatCount,(testDist*2)-(testDist/4), height/2+100);
  fill(gradeColors[2]);
  text("Good moves:"+goodCount,(testDist*3)-(testDist/4), height/2);
  fill(gradeColors[1]);
  text("Boo moves:"+booCount,(testDist*4)-(testDist/4), height/2+100);
  fill(gradeColors[0]);
  text("Misses:"+missCount, width - testDist +(testDist/4), height/2);
  fill(gradeColors[salutation]);
  text(salutationList[salutation], width/2, 225);
  text("You had an average score of: "+avgScore,width/2,275);
}

void triggerAnimation() {

  if (danceM - leftTimer  >= tpb) { // if the time limit has been reach
    leftTimer = danceM;
    if (leftTarget.stillThere() == true) {
      leftAlpha = 255;
      leftGrade = leftTarget.grade(0, tpb, tpb); // auto-grade it a (MISS)
      leftTextX = leftTarget.xCenter;
      leftTextY = leftTarget.yCenter;
      score.add(new Score(gradeWords[leftGrade]));
    }
    leftTarget.move(leftRoutines[phase][leftStep][0], leftRoutines[phase][leftStep][1]); // move to the next step (x and y values)
    if (leftStep == leftRoutines[phase].length-1) { //check if there is a step after this one, loop back to the first if not
      leftStep = 0;
    } else {
      leftStep++;
    };
  };

  if (danceM - rightTimer  >= tpb) { // if the time limit has been reach
    rightTimer = danceM; 
    if (rightTarget.stillThere() == true) {
      rightAlpha = 255;
      rightGrade = rightTarget.grade(0, tpb, tpb); // auto-grade it a (MISS)
      rightTextX = rightTarget.xCenter;
      rightTextY = rightTarget.yCenter;
      score.add(new Score(gradeWords[rightGrade]));
    }
    rightTarget.move(rightRoutines[phase][rightStep][0], rightRoutines[phase][rightStep][1]); // move to the next step (x and y values)
    if (rightStep == rightRoutines[phase].length-1) { //check if there is a step after this one, loop back to the first if not
      rightStep = 0;
    } else {
      rightStep++;
    };
  };
  rightTarget.display(abs(255-(rightAlpha)/2), "R");
  leftTarget.display(abs(255-(leftAlpha)/2), "L");


  if (leftAlpha > 0) {
    leftAlpha = leftAlpha-5;
  };

  if (rightAlpha > 0) {
    rightAlpha = rightAlpha-5;
  };
}

void textAnimation() {
  //text animation
  textAlign(RIGHT);
  fill(gradeColors[leftGrade], leftAlpha);
  text(gradeWords[leftGrade], leftTextX, leftTextY);
  fill(gradeColors[rightGrade], rightAlpha);
  text(gradeWords[rightGrade], rightTextX, rightTextY);

  if (leftTextY < height) {
    leftTextY = leftTextY+3;
  }
  if (leftAlpha > 0) {
    leftAlpha = leftAlpha-5;
  }

  if (rightTextY < height) {
    rightTextY = rightTextY+3;
  }
  if (rightAlpha > 0) {
    rightAlpha = rightAlpha-5;
  }
}

void tallyScore() {
  if (tallyStatus == false) {
   for (Score part: score) {
    if (part.grade == gradeWords[4]) {
      perfectCount++;
      subTotal+=4;
    }
    else if (part.grade == gradeWords[3]) {
      greatCount++;
      subTotal+=3;
    }
    else if (part.grade == gradeWords[2]) {
      goodCount++;
      subTotal+=2;
    }
    else if (part.grade == gradeWords[1]) {
      booCount++;
      subTotal+=1;
    }
    else if (part.grade == gradeWords[0]) {
      missCount++;
    }
  }
    avgScore = subTotal/ (score.size() + 1); // +1 to prevent div by 0
    salutation = constrain(round(avgScore),0,gradeWords.length);
  
  }
  tallyStatus = true;
}

// MAJOR KEY functions from danny and schiffman

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

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
