// http://processingjs.org/learning/topic/buttons/
boolean locked = false;
PFont font = createFont("Arial",16,true);
PFont font12 = createFont("Arial",12,true);

boolean over() 
  { 
    return true; 
  }
  
class Button
{
  int x, y;
  int size,sizeY;
  
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;
  String  label= "";  

  float pressedtime = 0;
  void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    float t = millis();
    
    if ((t - pressedtime) > 100){
      pressedtime = millis();
      
      if(over) {
        locked = true;
        return true;
      } 
      else {
        locked = false;
        return false;
      }    
    } else 
    return false;
  }

  boolean over() 
  { 
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }
}

class CircleButton extends Button
{ 
  CircleButton(int ix, int iy, int isize, String itext, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    label = itext;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    ellipse(x, y, size, size);
    fill(0);
    textFont(font,16);   
    text(label, x-size/2 + 8, y);
    
  }
}

class RectButton extends Button
{
  RectButton(int ix, int iy, int isize, int isizeY, String itext, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    sizeY = isizeY;
    label = itext;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overRect(x, y, size, sizeY) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    rect(x, y, size, sizeY);
    fill(0);
    textFont(font,16);   
    text(label, x+8, y+20);
  }
}
