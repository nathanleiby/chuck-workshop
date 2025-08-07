// Start position and orbit circle


GGen galaxy --> GG.scene();

// fun initScene() {
//     // Galaxy
//     // Solar Systems
//     GGen solarSystem --> galaxy;
//     GGen solarSystem2 --> galaxy;

//     solarSystem.pos(1., 0., 0.);
//     solarSystem2.pos(-1., 0., 0.);

//     // new Planet(solarSystem, 1) @=> Planet planet;
//     // new Planet(solarSystem2, 3) @=> Planet planet2;
// }

// initScene();

// How best to listen for one of many events? General "event bus" listener
class PlanetEvent extends Event
{
    string name;
}

class Planet extends GSphere
{
    0.5 => float planet_radius;
    Color.GREEN => vec3 planet_color;
    1.3 => float orbit_radius;
    this.sca(planet_radius);

    // position within the orbit (init theta to control starting position)
    0. => float theta;

    0.6::second => dur BEAT_DUR; // 100 BPM
    7 => float BEAT_COUNT;

    4 * BEAT_DUR => dur measure;
    measure => dur period; // "year"?

    PlanetEvent e;

    time startTime;

    // initialize a planet
    fun @construct(GGen parent, int beat_count)
    {
        now => startTime;

        @( Math.random2f(0,1), Math.random2f(0,1), Math.random2f(0,1) ) => planet_color;
        this.color(planet_color);
        this --> parent;

        beat_count => BEAT_COUNT;
        // BEAT_COUNT * BEAT_DUR  => period; // "year"?

        // Add its orbit, too
        Circle circ;
        circ.init(  orbit_radius, 0, planet_color );
        circ --> parent;
        @( 0,0,0 ) => circ.pos;

        // Add a "tick" at each "beat" within the period
        (period) / BEAT_COUNT => dur stepSize;

        for (int i; i < BEAT_COUNT; i++) {
            Circle tick;
            .2 => float TICK_RADIUS;
            tick.init( TICK_RADIUS, 0.05, planet_color );
            tick --> parent;

            (stepSize * i) / period => float progress; // progress from 0 -> 1
            2 * Math.PI * progress => theta; // map phase to angle
            @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => tick.pos;
        }

        spork ~ poly(beat_count, measure, 60 + beat_count, e);
        spork ~ listenForEvent(e);
    }

    fun void parent(GGen newParent) {
        this --> newParent;
    }

    fun void update( float dt )
    {
        // update logic for the planet can go here if needed
        getClockMeasureProgress() => float progress; // progress 0 -> 1 in loop
        2 * Math.PI * progress => theta; // map progress to angle
        @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => this.pos;
    }

    fun void listenForEvent(PlanetEvent event)
    {
        // infinite loop
        while ( true )
        {
            // wait on event
            event => now;
            // print
            <<< "Planet event received: ", event.name, " at time: ", now >>>;
            if (event.name == "sound_on") {
                this.sca(planet_radius * 1.5);
                this.color(planet_color * 2.);
            } else if (event.name == "sound_off") {
                this.sca(planet_radius * 1.);
                this.color(planet_color);
            }
        }
    }
}





// creating a custom GGen class for a 2D circle
class Circle extends GGen
{
    // for drawing our circle
    GLines circle --> this;
    // randomize rate
    Math.random2f(2,3) => float rate;
    // default color
    // default line width
    circle.width(.01);
    // does it pulse?
    0 => float pulse;
    0 => float radius;

    128 => int resolution;

    // initialize a circle
    fun void init(float radius, float newPulse, vec3 myColor)
    {
        color( myColor );
        // TODO: variable shadowing is confusing! I had a arg called pulse and it was shadowed by the class variable pulse
        // pulse => pulse;
        newPulse => pulse;

        // incremental angle from 0 to 2pi in N-2 step, plus to steps to close the line loop
        2*pi / (resolution-2) => float theta;
        // positions of our circle
        vec2 pos[resolution];
        // previous, init to 1 zero
        @(radius) => vec2 prev;
        radius => this.radius;

        // loop over vertices
        for( int i; i < pos.size(); i++ )
        {
            // rotate our vector to plot a circle
            // https://en.wikipedia.org/wiki/Rotation_matrix
            Math.cos(theta)*prev.x - Math.sin(theta)*prev.y => pos[i].x;
            Math.sin(theta)*prev.x + Math.cos(theta)*prev.y => pos[i].y;
            // remember v as the new previous
            pos[i] => prev;
        }

        // set positions
        circle.positions( pos );
    }

    fun void color( vec3 c )
    {
        circle.color( c );
    }

    fun void update( float dt )
    {
        if (pulse > 0) {
            this.radius + pulse * Math.sin(now/second*rate) => float s;
            circle.sca( s );
        }
    }
}

// Sound experiment


fun poly(int n, dur period, float midiNote, PlanetEvent e) {
    // now => dur startTime;

    period => dur T;

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

    T / n => dur division;
    division / 2 => dur step;

    // wait til the next step
    <<< "wait a little? (before) =", now >>>;
    (step - now % step) => now;
    <<< "wait a little? (after)  =", now >>>;

    osc => dac;
    osc2 => dac;
    osc3 => dac;
    osc.gain(0.);
    osc2.gain(0.);
    osc3.gain(0.);

    // SinOsc osc => dac;
    // SawOsc osc => dac;
    osc.freq(Std.mtof(midiNote));
    osc2.freq(Std.mtof(midiNote+4));
    osc3.freq(Std.mtof(midiNote+7));
    while (true) {
        "sound_on" => e.name;
        e.signal();
        // if (Math.random2f(0,1) < 0.5) {
            osc.gain(0.5);
        // }
        // if (Math.random2f(0,1) < 0.5) {
        //     osc2.gain(0.5);
        // }
        // if (Math.random2f(0,1) < 0.5) {
        //     osc3.gain(0.5);
        // }
        step => now;
        "sound_off" => e.name;
        e.signal();

        osc.gain(0.);
        osc2.gain(0.);
        osc3.gain(0.);
        step => now;
    }
}

GText measureText() --> GG.scene();
measureText.text("");
measureText.pos(1., 1., 0);
measureText.sca(0.1);
GText beatText() --> GG.scene();
beatText.text("");
beatText.pos(1., 0.9, 0);
beatText.sca(0.1);

fun float getClockPos() {
    // TODO: how to make a global/shared const for use throughout a file?
    0.6::second => dur BEAT_DUR; // 100 BPM
    4 * BEAT_DUR => dur measure;
    measure => dur period; // "year"?

    now / measure => float pos;
    // Math.floor(pos) => float whichMeasure;
    // pos - whichMeasure => float beat;

    return pos;
}

fun float getClockMeasure() {
    getClockPos() => float pos;
    return Math.floor(pos);
}

fun float getClockMeasureProgress() {
    // returns [0,1] value of progress through the current "measure" (perhaps "loop" is better name)
    return getClockPos() - getClockMeasure();
}


fun float getClockBeat() {
    4. => float beats_per_measure;
    return getClockMeasure() % beats_per_measure;
}

// fun getBeat() float {
//     // getProgress() /
//     // Math.floor(pos) => float whichMeasure;
//     // pos - whichMeasure => float beat;

// }

// TODO:
fun clock() {
    // TODO: how to make a global/shared const for use throughout a file?
    0.6::second => dur BEAT_DUR; // 100 BPM
    4 * BEAT_DUR => dur measure;
    measure => dur period; // "year"?

    while (true) {
        BEAT_DUR => now;

        getClockPos() => float pos;
        // now / measure => float pos;
        Math.floor(pos) => float whichMeasure;
        pos - whichMeasure => float beat;
        <<< "Measure:", whichMeasure, "Beat:", beat >>>;
        measureText.text("M = " + whichMeasure);
        beatText.text("B = " + beat);
    }

} spork ~ clock();

while (true) {
    GG.nextFrame() => now;

    // if "pressed a number, add or remove a planet with that number"
    if (GWindow.keyDown(GWindow.Key_1)) {
        <<< "key.1 down" >>>;
        // Solar Systems
        GGen solarSystem --> galaxy;
        Math.random2f(0,1) => float x;
        Math.random2f(0,1) => float y;
        solarSystem.pos(1. * x, 1. * y, 0.);
        new Planet(solarSystem, 1) @=> Planet planet;
    }

    if (GWindow.keyDown(GWindow.Key_2)) {
        <<< "key.2 down" >>>;
        // Solar Systems
        GGen solarSystem --> galaxy;
        Math.random2f(0,1) => float x;
        Math.random2f(0,1) => float y;
        solarSystem.pos(1. * x, 1. * y, 0.);
        new Planet(solarSystem, 2) @=> Planet planet;
    }

    if (GWindow.keyDown(GWindow.Key_3)) {
        <<< "key.3 down" >>>;
        // Solar Systems
        GGen solarSystem --> galaxy;
        Math.random2f(0,1) => float x;
        Math.random2f(0,1) => float y;
        solarSystem.pos(1. * x, 1. * y, 0.);
        new Planet(solarSystem, 3) @=> Planet planet;
    }

    // TODO: manage remove

    // Let user pause!
    // if (GWindow.keyDown(GWindow.Key_P)) {
    //     while(true) {

    //     }
    // }

}

