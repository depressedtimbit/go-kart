class screen{
  screen() { //basic stucture for our "screen" object
    
  }

  void update(float delta) {

  }
  
  void draw() {
  
  }
  
  void draw3D() {
  
  }

  void keyPressed() {

  }

  void keyReleased() {

  }


}

class mainMenuScreen extends screen{ // main menu screen
  MenuButton startButton; //create values to hold our buttons
  MenuButton settingsButton;
  MenuButton quitButton;
  mainMenuScreen() {
    super();
    //create our menu using 3 menu buttons
    startButton = new MenuButton(new PVector(width * 0.10, height * 0.33), new PVector(width*0.30, height * (0.1)), "start", 40, color(#18DB26), color(#92DB97));
    settingsButton = new MenuButton(new PVector(width * 0.10, height * 0.44), new PVector(width*0.30, height * (0.1)), "settings", 40, color(#18DB26), color(#92DB97));
    quitButton = new MenuButton(new PVector(width * 0.10, height * 0.55), new PVector(width*0.30, height * (0.1)), "quit", 40, color(#18DB26), color(#92DB97));

  }
  
  void update(float delta) {
     //println(delta);
     if (startButton.checkWasPressed()) {  //check if start was pressed and change screen to our game
      screen newScreen = new gameScreen();
      changeScreen(newScreen);
    }

    if (quitButton.checkWasPressed()) {
      exit();  //check if exit was pressed and exit
    }
  } 

  void draw() {
    fill(255);
    textAlign(CORNER);
    text("Main Menu", width * 0.10, height * 0.11); //draw a main menu logo
    startButton.draw();
    settingsButton.draw(); //draw our buttons
    quitButton.draw(); 

  }
}

class gameScreen extends screen{ //game screen
  kart playerKart;
  boolean pauseMenu = false; //unused for now
  gameScreen() {
    super();
    playerKart = new kart(new PVector(width/2, height/2), new PVector(0, 0)); //init the player "kart" in the centre of the screen
  }

  void draw() {
    fill(155);
    playerKart.draw(); //draw the player "kart"
    text("Game", 50, 50);
  }

   void keyPressed() {
      playerKart.keyPressed(); //call key pressed on the player "kart"
  }

  void keyReleased() {
      playerKart.keyReleased(); //call key Released on the player "kart"
  }
}
