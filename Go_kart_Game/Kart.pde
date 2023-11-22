class kart{
    PVector pos;
    PVector vel;
    PVector bbBoxSize;
    PVector controlVector;
    PImage mapImage;
    float traction;
    float maxSpeed = 50;
    float maxRot = 0.1;
    float accelRate = 1;
    float rot;

    kart(PVector startingPos, PVector bbBoxSize) {
        this.pos = startingPos;
        this.bbBoxSize = bbBoxSize;
        controlVector = new PVector(0, 0);
        vel = new PVector(0, 0);
        mapImage = loadImage("/assets/Images/map_arrow.png");
        traction = 0;
        rot =  0;

    }

    void update(float delta) {
        vel.setMag(controlVector.x * (accelRate * delta));
        vel.limit(maxSpeed);
        PVector velToAdd = vel;
        velToAdd.mult(delta);
        velToAdd.rotate(rot);
        pos.add(velToAdd);
    }

    void draw() {
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rot);
        
        image(mapImage, -mapImage.width/2, -mapImage.height/2);
        popMatrix();
        if (keyPressed && (keyCode == LEFT)) {
            rot -= maxRot;
        }
        if (keyPressed && (keyCode == RIGHT)) {
            rot += maxRot;
        }
        
    } 

    void draw3D() {

    }
}