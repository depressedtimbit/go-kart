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
    if (!checkMouseHovered()) {
      return false;
    }
    if (!(mousePressed && (mouseButton == LEFT))) {
      return false;
    }
    
    return true;
  }
  
  void draw() {
    color colorToDraw = this.buttonColor;
    if (checkMouseHovered() || buttonHovered) {
          colorToDraw = this.buttonColorHover;
        }
    fill(colorToDraw);
    rectMode(CORNER);
    rect(buttonPos.x, buttonPos.y, buttonSize.x, buttonSize.y);
    textSize(buttonTextSize);
    textAlign(CENTER);
    fill(0);
    text(buttonText, buttonPos.x + (buttonSize.x/2), buttonPos.y + (buttonSize.y/2));
  }
}
