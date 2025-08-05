public class Note
{
    // pre-constructor
    dur _ttl;
    0::second => dur _age;
    int _noteType;

    // TODO: Why would i see a static shape that sits in middle?
    GTorus shape --> GG.scene();
    shape.sca(0.2);

    fun @construct(dur ttl, int noteType)
    {
        // initialize
        ttl => _ttl;
        noteType => _noteType;

        if (noteType == 0) {
            shape.color(Color.YELLOW);
        } else if (noteType == 1) {
            shape.color(Color.RED);
        } else if (noteType == 2) {
            shape.color(Color.GREEN);
        } else if (noteType == 3) {
            shape.color(Color.BLUE);
        } else {
            <<< "Invalid note type: " + noteType >>>;
            me.exit();
        }
    }

    public void update(float dt) {
        _age + dt::second => dur newAge;

        // check for expiry
        if (_age <= _ttl && newAge > _ttl) {
            shape.color(Color.WHITE);
            // trigger expiry (explosion/fade)
        }

        newAge => _age;
        shape.pos(-1. * ((_ttl - _age)/second), 0, 0);

    }
}

120. => float BPM;
1::minute / BPM => dur BEAT_DUR;

4 => int NOTE_COUNT;
4 => int COUNTDOWN;

Note notes[NOTE_COUNT];

fun init() {
    for (int i; i < NOTE_COUNT; i++) {
        new Note((i+COUNTDOWN)::BEAT_DUR, i % 3) @=> notes[i];
    }
}

fun void handleKeyboardInput() {
        // Keyboard input
    // check if Q is pressed
    if (GWindow.keyDown(GWindow.Key_Q)) {
        <<< "user pressed 'q'... quitting" >>>;
        me.exit();
    }

    // Check if arrows pressed
    if (GWindow.keyDown(GWindow.Key_Up)) {
        <<< "user pressed 'up'" >>>;
    } else if (GWindow.keyDown(GWindow.Key_Down)) {
        <<< "user pressed 'down'" >>>;
    } else if (GWindow.keyDown(GWindow.Key_Left)) {
        <<< "user pressed 'left'" >>>;
    } else if (GWindow.keyDown(GWindow.Key_Right)) {
        <<< "user pressed 'right'" >>>;
    }
}

fun update(float dt) {
    for ( Note n : notes) {
        n.update(dt);
    }
}

// MAIN
init();

GText text --> GG.scene();
text.pos(0, -1, 0);
text.sca(0.5);

GText bpmText --> GG.scene();
bpmText.pos(1, 1, 0);
bpmText.sca(0.25);
bpmText.text("BPM: " + BPM);


// main loop
while (true)
{
    // Q: Is it canonical to do this first or last in loop?
    GG.nextFrame() => now;

    handleKeyboardInput();

    // updates
    update(GG.dt());


    text.text("Frame: " + GG.fc());
}
