screen CurrentScreen;

float delta;
long time;

boolean DEBUG = false;
int doubleClickTimer = millis();;


enum WallType { WALL, CHECKPOINT, FINISH } //define wall types

enum EditorMode { WALL, CHECKPOINT, FINISH, PLAYERPOS, ERASE, IDSET} //unused for now, used for the level making tool

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

String millisToStopWatch(int millisTime) { //converts milliseconds to a human readable time
  
  String millise = str(millisTime % 1000); //only show remainder of /1000
  while (millise.length() < 3) {
    millise = '0' + millise; // make sure to at least show 000
  }
  String seconds = str((millisTime / 1000) % 60); //devide by 1000(milliseconds per second), only show remainder of /60
  while (seconds.length() < 2) {
    seconds = '0' + seconds; // make sure to at least show 00
  }
  String minutes = str(((millisTime / (1000*60)) % 60)); //devide by 1000*60(milliseconds per minute) only show remainder of /60
  while (minutes.length() < 2) {
    minutes = '0' + minutes; // make sure to at least show 00
  } 
  
  return "00:"+minutes+":"+seconds+":"+millise; //combine and add a fake hour slot (i doubt anyone is going to take an hour to finish 3 laps)
}

PVector[] bbBoxToPoints(PVector bbBox) { //convert a bbBox values (which is a PVector) to a list of points
  PVector[] newPolyPoints = {
        new PVector(-bbBox.x/2, -bbBox.y/2),
        new PVector(bbBox.x/2, -bbBox.y/2),
       new PVector(bbBox.x/2, bbBox.y/2),
        new PVector(-bbBox.x/2, bbBox.y/2)
  };
  return newPolyPoints;
}

PVector[] pointsToScreenPoints(PVector[] points, PVector pos, float rot) { //convert a points to screen points at a given position and rotation
  PVector[] screenPoints = new PVector[points.length];
  pushMatrix();
  translate(pos.x, pos.y);
  rotate(rot);
  for (int i=0; i < points.length; i++) {
    screenPoints[i] = new PVector(
      screenX(points[i].x, points[i].y),
      screenY(points[i].x, points[i].y)
    );
  }
  
  popMatrix();
  return screenPoints;
}


// POLYGON/POLYGON || from https://www.jeffreythompson.org/collision-detection/poly-poly.php
boolean polyPoly(PVector[] p1, PVector[] p2) {

  // go through each of the vertices, plus the next
  // vertex in the list
  int next = 0;
  for (int current=0; current<p1.length; current++) {
 
    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == p1.length) next = 0;

    // get the PVectors at our current position
    // this makes our if statement a little cleaner
    PVector vc = p1[current];    // c for "current"
    PVector vn = p1[next];       // n for "next"

    // now we can use these two points (a line) to compare
    // to the other polygon's vertices using polyLine()
    boolean collision = polyLine(p2, vc.x,vc.y,vn.x,vn.y);
    if (collision) return true;

    // optional: check if the 2nd polygon is INSIDE the first
    collision = polyPoint(p1, p2[0].x, p2[0].y);
    if (collision) return true;
  }

  return false;
}

// POLYGON/LINE
boolean polyLine(PVector[] vertices, float x1, float y1, float x2, float y2) {

  // go through each of the vertices, plus the next
  // vertex in the list
  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // extract X/Y coordinates from each
    float x3 = vertices[current].x;
    float y3 = vertices[current].y;
    float x4 = vertices[next].x;
    float y4 = vertices[next].y;

    // do a Line/Line comparison
    // if true, return 'true' immediately and
    // stop testing (faster)
    boolean hit = lineLine(x1, y1, x2, y2, x3, y3, x4, y4);
    if (hit) {
      return true;
    }
  }

  // never got a hit
  return false;
}

// LINE/LINE
boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the direction of the lines
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    return true;
  }
  return false;
}

// POLYGON/POINT
// used only to check if the second polygon is
// INSIDE the first
boolean polyPoint(PVector[] vertices, float px, float py) {
  boolean collision = false;

  // go through each of the vertices, plus the next
  // vertex in the list
  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // this makes our if statement a little cleaner
    PVector vc = vertices[current];    // c for "current"
    PVector vn = vertices[next];       // n for "next"

    // compare position, flip 'collision' variable
    // back and forth
    if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) &&
         (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
            collision = !collision;
    }
  }
  return collision;
}
