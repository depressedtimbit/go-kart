class kart{
    PVector pos;
    float vel;
    PVector bbBoxSize; //bounding box size, how big is our kart
    PVector controlVector;
    PVector velToAdd;
    PImage mapImage;
    boolean blocked = false;
    boolean disabled = true;
    float traction;
    float maxSpeed = 200;
    float maxRot = 0.1;
    float turnSpeed = 100;
    float turnValue;
    float accelRate = 700;
    float breakConstant = 500;
    float rot;
    IntList checkedPoints;
    int finishedlaps = 0;

    kart(PVector startingPos, PVector bbBoxSize, float startingRot) {
        this.pos = startingPos; // set our pos to our starting pos
        this.bbBoxSize = bbBoxSize; //unused
        controlVector = new PVector(0, 0); //control vector, keyboard/joysticks/controllers/AI can modifiy this to tell the kart to move
        vel = 0; //velcoity of our kart
        mapImage = loadImage("/assets/Images/map_arrow.png"); //loads a basic arrow image
        traction = 0; //unused
        rot =  startingRot; // our rotation, in degress
        checkedPoints = new IntList();
        checkedPoints.append(0);

    }

    void update(float delta) {
        println("checkedPoints:"+checkedPoints);
        println("controlVector" + controlVector);
        vel += (max(0, controlVector.x) * (accelRate * delta)); //set the mag of velocity to our control vector, times accel rate, times delta 
        
        if (controlVector.x < 0 && vel > 0) {
          vel += (controlVector.x * (breakConstant * delta)); //subtract from vel only if controlVector is less than 0 and vel is greater than 0 (not in reverse)
        }
        
        traction = map(vel, -maxSpeed, maxSpeed, -maxRot, maxRot/2); //create a value that ranges from negative max turning rate to half our max turning rate, based on our vel
        println("traction:" + traction);
        
        turnValue = map(vel, -turnSpeed, turnSpeed, -maxRot, maxRot); //do the same as traction, but to the max turning rate
        turnValue = min(maxRot, turnValue);
        
        println("turnValue:" + turnValue);
        
        println("turnTotal:" + (turnValue - traction));
        
        println("vel:" + vel);
        println("pos:" + pos);
        
        
        
        
        vel = min(maxSpeed, vel); //limit to the max speed
        
    }
    
    void physicsStep() {
      velToAdd = new PVector(vel, 0); //create new temp vector
      velToAdd.mult(delta); // times by delta
      velToAdd.rotate(rot); // rotate by our current rotation
      if (!blocked && !disabled) {
            pos.add(velToAdd); // add to pos
        }
      if (!disabled) {
          rot += controlVector.y * (turnValue - traction); //change rotation according to our controlVector and turnValue - traction, this means that as speed increases, turning becomes harder
          
        }
    
    }
    void keyPressed() {
        
        if (keyPressed && (keyCode == LEFT)) {
            controlVector.y = -1; //tell the kart to turn left
            println(controlVector);
        }
        
        if (keyPressed && (keyCode == RIGHT)) {
            controlVector.y = 1; //tell the kart to turn right
            println(controlVector);
        }

        if (keyPressed && (keyCode == UP)) {
            controlVector.x = 1; //tell the kart to turn left
            println(controlVector);
        }
        
        if (keyPressed && (keyCode == DOWN)) {
            controlVector.x = -1; //tell the kart to turn right
            println(controlVector);
        }

    }

    void keyReleased() {
/*
        if ((keyCode == LEFT)) {
            controlVector.y += 1; //tell the kart to turn left
            println(controlVector);
        }
        
        if ((keyCode == RIGHT)) {
            controlVector.y += -1; //tell the kart to turn right
            println(controlVector);
        }

        if ((keyCode == UP)) {
            controlVector.x += -1; //tell the kart to turn left
            println(controlVector);
        }
        
        if ((keyCode == DOWN)) {
            controlVector.x += 1; //tell the kart to turn right
            println(controlVector);
        }
        controlVector.limit(1);
*/
        if ((keyCode == LEFT || keyCode == RIGHT)) {
            controlVector.y = 0; //reset our control vector if we release keys
            println(controlVector);
        }
        if ((keyCode == UP || keyCode == DOWN)) {
            controlVector.x = 0; //reset our control vector if we release keys
            println(controlVector);
        }
    }

    void draw() {
        pushMatrix(); 
        translate(pos.x, pos.y); //translate the image to our pos
        rotate(rot+HALF_PI); //rotate to our kart rotation 
        image(mapImage, -mapImage.width/2, -mapImage.height/2); // draw the image, centred at 0, 0
        popMatrix();
        
        noFill();
        
        if (DEBUG) { //draw debug lines
          PVector[] kartPoints = bbBoxToPoints(bbBoxSize);
          PVector[] kartConvertedPoints = pointsToScreenPoints(kartPoints, pos, rot);
          stroke(255, 255, 0);
          beginShape();
          for (PVector poly : kartConvertedPoints) {
            vertex(poly.x, poly.y);
          }
          endShape(CLOSE);
        }
    }

    void draw3D() {

    }
}
