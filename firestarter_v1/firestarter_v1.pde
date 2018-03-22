/**
 * Speed. 
 *
 * Use the Movie.speed() method to change
 * the playback speed.
 * 
 */

import processing.video.*;

Movie mov;

PShader chroma;
PImage album;

void setup() {
 size(535,535,P2D);
 chroma = loadShader("chroma.glsl");
  chroma.set("u_res",(float)width,(float)height);
  album=loadImage("album.jpg");
   chroma.set("u_tex",album);
 album.resize(width,height);
  background(0);
  mov = new Movie(this, "fire-frame-hq.mp4");
  mov.loop();
}

void movieEvent(Movie mov) {
  mov.read();  
}

void draw() {   
  resetShader();
  float shaman = map(mouseX, 0, width, 0, 255);
  float human = map(mouseX, 0, width, 0, 1);
  colorMode(HSB, 255);
  tint(shaman,255,255);
  image(mov, 0, 0);
  noTint();
    shader(chroma);
      float HUE,SAT,BRI,
        HUE_range,SAT_range,BRI_range,
        yikes;
  // hsb values
  HUE=(human);  SAT=0.80;  BRI=0.90;
  //hsb tolerances
  HUE_range=0.10;  SAT_range=0.60;  BRI_range=1.80;
  //experiment
  yikes=0.5;
  
  chroma.set("u_low",HUE-HUE_range,SAT-SAT_range,BRI-BRI_range);
  chroma.set("u_high",HUE+HUE_range,SAT+SAT_range,BRI+BRI_range);
  chroma.set("u_foo",yikes);
  rect(0,0,width,height);
  println(HUE);
}