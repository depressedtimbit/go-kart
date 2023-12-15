class screen{
  screen() { //basic stucture for our "screen" object
    
  }

  void update(float delta) {

  }
  
  void physicsStep(float delta) {
  
  }
  
  void draw(PGraphics graphics) {
  
  }
  
  void draw3D(PGraphics graphics) {
  
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

  void draw(PGraphics graphics) {
    graphics.fill(255);
    graphics.textAlign(CORNER);
    graphics.text("Main Menu", width * 0.10, height * 0.11); //draw a main menu logo
    graphics.textSize(30);
    graphics.text("Use forward arrow to accelerate your kart,\n back to break,\n left and right to steer\n use the mouse to interact with menus\n game may be unstable, restart if it freezes", width * 0.40, height * 0.51);
    startButton.draw(graphics);
    settingsButton.draw(graphics); //draw our buttons
    editorButton.draw(graphics);
    quitButton.draw(graphics); 
  }
}
class editorScreen extends screen{ //unused
  EditorMode editorMode = EditorMode.WALL;
  String workingDirectory = "assets/map.json";
  editorScreen() {

  }
  /*
  void draw() {
    
  
    fill(155);
    textAlign(LEFT);
    textSize(12);
    text("Editor", 50, 50);
    textSize(10);
    text("x: " + mouseX + " y: " +mouseY, 60, 60);
    
    text("file: "+ workingDirectory, 60, 70);
    text("Mode: "+ editorMode, 60, 80);
    
  }*/

  
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

  void draw(PGraphics graphics) {
    graphics.fill(255);
    graphics.textAlign(CORNER);
    graphics.text("Finish!", width * 0.10, height * 0.11); 
    recordTimes.sort();
    for (int i = 0; i < recordTimes.size(); i++) {
      text("#"+(i+1)+"  "+millisToStopWatch(recordTimes.get(i)), 650, 300+(25*i)); //draw each time in the records, coded like this to support multple karts
    }
    mainMenuButton.draw(graphics);
    quitButton.draw(graphics); //draw our buttons
    
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
  wall[] walls = { //skill #33 //skill #35
      new wall(new PVector(240, 450), new PVector(60, 700), 0, color(#5A0505), WallType.WALL, -1), //manually define walls // skill #29
      new wall(new PVector(850+60, 450), new PVector(60, 700), 0, color(#5A0505), WallType.WALL, -1),
      new wall(new PVector(560, 181-60), new PVector(700, 60), 0, color(#5A0505), WallType.WALL, -1),
      new wall(new PVector(560, 650+60), new PVector(700, 60), 0, color(#5A0505), WallType.WALL, -1),
      new wall(new PVector(570, 410), new PVector(500, 430), 0, color(#5A0505), WallType.WALL, -1),
      new wall(new PVector(300, 181), new PVector(60, 60), 0, color(#FF0000), WallType.CHECKPOINT, 1),
      new wall(new PVector(850, 181), new PVector(60, 60), 0, color(#FF0000), WallType.CHECKPOINT, 2),
      new wall(new PVector(850, 650), new PVector(60, 60), 0, color(#FF0000), WallType.CHECKPOINT, 3),
      new wall(new PVector(300, 650), new PVector(60, 60), 0, color(#FF0000), WallType.CHECKPOINT, 4),
      new wall(new PVector(300, 395), new PVector(60, 60), 0, color(#FAF9E1), WallType.FINISH, 5)
    };
  int StartingTimer;
  int raceTimer; //skill #44
  String countdownText = ""; 
  boolean pauseMenu = false; //unused for now
  Box grass;
  gameScreen() {
    super();
    playerKart = new kart(new PVector(300, 355), new PVector(10, 10), -HALF_PI); //init the player "kart" 
    playerKart.disabled = true; //stop the player from moving for now
    StartingTimer = millis(); //save our current time 
    grass = new Box (width, height, 1);
    grass.moveTo(width/2, height/2, -10); //create basic grass object as a floor
    grass.drawMode(S3D.SOLID);
    grass.fill(#3BC91C);
    

  }

  void update(float delta) {
    playerKart.update(delta); //update player
    for (int i = 0; i<walls.length; i++) {// skill #17
      walls[i].onCollide(playerKart, delta); //check each wall if they player is colliding
    }
  }
  
  void physicsStep(float delta) {
    playerKart.physicsStep(delta);
  }
  

  void draw(PGraphics graphics) {
    graphics.pushMatrix();
    graphics.translate(width * 0.8, height * 0.8);
    graphics.scale(0.1, 0.1);
    graphics.fill(155);

    for (int i = 0; i<walls.length; i++) {
      walls[i].draw(graphics); //draw each wall
    }
    playerKart.draw(graphics); //draw the player "kart"
    graphics.popMatrix();
    //graphics.text("Game", 50, 50);
    graphics.textSize(10);
    //graphics.text("x: " + mouseX + " y: " +mouseY, 60, 60); //print various info to the screen
    graphics.textSize(24);
    graphics.text("lap: " + playerKart.finishedlaps + " /3 ", width/2, height/9);
    
    
    graphics.textSize(24);
    
    
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
    
    graphics.text(countdownText, width/2, height/2);

    

    if (!playerKart.disabled) {
      graphics.text(millisToStopWatch((millis() - raceTimer)), width/2, height/7); //display how long the race has been going if the player is enabled
    }
    
  }

  void draw3D(PGraphics graphics) {
    graphics.lights(); //enable lights
    graphics.ambientLight(50, 50, 50); //add some ambient light
    graphics.background(#1C71C9); //set the background
    float cameraZ = ((height/2.0) / tan(PI*60.0/360.0)); //used for camera clip planes
    graphics.perspective(70, width/height, cameraZ/50.0, cameraZ*10.0); //set camera FOV and near clip plane 
    graphics.camera(
      playerKart.pos.x-50 * cos(playerKart.rot), //set camarea position to just behind the player
      playerKart.pos.y-50 * sin(playerKart.rot),
      20, //with a constant height
      playerKart.pos.x, //set the camera look towards the player
      playerKart.pos.y,
      10, //with constant height
       0, 0, -1 //set the cameras up vectors
    );
    for (int i = 0; i<walls.length; i++) {
      walls[i].draw3D(graphics); //draw each wall
    }
    playerKart.draw3D(graphics); //draw the player
    grass.draw(graphics); //draw the grass
  }

   void keyPressed() {
      playerKart.keyPressed(); //call key pressed on the player "kart"
  }

  void keyReleased() {
      playerKart.keyReleased(); //call key Released on the player "kart"
  }

  void attemptFinish() { //skill #20
    if (playerKart.finishedlaps > 2) {
      changeScreen(new winScreen(new int[] {(millis() - raceTimer)})); //change to the winScreen and feed it our time
    }
  }

  void loadMap() { //unused for now

  }
}
