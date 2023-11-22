class screen{
  screen() {
    
  }

  void update(float delta) {

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
    settingsButton = new MenuButton(new PVector(width * 0.10, height * 0.44), new PVector(width*0.30, height * (0.1)), "settings", 40, color(#18DB26), color(#92DB97));
    quitButton = new MenuButton(new PVector(width * 0.10, height * 0.55), new PVector(width*0.30, height * (0.1)), "quit", 40, color(#18DB26), color(#92DB97));

  }
  
  void update(float delta) {
     println(delta);
     if (startButton.checkWasPressed()) {
      screen newScreen = new gameScreen();
      changeScreen(newScreen);
    }

    if (quitButton.checkWasPressed()) {
      exit(); 
    }

  } 

  void draw() {
    fill(255);
    textAlign(CORNER);
    text("Main Menu", width * 0.10, height * 0.11);
    startButton.draw();
    settingsButton.draw();
    quitButton.draw();

  }
}

class gameScreen extends screen{
  kart playerKart;
  gameScreen() {
    super();
    playerKart = new kart(new PVector(width/2, height/2), new PVector(0, 0));
  }

  void draw() {
    fill(155);
    playerKart.draw();
    text("Game", 50, 50);
  }

}
