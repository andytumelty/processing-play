let mover;

function setup() {
    var canvas = createCanvas(600, 600);
    canvas.parent('sketch');
    mover = new Mover(width/2, height/2);
}

function draw() {
    background(253);

    // calculate an acceleration based on the distance between the mover and
    // the mouse
    let acceleration = createVector(mouseX, mouseY);
    acceleration.sub(mover.location);
    // add a sensible acceleration limit
    acceleration.limit(0.08);

    mover.acceleration.add(acceleration);

    mover.update();
    mover.draw();

    if (frameCount % 30 == 0){
        document.getElementById('framerate').innerText = frameRate().toFixed(2);
    }
}

class Mover {
    constructor(x, y){
        this.location = createVector(x, y);
        this.velocity = createVector(0, 0);
        this.acceleration = createVector(0, 0);

        this.maxVelocity = 2;

        // the triangle base
        this.size_base = 8;
        // the triangle height
        this.size_height = 14;
    }

    update(){
        this.velocity.add(this.acceleration);
        this.velocity.limit(this.maxVelocity);
        this.location.add(this.velocity);
        // reset acceleration
        this.acceleration.mult(0);
    }

    draw(){
        push();
        translate(this.location.x, this.location.y);
        rotate(this.velocity.heading());
        // the origin of the mover is the triangle point, not the middle
        // a heading of 0 points to the right (e.g. a vector(1,0))
        triangle(
            0, 0,
            -this.size_height, this.size_base/2,
            -this.size_height, -this.size_base/2
        );
    }
}