let mover;
let keysPressed = new Set();

function setup() {
    let s = min(600, window.innerWidth, window.innerHeight);
    var canvas = createCanvas(s, s);
    canvas.parent('sketch');
    mover = new Mover(width/2, height/2);
}

function draw() {
    background(253);

    // add an acceleration based on the key being pressed
    let mag = 0.02
    let acceleration = createVector(0, 0);
    if (keysPressed.has('w') || keysPressed.has('W')){
        acceleration.add(createVector(0, -mag));
    }
    if (keysPressed.has('a') || keysPressed.has('A')){
        acceleration.add(createVector(-mag, 0));
    }
    if (keysPressed.has('s') || keysPressed.has('S')){
        acceleration.add(createVector(0, mag));
    }
    if (keysPressed.has('d') || keysPressed.has('D')){
        acceleration.add(createVector(mag, 0));
    }
    mover.acceleration.add(acceleration);

    // gradually slow the vehicle down
    let friction = mover.velocity.copy();
    friction.mult(-0.01);
    friction.limit(0.05);
    mover.acceleration.add(friction)

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
        this.size_base = width/75;
        // the triangle height
        this.size_height = width/40;
    }

    update(){
        this.velocity.add(this.acceleration);
        this.velocity.limit(this.maxVelocity);
        this.location.add(this.velocity);
        this.wrapEdges();
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

    wrapEdges(){
        if (this.location.x > width){
            this.location.x = 0;
        } else if (this.location.x < 0){
            this.location.x = width;
        }
        if (this.location.y > height){
            this.location.y = 0;
        } else if (this.location.y < 0){
            this.location.y = height;
        }
    }
}

// add/remove keys from the keysPressed array when they are pressed/released.
document.addEventListener("keydown", event => {
    // https://bugzilla.mozilla.org/show_bug.cgi?id=354358
    if (event.isComposing || event.keyCode === 229) {
        return;
    }
    keysPressed.add(event.key);
});

document.addEventListener("keyup", event => {
    // https://bugzilla.mozilla.org/show_bug.cgi?id=354358
    if (event.isComposing || event.keyCode === 229) {
        return;
    }

    keysPressed.delete(event.key);
});