class wall{
  PVector pos;
  PVector[] polyPoints;
  float rot;
  
  color wallColor;
  WallType wallType;
  int id;
  
  wall(PVector pos, PVector bbBoxSize, float rot, color wallColor, WallType wallType, int id) {
      this.pos = pos;
      this.rot = rot;
      this.wallColor = wallColor;
      this.wallType = wallType;
      this.id = id;
      polyPoints = bbBoxToPoints(bbBoxSize); //convert the bbBoxSize to points
  }



  void draw() {
    pushMatrix();
    translate(pos.x, pos.y); //translate and rotate to the walls position
    rotate(rot);
    fill(wallColor);
    beginShape();
    for (PVector poly : polyPoints) {
      vertex(poly.x, poly.y); //draw all our points
    }
    endShape(CLOSE);
    popMatrix();
    
    if (DEBUG) { //draw debug lines
      PVector[] convertedPoints = pointsToScreenPoints(polyPoints, pos, rot);

      
      stroke(0, 255, 255);
      beginShape();
      for (PVector poly : convertedPoints) {
        vertex(poly.x, poly.y);
      }
      endShape(CLOSE);
      noStroke();

    }
  }

  void draw3D() {


  }

  void onCollide(kart collidedKart) {
    if (!KartWallCol(collidedKart.pos, collidedKart.bbBoxSize, collidedKart.rot, polyPoints, pos, rot)) { //check if we're colliding 
      
      return;
    }

    switch (wallType) {
      case WALL: //if the wall is type WALL, a solid wall
        PVector kartDirection = new PVector(1, 0);
        kartDirection.rotate(collidedKart.rot);

        PVector kart2wall = collidedKart.pos.copy().sub(pos).normalize(); 

        float kartDot = kart2wall.dot(kartDirection); //use the dot produt to check if the kart is facing towards the centre of the wall

        println("dot: ", kartDot);

        if (kartDot < 0) { //if we're facing toward the centre of the wall dont allow the player to move forward, only turn
          collidedKart.vel = 0;
          collidedKart.blocked = true; 
        }
        else {
          collidedKart.blocked = false;
        }
        break;
      case CHECKPOINT: //if the wall is type CHECKPOINT, players must reach all checkpoints in order before they can win 1 lap
        if (collidedKart.checkedPoints.hasValue(id)) {return;} //check if we already reached the checkpoint
        if (!collidedKart.checkedPoints.hasValue(id-1)) {return;} //check if we havent reached the last checkpoint
        
        collidedKart.checkedPoints.append(id); //append ourselfs
        break;
      case FINISH: //if the wall is type CHECKPOINT, allows players to finish a lap or win the race
        if (!collidedKart.checkedPoints.hasValue(id-1)) {return;} //check if we havent reached the last checkpoint
        collidedKart.finishedlaps++; // add 1 to the karts finished laps
        collidedKart.checkedPoints = new IntList(); //reset their checkpoints
        collidedKart.checkedPoints.append(0); 
        CurrentScreen.attemptFinish(); //check if the race is over
    }
  }
  
  boolean KartWallCol(PVector kartPos, PVector kartBoxSize, float kartRot, PVector[] points, PVector pos, float rot) {
      PVector[] kartPoints = bbBoxToPoints(kartBoxSize); //convert the bbBox to points
      
      PVector[] kartConvertedPoints = pointsToScreenPoints(kartPoints, kartPos, kartRot); //convert our karts points to screen points
      PVector[] convertedPoints = pointsToScreenPoints(points, pos, rot); //convert our walls points to screen points
    

      if (!polyPoly(convertedPoints, kartConvertedPoints)) { //check if they're colliding
        return false;
      }
      return true;
  }
}
