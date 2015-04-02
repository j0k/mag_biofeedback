RectButton mute, unmute;
RectButton nextPlayBtn;

color button_color = color(200,200,230);
color button_color_over =  color(150,180,240);
color button_color_nextplay =  color(250,180,140);

void gui_create(){
 mute = new RectButton(20, 20, 80, 30, "mute", button_color, button_color_over);
 unmute = new RectButton(110, 20, 80, 30, "unmute", button_color, button_color_over);
 nextPlayBtn = new RectButton(20, 310, 80, 30, "playnext", button_color_nextplay, button_color_over);
} 

void gui_display(){
 mute.display();
 unmute.display();
 music.display();
 
 nextPlayBtn.display();
} 

void update_gui(int x, int y ){
  if(locked == false) {
    mute.update();
    unmute.update();
    nextPlayBtn.update();
  } 
  else {
    locked = false;
  }
  
  
  
  if(mousePressed) {
    if(mute.pressed()) {
      music.player.mute();
    }
    else if (unmute.pressed()){
      music.player.unmute();
    }
    else if (nextPlayBtn.pressed()){
      music.next();
      music.play();
    }
  }
}
