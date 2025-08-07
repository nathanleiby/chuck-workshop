
1.5::second => dur T;

fun poly(int n, float midiNote) {
    Osc osc;
    Osc osc2;
    Osc osc3;
    n % 3 => int variant;
    Math.randomize();
    Math.random2(0,2) => variant;
    if (variant == 0) {
        <<< "Using SinOsc variant" >>>;
        new SinOsc() => osc;
        new SinOsc() => osc2;
        new SinOsc() => osc3;
    } else if (variant == 1) {
        <<< "Using SawOsc variant" >>>;
        new SawOsc() => osc;
        new SawOsc() => osc2;
        new SawOsc() => osc3;
    } else if (variant == 2) {
        <<< "Using TriOsc variant" >>>;
        new TriOsc() => osc;
        new TriOsc() => osc2;
        new TriOsc() => osc3;
    }
    osc => dac;
    osc2 => dac;
    osc3 => dac;

    // SinOsc osc => dac;
    // SawOsc osc => dac;
    osc.freq(Std.mtof(midiNote));
    osc2.freq(Std.mtof(midiNote+4));
    osc3.freq(Std.mtof(midiNote+7));

    T / n => dur division;
    division / 2 => dur step;
    while (true) {
        if (Math.random2f(0,1) < 0.5) {
            osc.gain(0.5);
        }
        if (Math.random2f(0,1) < 0.5) {
            osc2.gain(0.5);
        }
        if (Math.random2f(0,1) < 0.5) {
            osc3.gain(0.5);
        }
        step => now;
        osc.gain(0.);
        osc2.gain(0.);
        osc3.gain(0.);
        step => now;
    }
}

// spork ~ poly(7, 72);
// spork ~ poly(4, 74);
spork ~ poly(3, 62);
spork ~ poly(2, 60);
// spork ~ poly(1, 220);

while (true) {
    1::second => now;
}

