function setup() {
    let s = min(600, window.innerWidth, window.innerHeight);
    var canvas = createCanvas(s, s, WEBGL);
    canvas.parent('sketch');
    // a slightly nicer starting offset
    cam_s = 4.3;
    cam_t = 5;
}

function draw() {
    background(253);
    lights();
    drawCamera(true);

    noStroke();
    fill(255,0,0);
    sphere(width/60);

    if (frameCount % 30 == 0){
        document.getElementById('framerate').innerText = frameRate().toFixed(2);
    }
}