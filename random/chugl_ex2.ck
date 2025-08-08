GOrbitCamera cam --> GG.scene();
GG.scene().camera(cam);
cam.pos(0, 0, 10);

25 => int NUM_ROWS;
25 => int NUM_COLS;

SuzanneGeometry geo;
PhongMaterial mat;

// GMesh monkeys[NUM_ROWS][NUM_COLS];
GSuzanne monkeys[NUM_ROWS][NUM_COLS];
vec3 startPos[NUM_ROWS][NUM_COLS];
float rotationSpeeds[NUM_ROWS][NUM_COLS];

for (int y; y < NUM_ROWS; y++) {
    for (int x; x < NUM_COLS; x++) {
        monkeys[y][x] --> GG.scene();
        monkeys[y][x].sca(.3);
        // monkeys[y][x].pos(x - NUM_COLS / 2., y - NUM_ROWS / 2., 0);

        randomPointInCube(2) => startPos[y][x];
        monkeys[y][x].pos(startPos[y][x]);

        Math.random2f(0.1, 0.3) => rotationSpeeds[y][x];
        monkeys[y][x].color(Color.random());
    }
}

fun vec3 randomPointInCube(float l) {
    return @(
        Math.random2f(-l, l),
        Math.random2f(-l, l),
        Math.random2f(-l, l)
    );
}

while (1) {
    GG.nextFrame() => now;
    GG.dt() => float dt;

    (1 + Math.sin(now/second)) / 2.0 => float progress;

    for (int y; y < NUM_ROWS; y++) {
        for (int x; x < NUM_COLS; x++) {
            // monkeys[y][x].rotateY(dt * y);
            monkeys[y][x].rotateX(rotationSpeeds[y][x]);
            monkeys[y][x].pos(startPos[y][x] * progress);
        }
    }

    // GG.scene().light().intensity(0);
    GG.scene().light().rotateX(dt);

}


