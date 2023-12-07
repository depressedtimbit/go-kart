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
  
  boolean checkMouseHovered() {
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
    if (millis() - doubleClickTimer < 250) {
      return false;
    }
    if (!checkMouseHovered()) {
      return false;
    }
    if (!(mousePressed && (mouseButton == LEFT))) {
      return false;
    }
    
    doubleClickTimer = millis();
    return true;
    
  }
  
  void draw(PGraphics graphics) {
    color colorToDraw = this.buttonColor;
    if (checkMouseHovered() || buttonHovered) {
          colorToDraw = this.buttonColorHover;
        }
    graphics.fill(colorToDraw);
    graphics.rectMode(CORNER);
    graphics.rect(buttonPos.x, buttonPos.y, buttonSize.x, buttonSize.y);
    graphics.textSize(buttonTextSize);
    graphics.textAlign(CENTER);
    graphics.fill(0);
    graphics.text(buttonText, buttonPos.x + (buttonSize.x/2), buttonPos.y + (buttonSize.y/2));
  }
}
