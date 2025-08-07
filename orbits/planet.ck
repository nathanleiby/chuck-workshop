// Start position and orbit circle



fun initScene() {
    // Galaxy
    GGen galaxy --> GG.scene();
    // Solar Systems
    GGen solarSystem --> galaxy;
    GGen solarSystem2 --> galaxy;

    solarSystem.pos(1., 0., 0.);
    solarSystem2.pos(-1., 0., 0.);

    new Planet(solarSystem, 1) @=> Planet planet;
    new Planet(solarSystem2, 3) @=> Planet planet2;
}

initScene();

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

    // initialize a planet
    fun @construct(GGen parent, int beat_count)
    {
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

            (stepSize * i) / period => float phase; // phase from 0 -> 1
            2 * Math.PI * phase => theta; // map phase to angle
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
        (now % period) / period => float phase; // phase from 0 -> 1
        2 * Math.PI * phase => theta; // map phase to angle
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

while (true) {
    GG.nextFrame() => now;
}
