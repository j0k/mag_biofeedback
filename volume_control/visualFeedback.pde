float volume; // 0 - 100

int trans(float volume, float down, float top){
  return round ( down + volume * (top-down)/100 );
}

void update_feedback(){
  int x0 =0;
  int y0 = 70;
  fill(255);
  rect(20 + x0, y0,200,200);
  fill(color(trans(volume,100,255), trans(volume,100,150), trans(volume,200,255)));
  rect(30 + x0, y0+10,180,180);
  
}

void setVolume(float value){
  volume = value;
  
  float gainVol = gainToVolume(value/100);
  music.player.setGain(gainVol);
  println(gainVol);
}
