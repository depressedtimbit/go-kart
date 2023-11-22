
screen CurrentScreen;

float delta;
long time;

void setup () {
  size(1000, 800);
  CurrentScreen = new mainMenuScreen();
  time = millis();
}

void draw() {
  background(0);
  long currentTime = millis();

  delta = (currentTime - time) * 0.001f;
  
  CurrentScreen.update(delta);  
  CurrentScreen.draw3D();
  CurrentScreen.draw();
  
  time = currentTime;
}

void changeScreen(screen CurrentScreen) {
  this.CurrentScreen = CurrentScreen;
}
