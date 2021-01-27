function setup() {
    var canvas = createCanvas(600, 600, WEBGL);
    canvas.parent('sketch');
    // a slightly nicer starting offset
    cam_s = 4.3;
    cam_t = 5;
}

function draw() {
    background(253);
    lights();
    drawCamera(true);

    // _template

    if (frameCount % 30 == 0){
        document.getElementById('framerate').innerText = frameRate().toFixed(2);
    }
}
