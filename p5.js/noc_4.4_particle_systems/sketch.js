let particle_systems = [];

function setup() {
    let s = min(600, window.innerWidth, window.innerHeight);
    let canvas = createCanvas(s, s);
    canvas.parent('sketch');

    // create a default particle system
    particle_systems.push(new ParticleSystem(width/2, height/4));
}

function mouseClicked(event) {
    if (mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height){
        particle_systems.push(new ParticleSystem(mouseX, mouseY));
    }
}

function touchStarted(event) {
    if (mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height){
        particle_systems.push(new ParticleSystem(mouseX, mouseY));
    }
}

function draw() {
    background(253);

    let total = 0;

    for (let i = particle_systems.length - 1; i >= 0; i--){
        let ps = particle_systems[i];
        total += ps.particles.length;
        if (ps.particles.length == 0){
            particle_systems.splice(i, 1);
        } else {
            particle_systems[i].run();
        }
    }

    if (frameCount % 30 == 0){
        document.getElementById('framerate').innerText = frameRate().toFixed(2);
        document.getElementById('total_particles').innerText = total;
    }
}

class ParticleSystem {
    constructor(x, y){
        this.location = createVector(x, y);
        this.particles = [];
        // start with a single particle so we never delete this system immediately
        this.particles.push(new Particle(this.location.x, this.location.y));
        this.age = 0;
    }

    run() {
        for (let i = this.particles.length - 1; i >= 0; i--){
            let p = this.particles[i];
            if (p.isDead()) {
                this.particles.splice(i, 1);
            } else {
                this.particles[i].run();
            }
        }
        if ((Math.random() + 1) * this.age < 2000){
            this.particles.push(new Particle(this.location.x, this.location.y));
        }
        this.age += 1;
    }
}

class Particle {
    constructor(x, y){
        this.location = createVector(x, y);
        this.angle = 0;

        // this.velocity = createVector(0, 0);
        // this.acceleration = createVector(0, 0);
        // this.aVelocity = 0;
        // this.aAcceleration = 0;

        // random velocity and small acceleration
        this.velocity = createVector(random(-1,1), random(-2,0));
        this.acceleration = createVector(0, 0.05);
        // initially spin in the same direction as the random x velocity
        this.aVelocity = this.velocity.x * 0.1;
        // ... but slow the rotation down over time (sort of)
        this.aAcceleration = - this.velocity.x * 0.001;

        // TODO make these configurable?
        this.lifespan = 255;
        this.size = width/60;
        this.mass = this.size/10;
    }

    run() {
        this.update();
        this.display();
    }

    update() {
        this.velocity.add(this.acceleration);
        this.velocity.limit(5);
        this.location.add(this.velocity);

        this.aVelocity += this.aAcceleration;
        // TODO need to make this an absolute check
        //this.aVelocity = min(this.aVelocity, 0.2);
        this.angle += this.aVelocity;

        // TODO make this configurable?
        this.lifespan -= 2;
    }

    applyForce(f) {
        // f = m*a, a = f/m
        let a = f.div(this.m);
        this.acceleration.add(a);
    }

    display() {
        stroke(0, this.lifespan);
        fill(255, this.lifespan);
        push();
        translate(this.location.x, this.location.y);
        rotate(this.angle);
        rectMode(CENTER);
        // TODO make shape configurable?
        square(0, 0, this.size);
        pop();
    }

    isDead() {
        return this.lifespan <= 0;
    }
}