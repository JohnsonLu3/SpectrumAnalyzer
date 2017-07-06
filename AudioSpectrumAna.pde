import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
float[] max = new float[bands];

boolean colorShift = true;

int bandWidth = 10;
int frameReset = 0;
int mouseCount = 0;
int types = 1;

int R = 156;
int G = 238;
int B = 191;

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
  
  if(colorShift){
    B++;
    G += 2;
  }else{
    B--;
    G -= 2;
  }
  
  if(B > 240){
    colorShift = false;
  }else if(B < 25){
    colorShift = true;
  }
  
  for(int i = 0; i < bands; i++){
    if(spectrum[i] > 0){
        if(mouseCount == 0){
          bars(i);
        }else{
          dualWave(i);
        }
    }
  }
  
  if(frameReset == 5){
    frameReset = 0;
    resetMax();
  }else{
    frameReset++;
  }
}

void mouseClicked(){
   if(mouseCount == types){
     mouseCount = 0;
   }else{
     mouseCount++;
   }
}

void bars(int i){
      noStroke();
      fill(R - (spectrum[i]*height*10), G + i*5, B - i*3);
      rect(i*bandWidth, height-spectrum[i], bandWidth, spectrum[i]*height*20*-1);
      stroke(R - (spectrum[i]*height*10), G + i*5, B - i*3);
      max(spectrum[i], i);
      line(i*bandWidth,height-max[i]*height*20, i*10 + bandWidth,height-max[i]*height*20);
}


void dualWave(int i){
      stroke(R - (spectrum[i]*height*10), G + i*5, B - i*3);
      line(width/2+i,height/2, width/2+i,height/2-spectrum[i]*height*20);
      line(width/2+i,height/2, width/2+i,height/2-spectrum[i]*height*20*-1);
      line(width/2-i,height/2, width/2-i,height/2-spectrum[i]*height*20);
      line(width/2-i,height/2, width/2-i,height/2-spectrum[i]*height*20*-1);
      

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