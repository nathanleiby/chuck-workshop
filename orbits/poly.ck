
2::second => dur T;

fun poly(int n, float freq) {
    Osc osc;
    n % 3 => int variant;
    if (variant == 0) {
        <<< "Using SinOsc variant" >>>;
        new SinOsc() => osc;
    } else if (variant == 1) {
        <<< "Using SawOsc variant" >>>;
        new SawOsc() => osc;
    } else if (variant == 2) {
        <<< "Using TriOsc variant" >>>;
        new TriOsc() => osc;
    }
    osc => dac;

    // SinOsc osc => dac;
    // SawOsc osc => dac;
    osc.freq(freq);

    T / n => dur division;
    division / 2 => dur step;
    while (true) {
        osc.gain(0.5);
        step => now;
        osc.gain(0.);
        step => now;
    }
}

// spork ~ poly(7, 880);
spork ~ poly(4, 660);
spork ~ poly(3, 440);
// spork ~ poly(2, 330);
// spork ~ poly(1, 220);

while (true) {
    1::second => now;
}

