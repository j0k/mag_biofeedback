import ddf.minim.*;
//AudioPlayer player;
Minim minim;//audio context


class Music {
  
  String [] files;
  int cur = -1;
  public AudioPlayer player;
   
  Music(){
    files = new String[4];
    files[0] = "muz/0_alone.mp3";
    files[1] = "muz/1_birds_on_river.mp3";
    files[2] = "muz/2_summer_rain.mp3";
    files[3] = "muz/3_bodhi1.mp3";
    
    play();
  }
  
  void play(){
    if ((cur >= 0) && (cur < files.length)){
      println(files[cur]);
      player = minim.loadFile(files[cur], 2048);
      player.play();
    } else {
      println("MUSIC [play] break");
    }
  }
  
  void next(){ cur++;
    cur = cur % files.length;
    if (player != null){
      player.pause();
      player.close();
    }
    //play();
  }
  
  void loopthis(){}
  
  void display(){
    fill(200,200,255);
    rect(100,310,180,30);
    fill(0,0,0);
    if ((cur >= 0) && (cur < files.length)){
      textFont(font12,12);
      text( str(cur)  , 110, 330);
      text( files[cur], 120, 330);
    }
  }
}
