let amplitude;
let period;

function setup() {
    let s = min(600, window.innerWidth, window.innerHeight);
    var canvas = createCanvas(s, s);
    canvas.parent('sketch');

    // amplitude is true amplitude here: the distance between max and min
    amplitude = width * 0.6;
    period = 120;
}

function draw() {
    background(253);

    let x = 0.5 * amplitude * sin(TWO_PI * frameCount / period);
    line(width/2, height/2, width/2 + x, height/2);
    circle(width/2 + x, height/2, width/30);

    if (frameCount % 30 == 0){
        document.getElementById('framerate').innerText = frameRate().toFixed(2);
    }
}
