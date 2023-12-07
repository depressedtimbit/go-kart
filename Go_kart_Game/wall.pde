class wall{
  PVector pos;
  PVector[] polyPoints;
  float rot;
  
  color wallColor;
  WallType wallType;
  int id;

  Box shape3D;
  
  wall(PVector pos, PVector bbBoxSize, float rot, color wallColor, WallType wallType, int id) {
      this.pos = pos;
      this.rot = rot;
      this.wallColor = wallColor;
      this.wallType = wallType;
      this.id = id;
      polyPoints = bbBoxToPoints(bbBoxSize); //convert the bbBoxSize to points
      
      shape3D = new Box (bbBoxSize.x, bbBoxSize.y, 20); //create a box with a height of 20, and the given size

      switch (wallType) {
        case CHECKPOINT:
          shape3D.visible(false, S3D.ALL); //if checkpoint type, disable visiblity 
          break;
        case FINISH:
          shape3D = new Box (bbBoxSize.x, bbBoxSize.y, 5); //if Finish type, set height to five, load checker texture, and set the position Z to -10
          shape3D.drawMode(S3D.TEXTURE);
          shape3D.use(S3D.ALL).drawMode(S3D.TEXTURE).texture(loadImage("/assets/Images/Finish.png")).uv(0, 1f, 0, 1f);
          pos.z = -10;
          break;
        case WALL:
          shape3D.drawMode(S3D.SOLID); //draw as a solid colour with the top rendering disabled 
          shape3D.fill(wallColor);
          shape3D.visible(false, S3D.FRONT);
          
      }
  }



  void draw(PGraphics graphics) {
    graphics.pushMatrix();
    graphics.translate(pos.x, pos.y); //translate and rotate to the walls position
    graphics.rotate(rot);
    graphics.fill(wallColor);
    graphics.beginShape();
    for (PVector poly : polyPoints) {
      graphics.vertex(poly.x, poly.y); //draw all our points
    }
    graphics.endShape(CLOSE);
    graphics.popMatrix();
    
    if (DEBUG) { //draw debug lines
      PVector[] convertedPoints = pointsToScreenPoints(polyPoints, pos, rot);

      
      graphics.stroke(0, 255, 255);
      graphics.beginShape();
      for (PVector poly : convertedPoints) {
        graphics.vertex(poly.x, poly.y);
      }
      graphics.endShape(CLOSE);
      graphics.noStroke();

    }
  }

  void draw3D(PGraphics graphics) {
    switch(wallType) {
    case CHECKPOINT:
      break;
    case FINISH:
    case WALL:
      shape3D.moveTo(pos); //move to the positon of the wall
      


      shape3D.rotateToZ(rot); //rotate 

      shape3D.draw(graphics); //draw
      break;
    }
    
  }

  void onCollide(kart collidedKart, float delta) {
    if (!KartWallCol(collidedKart.pos, collidedKart.bbBoxSize, collidedKart.rot, polyPoints, pos, rot)) { //check if we're colliding 
      
      return;
    }

    switch (wallType) {
      case WALL: //if the wall is type WALL, a solid wall.
        float kartRot = collidedKart.calculateRot(collidedKart.rot);
        float kartVel = collidedKart.vel;
        kartVel = kartVel * 0.75;
        PVector newkartPosition = collidedKart.calculatePos(delta, kartVel, kartRot);
        while (KartWallCol(newkartPosition, collidedKart.bbBoxSize, kartRot, polyPoints, pos, rot)) {
          //if (kartVel >= -1 && kartVel <= 1) {
          //  kartVel = 0;
          //}
          kartVel = kartVel - (collidedKart.vel / 4);
          newkartPosition = collidedKart.calculatePos(delta, kartVel, kartRot);
        }
        collidedKart.vel = kartVel;
        
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
