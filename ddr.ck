public class Note
{
    // pre-constructor
    // DATA
    dur _ttl;
    0::second => dur _age;
    int _noteType;

    // VISUAL
    // TODO: Why do I see a 2nd static shape that sits in middle?
    GTorus shape --> GG.scene();
    0.2 => float MAX_SCA;
    shape.sca(MAX_SCA);

    // SOUND
    TriOsc tri => dac;
    tri.gain(0.);
    [60, 62, 64, 65] @=> int midiNotes[];

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

        spork ~ playNote(ttl, 0.5, noteType);
    }

    // play sound at a scheduled time (when), lasting for a certain length (beats)
    fun void playNote(dur when, float beats, int noteType) {
        tri.gain(0.);
        when => now;
        tri.gain(5.);
        // TODO: is random2 inclusive of RHS?
        // TODO: can we assert? e.g. 0 <= noteType <= 3
        midiNotes[noteType] => int freq;
        Std.mtof(freq) => tri.freq; // frequency

        // TODO: beats * BEAT_DUR // BEAT_DUR isn't local
        beats * 0.25::second => now;
        tri.gain(0.);
    }

    public void update(float dt) {
        _age + dt::second => dur newAge;

        // check for expiry
        if (_age <= _ttl && newAge > _ttl) {
            shape.color(Color.WHITE);
            // trigger expiry (explosion/fade)
        }

        if (newAge > _ttl) {
            2::second => dur fadeOutDur;
            newAge - _ttl => dur secondsPastExpiry;

            secondsPastExpiry / fadeOutDur => float howFaded;
            Math.min(1, howFaded) => howFaded;

            if (newAge > _ttl) {
                // Math.max(1::second, 0::second) => dur fadeOut;
                // fully expire
                shape.sca(MAX_SCA * (1. - howFaded));
            }
        }

        newAge => _age;

        -1. * ((_ttl - _age)/second) => float x;
        -1. * ((_ttl - _age)/second) => float y;
        shape.pos(x, y, 0);



    }
}

120. => float BPM;
1::minute / BPM => dur BEAT_DUR;

16 => int NOTE_COUNT;
2 => int COUNTDOWN;

Note notes[NOTE_COUNT];

fun init() {
    for (int i; i < NOTE_COUNT; i++) {
        Math.random2(0, 3) => int noteType;
        new Note((i+COUNTDOWN)::BEAT_DUR, noteType) @=> notes[i];
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
text.pos(1.5, -1.5, 0);
text.sca(0.3);

GText bpmText --> GG.scene();
bpmText.pos(1.5, 1.5, 0);
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
