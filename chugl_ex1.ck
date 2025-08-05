// scene() .. things to be rendered
// --> .. gruck operator, aka the graphical chuck operator
// chuck ugens to the audio graph
// gruck ggens to the scene graph

// GTorus suzanne --> GG.scene();
GSuzanne suzanne --> GG.scene();

// Event e;
// 1::second => now; // wait 1 second
// e => now; // wait for event "e" to occur

//// Can simulate a slower frame rate! this shouldn't affect behavior.
// GG.fps(30);

// SinOsc
TriOsc tri => dac;
// PulseOsc
// SawOsc
tri.gain(0.5); // amplitude

int notes[5];

[60, 62, 64, 65, 67] @=> notes;

// play notes in a loop
fun void doAudio() {
    while (true) {
        Math.random2(0, 4) => int noteIdx;
        notes[noteIdx] => int note;
        Std.mtof(note) => tri.freq; // frequency
        .5::second => now;
    }
}

spork ~ doAudio();

// time loop
while( true )
{


    GG.nextFrame() => now;

    // GG.dt() is the time since the last frame
    GG.dt() => float dt;

    // animation!
    // sin oscillates between -1 and 1
    // fabs remaps to 0 to 1
    // sca is scale

    // Math.max(Math.fabs(Math.sin(now/second)), .1) => suzanne.scaX;
    // Math.max(Math.fabs(Math.sin(1.3 * (now/second))), .1) => suzanne.scaY;

    // We use GG.dt() to avoid this

    // generate a number from [-PI, PI], cycling every {duration}
    // now/second / 10.0 => float theta;

    dt => float theta;
    suzanne.rotateY(2 * theta);

    // audiovisual mapping
    // NOTE: This block here is the CORE of what makes ChuGL interesting! real time synthesis and graphics that are deeply connected in code.
    Math.remap(
        tri.freq(), // remap this number
        Std.mtof(60), Std.mtof(67), // from this range
        -2, 2 // to this range
    ) => suzanne.posY; // set the Y position

    // suzanne.rotateY(dt * 10);

    // <<< GG.fc() >>>;
}

// Right handed coordinate system
// - Thumb is X
// - Index finger is Y
// - Middle finger is Z

// NOTE: You want to avoid
