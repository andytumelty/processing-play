function setup() {
    var canvas = createCanvas(800, 600, WEBGL);
    canvas.parent('sketch');
    // a slightly nicer starting offset
    cam_s = 4.3;
    cam_t = 5;
}

function draw() {
    background(250);
    lights();
    drawCamera(true);

    noStroke();
    fill(255,0,0);
    sphere(10);

    document.getElementById('framerate').innerText = frameRate();
}