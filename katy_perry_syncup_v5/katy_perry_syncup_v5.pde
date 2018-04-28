
import ddf.minim.*;
Minim minim; 
AudioPlayer song;

// an estimation of the time between beats (inverse BPM)
int tbb = 1900; // higher = slower
int tempo = 1;
int tpb = tbb/2;

int choreoDelay = 12000; // should be ~8 secs before beat drop

int[] timeSection = {
  choreoDelay, 15000, 15000, 17000, 14000, 16000
}; // millis marks to move to next routine


int[][][] leftRoutines = {
  {{-100, -100}}, 
  {{300, 150}, {150, 350}}, 
  {{300, 550}, {300, 150}, {150, 350}}, 
  {{550, 350}, {150, 350}},
  {{300,550},{300,150}},
  {{150,350},{575,150}}
};

int[][][] rightRoutines = {
  {{-100, 1300}}, 
  {{900, 150}, {1050, 350}}, 
  {{900, 550}, {900, 150}, {1050, 350}}, 
  {{650, 350}, {1050, 350}},
  {{900,150}, {900,550}},
  {{1050,350},{625,150}}
};

Target leftTarget = new Target(-100, -100, 40, true);
Target rightTarget = new Target(1300, -100, 40, true);

int sectionTimer, leftTimer, rightTimer; //start the right timer a half beat behind the left one (at 0) - setting at tbb doesnt work for some reason
int section = 0;
int phase = 0;
int leftStep = 0;
int rightStep = 0;
int grade, textX, textY, leftAlpha, rightAlpha; //text-variables

int m; //millis bitch
boolean updateStatus = false; //programming is a series of compromises and band-aid solutions - used to counter millis issue when sketch firsts loads
boolean endTimer = false;

void setup() {
  size(1200, 800, P3D);
  rightTimer = tpb/2; // delay
  // Sound Stuff
  minim = new Minim(this);
  song = minim.loadFile("left-shark-revenge_mixdown.mp3", 1024);
}      

void draw() {
  if (m >= 5000 && updateStatus==false) {
    rightTimer = rightTimer + (tpb/2); //MANUAL
    updateStatus = true;
  }
  background(0);
  m = millis(); //a milli a milli a a a a milli (timing)
  
  if (endTimer == false) { // if the show isnt over
  if (m - sectionTimer >= timeSection[section]) {   // move from phase to phase with a section timer
   if (section == timeSection.length-1 || section == leftRoutines.length-1 || section == rightRoutines.length-1) {
      section = 0;
    } else {
      section++;
    } //go to the next section
    if (phase == timeSection.length-1 || phase == leftRoutines.length-1 || phase == rightRoutines.length-1) {
      phase=0;
    } else {
      phase++;
    } // go to the next phase
    sectionTimer = m; // bump up the timer to the current time
    if (section == 3 || section == 5) {
      rightTimer = rightTimer+ (tpb/2); //MANUAL
    };
    //reset the stepper counter
    rightStep =0;
    leftStep =0;
  };
    //must come after section timer to prevent array issue
    doAnimation();
  if (m >= 500 && !song.isPlaying()) {
    song.play();
  }

  if (m >= 90000 && song.isPlaying()) { //pause the song if it is still playing after 1.5 minutes
    song.pause();
    endTimer = true;
  }

  if (leftAlpha > 0) {
    leftAlpha = leftAlpha-5;
  }

  if (rightAlpha > 0) {
    rightAlpha = rightAlpha-5;
  } 
  } else {fill(255);text("OVER",400,400);}
}   //end draw loop

void doAnimation() {
  if (m - leftTimer  >= tpb) { // if the time per beat has been reached (every tpb seconds)
    leftTimer = m; //update the timer
    //leftTimer = m - tpb/2; //update the timer
    leftAlpha = 255;
    leftTarget.move(leftRoutines[phase][leftStep][0], leftRoutines[phase][leftStep][1]); // move to the next step (x and y values)
    if (leftStep >= leftRoutines[phase].length-1) { //check if there is a step after this one, loop back to the first if not
      leftStep = 0;
    } else {
      leftStep++;
    };
  };
  leftTarget.display(abs(255-leftAlpha), "L"); 

  if (m - rightTimer  >= tpb) { // if the time per beat has been reached (every tpb seconds)
    rightTimer = m; //update the timer
    rightAlpha = 255;
    rightTarget.move(rightRoutines[phase][rightStep][0], rightRoutines[phase][rightStep][1]); // move to the next step (x and y values)
    if (rightStep >= rightRoutines[phase].length-1) { //check if there is a step after this one, loop back to the first if not
      rightStep = 0;
    } else {
      rightStep++;
    };
  };
  rightTarget.display(abs(255-rightAlpha), "R");
}
