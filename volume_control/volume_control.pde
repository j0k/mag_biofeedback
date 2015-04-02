import processing.net.*; 

Client myClient; 

int dataIn; 
JSONObject json;

float ms = 0, client_ms;

Music music = new Music();
void setup() { 
  size(350, 600);
  
  minim = new Minim(this);
  
  myClient = new Client(this, "127.0.0.1", 19999);
 
  music.next();
  music.play();
  println(music.player.getControls());
  ms = millis();
  client_ms = millis();
 
  gui_create();
} 
 
boolean tcpPlaying = false;



void draw() {
  
  if (myClient.available() > 0) { 
     background(255, 224, 170); 
  }
  
  update(mouseX, mouseY);
 
  gui_display();
  
  if (myClient.available() > 0) {
    ms = millis();
    client_ms = ms;
    String message = myClient.readStringUntil('\n');
    
    if (message != null){
      println(message);
      tcpPlaying = true;
      
      saveStrings("obj.json", split(message, '\n'));
       try{
         json = loadJSONObject("obj.json");
         String op = json.getString("command");
         
         println("Command: " + op);
         if (op.equals("setVolume")){
           float value = json.getInt("value");
           println("Volume: " + value);
           
           setVolume(value); 
           
         }
       }
       catch(Exception e){
         println("jsonload - fail");
       }
    }
  } 

  if (millis() - ms > 1000){
    try{
      if (millis() - client_ms > 1000){
        client_ms = millis();
        //reconnect
        //myClient = new Client(this, "127.0.0.1", 19999);
      }
    } catch (Exception e){
    }
  } else {
    
  }
  
 
}
void update(int x, int y)
{
  update_gui(x,y);
  update_feedback();
}

void stop()
{
  music.player.close();
  minim.stop();
  super.stop();
}


