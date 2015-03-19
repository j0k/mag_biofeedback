RectButton mute, unmute;

color button_color = color(200,200,230);
color button_color_over =  color(150,180,240);

void gui_create(){
 mute = new RectButton(20, 20, 80, 30, "mute", button_color, button_color_over);
 unmute = new RectButton(110, 20, 80, 30, "unmute", button_color, button_color_over);
} 

void gui_display(){
 mute.display();
 unmute.display();
} 

void update_gui(int x, int y ){
  if(locked == false) {
    mute.update();
    unmute.update();
  } 
  else {
    locked = false;
  }
  
  if(mousePressed) {
    if(mute.pressed()) {
      player.mute();
    }
    else if (unmute.pressed()){
      player.unmute();
    }
  }
}
