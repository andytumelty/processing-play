let baton;

function setup() {
    var canvas = createCanvas(600, 600);
    canvas.parent('sketch');
    baton = new Baton(width/2, height/2);
}

function draw() {
    background(253);

    // Constant angular acceleration
    // baton.aAcceleration = 0.001;

    // a sinusoidal harmonic acceleration w.r.t. frameCount
    baton.aAcceleration = 0.01 * Math.sin(PI*frameCount/100);

    baton.update();
    baton.draw();

    if (frameCount % 30 == 0){
        document.getElementById('framerate').innerText = frameRate().toFixed(2);
    }
}

class Baton {
    constructor(x, y){
        this.location = createVector(x, y);
        // angular attributes: all in radians
        this.angle = 0.0;
        this.aVelocity = 0.0;
        this.aAcceleration = 0.0;

        this.aVelocityMax = 0.2;

        // the baton line length
        this.length = 100;
        // the radii of the two capping circles
        this.radius = 10;
    }

    update(){
        this.aVelocity += this.aAcceleration;
        this.angle += this.aVelocity;
        if (this.aVelocity > this.aVelocityMax){
            this.aVelocity = this.aVelocityMax
        } else if (this.aVelocity < -this.aVelocityMax){
            this.aVelocity = -this.aVelocityMax
        }
        // reset angular acceleration
        this.acceleration = 0;
    }

    draw(){
        push();
        translate(this.location.x, this.location.y);
        rotate(this.angle);
        line(-this.length/2, 0, this.length/2, 0);
        circle(-this.length/2, 0, this.radius);
        circle(this.length/2, 0, this.radius);
    }
}