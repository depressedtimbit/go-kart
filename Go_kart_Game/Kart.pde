class kart{
    PVector pos;
    PVector vel;
    PVector bbBoxSize;
    PVector controlVector;
    PImage mapImage;
    float traction;
    float maxSpeed = 50;
    float maxRot = 0.1;
    float accelRate = 1500;
    float rot;

    kart(PVector startingPos, PVector bbBoxSize) {
        this.pos = startingPos; // set our pos to our starting pos
        this.bbBoxSize = bbBoxSize; //unused
        controlVector = new PVector(0, 0); //control vector, keyboard/joysticks/controllers/AI can modifiy this to tell the kart to move
        vel = new PVector(0, 0); //velcoity of our kart
        mapImage = loadImage("/assets/Images/map_arrow.png"); //loads a basic arrow image
        traction = 0; //unused
        rot =  0; // our rotation, in degress

    }

    void update(float delta) {
        println(controlVector);
        vel.x = (controlVector.x * (accelRate * delta)); //set the mag of velocity to our control vector, times accel rate, times delta 
        println(vel);
        println("pos:" + pos);
        vel.limit(maxSpeed); //limit to the max speed
        PVector velToAdd = vel.copy(); //create new temp vector
        velToAdd.mult(delta); // times by delta
        velToAdd.rotate(rot); // rotate by our current rotation
        pos.add(velToAdd); // add to pos
        rot += controlVector.y * maxRot; //change rotation according to our controlVector
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
    }

    void draw3D() {

    }
}