class screen{
  screen() {
    
  }
  
  void draw() {
  
  }
  
  void draw3D() {
  
  }

}

class mainMenuScreen extends screen{
  MenuButton startButton;
  MenuButton settingsButton;
  MenuButton quitButton;
  mainMenuScreen() {
    super();
    
    startButton = new MenuButton(new PVector(width * 0.10, height * 0.33), new PVector(width*0.30, height * (0.1)), "start", 40, color(#18DB26), color(#92DB97));
    settingsButton = new MenuButton(new PVector(width * 0.10, height * 0.44), new PVector(width*0.30, height * (0.1)), "start", 40, color(#18DB26), color(#92DB97));
    quitButton = new MenuButton(new PVector(width * 0.10, height * 0.44), new PVector(width*0.30, height * (0.1)), "start", 40, color(#18DB26), color(#92DB97));
    
    
    
    
  }
  
  void draw() {
    fill(255);
    text("Main Menu", 50, 50);
    startButton.draw();
    
    settingsButton.draw();
    
    if (startButton.checkWasPressed()) {
      screen newScreen = new gameScreen();
      
      changeScreen(newScreen);
    
    }
  }

}

class gameScreen extends screen{
  gameScreen() {
    super();
  }

  void draw() {
    fill(155);
    text("Game", 50, 50);
  }

}
