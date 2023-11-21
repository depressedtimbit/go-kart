
screen CurrentScreen;

void setup () {
  size(1000, 800);
  CurrentScreen = new mainMenuScreen();
}

void draw() {
  background(0);
  CurrentScreen.draw3D();
  CurrentScreen.draw();
  
  
}

void changeScreen(screen CurrentScreen) {
  this.CurrentScreen = CurrentScreen;
}
