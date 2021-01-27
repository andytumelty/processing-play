let r = 1;
let theta = 0;

function setup() {
    let s = min(600, window.innerWidth, window.innerHeight);
    var canvas = createCanvas(s, s);
    canvas.parent('sketch');

    background(253);
}

function draw() {

    // convert from polar to cartesian
    let x = r * cos(theta) + width/2;
    let y = r * sin(theta) + height/2;

    noStroke();
    fill(0);
    circle(x, y, width/60);

    // This creates a consistent spiral, but I prefer the dots that are
    // gradually spaced out by ^, creating a pattern of their own. U?sing this
    // also kinda defeats the point of showing the conversion to cartesian.
    // strokeWeight(width/60);
    // stroke(0);
    // noFill();
    // arc(width/2, height/2, 2*r, 2*r, theta, theta+0.1);

    r += width/4400;
    theta += width/12000;

    if (frameCount % 30 == 0){
        document.getElementById('framerate').innerText = frameRate().toFixed(2);
    }
}
