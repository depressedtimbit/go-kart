class screen{
  screen() { //basic stucture for our "screen" object
    
  }

  void update(float delta) {

  }
  
  void physicsStep() {
  
  }
  
  void draw() {
  
  }
  
  void draw3D() {
  
  }

  void keyPressed() {

  }

  void keyReleased() {

  }
  
  void attemptFinish() {
  
  }

}

class mainMenuScreen extends screen{ // main menu screen
  MenuButton startButton; //create values to hold our buttons
  MenuButton settingsButton;
  MenuButton editorButton;
  MenuButton quitButton;
  mainMenuScreen() {
    super();
    //create our menu using 3 menu buttons
    startButton = new MenuButton(new PVector(width * 0.10, height * 0.33), new PVector(width*0.30, height * (0.1)), "start", 40, color(#18DB26), color(#92DB97));
    settingsButton = new MenuButton(new PVector(width * 0.10, height * 0.44), new PVector(width*0.30, height * (0.1)), "settings", 40, color(#9B9B9B), color(#9B9B9B));
    editorButton = new MenuButton(new PVector(width * 0.10, height * 0.55), new PVector(width*0.30, height * (0.1)), "Level Editor", 40, color(#9B9B9B), color(#9B9B9B));
    quitButton = new MenuButton(new PVector(width * 0.10, height * 0.66), new PVector(width*0.30, height * (0.1)), "quit", 40, color(#18DB26), color(#92DB97));

  }
  
  void update(float delta) {
     //println(delta);
    if (startButton.checkWasPressed()) {  //check if start was pressed and change screen to our game
      screen newScreen = new gameScreen();
      changeScreen(newScreen);
    }

    if (editorButton.checkWasPressed()) {
      screen newScreen = new editorScreen();
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
    editorButton.draw();
    quitButton.draw(); 

  }
}

class editorScreen extends screen{ //unused
  EditorMode editorMode = EditorMode.WALL;
  String workingDirectory = "assets/map.json";
  editorScreen() {

  }

  void draw() {
    
  
    fill(155);
    textAlign(LEFT);
    textSize(12);
    text("Editor", 50, 50);
    textSize(10);
    text("x: " + mouseX + " y: " +mouseY, 60, 60);
    
    text("file: "+ workingDirectory, 60, 70);
    text("Mode: "+ editorMode, 60, 80);
    
  }

  
}

class winScreen extends screen{
  IntList recordTimes;
  MenuButton mainMenuButton;
  MenuButton quitButton;
  
  winScreen(int[] recordTimes) {
    mainMenuButton = new MenuButton(new PVector(width * 0.10, height * 0.33), new PVector(width*0.30, height * (0.1)), "Main Menu", 40, color(#18DB26), color(#92DB97));
    quitButton = new MenuButton(new PVector(width * 0.10, height * 0.44), new PVector(width*0.30, height * (0.1)), "quit", 40, color(#18DB26), color(#92DB97));
    this.recordTimes = new IntList();
    this.recordTimes.append(recordTimes);
    println("records; " +this.recordTimes);
  }

  void draw() {
    fill(255);
    textAlign(CORNER);
    text("Finish!", width * 0.10, height * 0.11); 
    recordTimes.sort();
    for (int i = 0; i < recordTimes.size(); i++) {
      text("#"+(i+1)+"  "+millisToStopWatch(recordTimes.get(i)), 650, 300+(25*i)); //draw each time in the records, coded like this to support multple karts
    }
    mainMenuButton.draw();
    quitButton.draw(); //draw our buttons
    
  }

   void update(float delta) {
     //println(delta);
    if (mainMenuButton.checkWasPressed()) {  //check if start was pressed and change screen to our game
      screen newScreen = new mainMenuScreen();
      changeScreen(newScreen);
    }

    if (quitButton.checkWasPressed()) {
      exit();  //check if exit was pressed and exit
    }
  } 

}


class gameScreen extends screen{ //game screen
  kart playerKart;
  wall[] walls = {
      new wall(new PVector(240, 450), new PVector(60, 2000), 0, color(#5A0505), WallType.WALL, -1), //manually define walls for now, this will be moved to a level editor soon
      new wall(new PVector(850+60, 450), new PVector(60, 2000), 0, color(#5A0505), WallType.WALL, -1),
      new wall(new PVector(560, 181-60), new PVector(2000, 60), 0, color(#5A0505), WallType.WALL, -1),
      new wall(new PVector(560, 650+60), new PVector(2000, 60), 0, color(#5A0505), WallType.WALL, -1),
      new wall(new PVector(300, 181), new PVector(60, 60), 0, color(#E3DC10), WallType.CHECKPOINT, 1),
      new wall(new PVector(850, 181), new PVector(60, 60), 0, color(#E3DC10), WallType.CHECKPOINT, 2),
      new wall(new PVector(850, 650), new PVector(60, 60), 0, color(#E3DC10), WallType.CHECKPOINT, 3),
      new wall(new PVector(300, 650), new PVector(60, 60), 0, color(#E3DC10), WallType.CHECKPOINT, 4),
      new wall(new PVector(300, 395), new PVector(60, 60), 0, color(#FAF9E1), WallType.FINISH, 5)
    };
  int StartingTimer;
  int raceTimer;
  String countdownText = "";
  boolean pauseMenu = false; //unused for now
  gameScreen() {
    super();
    playerKart = new kart(new PVector(300, 355), new PVector(10, 10), -HALF_PI); //init the player "kart" 
    playerKart.disabled = true; //stop the player from moving for now
    StartingTimer = millis(); //save our current time 
    

  }

  void update(float delta) {
    playerKart.update(delta); //update player
    for (int i = 0; i<walls.length; i++) {
      walls[i].onCollide(playerKart); //check each wall if they player is colliding
    }
  }
  
  void physicsStep() {
    playerKart.physicsStep();
  }
  

  void draw() {
    fill(155);
    for (int i = 0; i<walls.length; i++) {
      walls[i].draw(); //draw each wall
    }
    playerKart.draw(); //draw the player "kart"
    text("Game", 50, 50);
    textSize(10);
    text("x: " + mouseX + " y: " +mouseY, 60, 60); //print various info to the screen
    textSize(24);
    text("lap: " + playerKart.finishedlaps + " /3 ", width/2, height/9);
    
    
    textSize(24);
    
    
    if (millis() - StartingTimer > 5000) { //check if a certain amount of time has passed
      countdownText = ""; // hide the countdown
    }
    else if (millis() - StartingTimer > 4000) {
      countdownText = "go!"; //go! enable the players kart 
      playerKart.disabled = false;
    }
    else if (millis() - StartingTimer > 3000) {
      countdownText = "1";
      raceTimer = millis(); //race timer starts the frame before the player is enabled
    }
    else if (millis() - StartingTimer > 2000) {
      countdownText = "2";
    }
    else if (millis() - StartingTimer > 1000) {
      countdownText = "3";
    }
    
    text(countdownText, width/2, height/2);

    

    if (!playerKart.disabled) {
      text(millisToStopWatch((millis() - raceTimer)), width/2, height/7); //display how long the race has been going if the player is enabled
    }
    
  }

   void keyPressed() {
      playerKart.keyPressed(); //call key pressed on the player "kart"
  }

  void keyReleased() {
      playerKart.keyReleased(); //call key Released on the player "kart"
  }

  void attemptFinish() {
    if (playerKart.finishedlaps > 2) {
      changeScreen(new winScreen(new int[] {(millis() - raceTimer)})); //change to the winScreen and feed it our time
    }
  }

  void loadMap() { //unused for now

  }
}
