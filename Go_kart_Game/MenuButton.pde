class MenuButton{
  PVector buttonPos;
  PVector buttonSize;
  String buttonText;
  color buttonColor;
  color buttonColorHover;
  int buttonTextSize;
  boolean buttonHovered = false;
  
  
  MenuButton(PVector buttonPos, PVector buttonSize, String buttonText, int buttonTextSize, color buttonColor, color buttonColorHover) {
    this.buttonPos = buttonPos;
    this.buttonSize = buttonSize;
    this.buttonText = buttonText;
    this.buttonTextSize = buttonTextSize;
    this.buttonColor = buttonColor;
    this.buttonColorHover = buttonColorHover;
    
  }
  
  boolean checkMouseHovered() { //check if the mouse is inside our button
    if  (
        mouseX < buttonPos.x ||
        mouseX > buttonSize.x+buttonPos.x ||
        mouseY < buttonPos.y ||
        mouseY > buttonSize.y+buttonPos.y) {
          return false;
        }
      return true;
    }
    
  boolean checkWasPressed() {
    if (millis() - doubleClickTimer < 250) { //check if its been more than 250 milliseconds since a button was last used
      return false;
    }
    if (!checkMouseHovered()) { //check if the mouse is inside
      return false;
    }
    if (!(mousePressed && (mouseButton == LEFT))) { //and the left mouse button is pressed
      return false;
    }
    
    doubleClickTimer = millis(); //set the last time we clicked a button
    return true;
    
  }
  
  void draw(PGraphics graphics) {
    color colorToDraw = this.buttonColor;
    if (checkMouseHovered() || buttonHovered) {
          colorToDraw = this.buttonColorHover; //if the mouse button is being hovered, change the colour we're about to draw
        }
    graphics.fill(colorToDraw); //skill #2
    graphics.rectMode(CORNER); //skill #3
    graphics.rect(buttonPos.x, buttonPos.y, buttonSize.x, buttonSize.y); //skill #1
    graphics.textSize(buttonTextSize);
    graphics.textAlign(CENTER);
    graphics.fill(0);
    graphics.text(buttonText, buttonPos.x + (buttonSize.x/2), buttonPos.y + (buttonSize.y/2));
  }
}
