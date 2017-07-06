import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
float[] max = new float[bands];
int bandWidth = 10;
int frameReset = 0;

void setup() {
  size(1080, 500);
  background(15);
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);

  in.start();

  fft.input(in);

  for(int i =0; i < bands; i++){
    max[i] = 0;
  }
}      

void draw() { 
  background(15);
  fft.analyze(spectrum);

  for(int i = 0; i < bands; i++){
    if(spectrum[i] > 0){
      noStroke();
      fill(156 - (spectrum[i]*height*10), 238 + i*5, 191 - i*3);
      rect(i*bandWidth, height-spectrum[i], bandWidth, spectrum[i]*height*20*-1);
      stroke(156 - (spectrum[i]*height*10), 238 + i*5, 191 - i*3);
      max(spectrum[i], i);
      line(i*bandWidth,height-max[i]*height*20, i*10 + bandWidth,height-max[i]*height*20);
    }
  }
  
  if(frameReset == 5){
    frameReset = 0;
    resetMax();
  }else{
    frameReset++;
  }
}

void max(float spec, int i){
  spec = abs(spec);
  
  if(spec > max[i]){
    max[i] = spec;
  }
}

void resetMax(){
    for(int i =0; i < bands; i++){
      max[i] = 0;
    }
}