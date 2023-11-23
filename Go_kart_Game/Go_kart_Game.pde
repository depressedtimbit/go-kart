screen CurrentScreen;


float delta;
long time;

void setup () {
  size(1000, 800); //set our game size
  CurrentScreen = new mainMenuScreen(); //init current screen with our main menu
  time = millis(); //used for delta
}

void draw() {
  background(0);
  long currentTime = millis();

  delta = (currentTime - time) * 0.001f; //get our current delta time (time since our last frame) to use for physics
  
  CurrentScreen.update(delta); // call update on our current screen, gives delta, and is called before any drawing
  CurrentScreen.draw3D(); // call draw3D on our current screen, used to draw 3D graphics 
  CurrentScreen.draw();// call draw, used for GUIs and huds
  
  time = currentTime; //set our last delta
}

void keyPressed() {
    CurrentScreen.keyPressed(); //pass key pressed
}

void keyReleased() {
    CurrentScreen.keyReleased(); //pass key released
}

void changeScreen(screen CurrentScreen) {
  this.CurrentScreen = CurrentScreen; //change our current screen
}
