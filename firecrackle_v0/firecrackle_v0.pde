//Qs: loadPixel for video, pingpong for video, fft averaging on FUTURE samples of the audio

import processing.video.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Movie mov;

Minim minim;  
AudioPlayer song;
FFT fftLin;

PShader chroma;
PImage album;
float spectrumScale = 4;
float shaman;
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()

void setup() {
  size(535, 535, P2D);
  background(0);

  // Sound Stuff
  minim = new Minim(this);
  song = minim.loadFile("shy-ronnie.aif", 1024);
  song.loop();
  fftLin = new FFT( song.bufferSize(), song.sampleRate() );
  fftLin.linAverages( 30 );

  // Chroma Stuff
  chroma = loadShader("chroma.glsl");
  chroma.set("u_res", (float)width, (float)height);
  album=loadImage("album.jpg");
  chroma.set("u_tex", album);
  album.resize(width, height);

  // Movie Stuff
  mov = new Movie(this, "fire-frame-hq.mp4");
  mov.loop();
}

void draw() {  
  fftStuff();
  chromaKey();
}

void fftStuff() {
  // perform a forward FFT on the samples in song's mix buffer
  fftLin.forward( song.mix );
  shaman = fftLin.getAvg(20)*spectrumScale; // just picked a random low band
}


void movieEvent(Movie mov) {
  mov.read();
}

void chromaKey() {
  resetShader();
  shaman = map(shaman, 0, 20, 0, 255);
  colorMode(HSB, 255);
  tint(shaman, 255, 255);
  image(mov, 0, 0);
  noTint();
  shader(chroma);
  float HUE, SAT, BRI, 
    HUE_range, SAT_range, BRI_range, 
    yikes;
  // hsb values
  HUE=0.5;  
  SAT=0.80;  
  BRI=0.90;
  //hsb tolerances
  HUE_range=0.20;  
  SAT_range=0.60;  
  BRI_range=1.80;
  //experiment
  yikes=0.5;

  chroma.set("u_low", HUE-HUE_range, SAT-SAT_range, BRI-BRI_range);
  chroma.set("u_high", HUE+HUE_range, SAT+SAT_range, BRI+BRI_range);
  chroma.set("u_foo", yikes);
  rect(0, 0, width, height);
}