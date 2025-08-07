// Start position and orbit circle

// Galaxy
// Solar System
// Planet
// Moon

GGen galaxy;
GGen solarSystem;
GGen solarSystem2;

solarSystem --> galaxy;
solarSystem2 --> galaxy;
galaxy --> GG.scene();

solarSystem.pos(1., 0., 0.);
solarSystem2.pos(-1., 0., 0.);

// // play sound at a scheduled time (when), lasting for a certain length (beats)
// fun void playNote(dur when, float beats, int noteType) {
//     if (noteType < 4) {
//         tri.gain(.2);
//         // TODO: is random2 inclusive of RHS?
//         // TODO: can we assert? e.g. 0 <= noteType <= 3
//         midiNotes[noteType] => int freq;
//         Std.mtof(freq) => tri.freq; // frequency

//         // TODO: beats * BEAT_DUR // BEAT_DUR isn't local
//         beats * 0.25::second => now;
//         tri.gain(0.);
//     } else {
//         // load the sample
//         "/Applications/miniAudicle.app/Contents/Resources/examples/data/" => string dataPath;

//         SndBuf buf => Gain g => dac;
//         .5 => g.gain;

//         when => now;
//         if (noteType == 4) {
//             <<< "playing kick drum" >>>;
//             buf.read(dataPath + "kick.wav");
//             buf.pos(0);
//             buf.length() => now;
//         }  else if (noteType == 5) {
//             // play snare
//             <<< "playing snare" >>>;
//             buf.read(dataPath + "snare.wav");
//             buf.pos(0);
//             buf.length() => now;
//         } else if (noteType == 6) {
//             // play hihat
//             <<< "playing hihat-open" >>>;
//             buf.read(dataPath + "hihat-open.wav");
//             buf.pos(0);
//             buf.length() => now;
//         } else if (noteType == 7) {
//             // play crash
//             <<< "playing crash" >>>;
//             buf.read(dataPath + "snare-hop.wav");
//             buf.pos(0);
//             buf.length() => now;
//         }
//         else {
//             <<< "Invalid note type: " + noteType >>>;
//             me.exit();
//         }
//     }
// }

class Planet extends GSphere
{
    // SOUND
    [60, 62, 64, 65] @=> int midiNotes[];
    fun void playSound(int isTri) {
        if (isTri) {
            TriOsc osc => dac;
            osc.gain(0.);
            Math.random2(0, 3) => int noteType;
            midiNotes[noteType] => int freq;
            Std.mtof(freq) => osc.freq; // frequency
            osc.gain(.2);
            0.1::second => now;
            osc.gain(0.);
        } else {
            SinOsc osc => dac;
            osc.gain(0.);
            Math.random2(0, 3) => int noteType;
            midiNotes[noteType] => int freq;
            Std.mtof(freq) => osc.freq; // frequency
            osc.gain(.2);
            0.1::second => now;
            osc.gain(0.);
        }
    }

    fun void playSoundEvery(dur interval, int isTri)
    {
        while (true) {
            spork ~ playSound(isTri);
            interval => now;
        }
    }

    // VISUAL
    // SphereGeometry sphere_geo;
    // FlatMaterial mat3;
    // mat3.color(planet_color);
    // GMesh sphere(sphere_geo, mat3) @=> GMesh planet;
    0.5 => float planet_radius;
    Color.GREEN => vec3 planet_color;
    1.3 => float orbit_radius;

    // planet.sca(planet_radius);
    this.sca(planet_radius);

    0.8 * Math.PI  => float theta;

    0.6::second => dur BEAT_DUR; // 100 BPM
    7 => float BEAT_COUNT;
    // BEAT_COUNT * BEAT_DUR  => dur period; // "year"?
    4 * BEAT_DUR => dur measure;
    measure => dur period; // "year"?

    // how many vertices per circle? (more == smoother)
    128 => int N;

    // initialize a planet
    fun @construct(GGen parent, float beat_count)
    {
        @( Math.random2f(0,1), Math.random2f(0,1), Math.random2f(0,1) ) => vec3 planet_color;
        this.color(planet_color);
        this --> parent;

        beat_count => BEAT_COUNT;
        BEAT_COUNT * BEAT_DUR  => period; // "year"?

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

            (stepSize * i) / period=> float phase; // phase from 0 -> 1
            2 * Math.PI * phase => theta; // map phase to angle
            @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => tick.pos;
        }

        // what sound to play?
        1 => int isTri;
        if (beat_count == 4) {
            1=>isTri;
        } else if (beat_count == 7) {
            0=>isTri;
        } else {
            <<< "Invalid beat count: " + beat_count >>>;
            me.exit();
        }

        spork ~ playSoundEvery(stepSize, isTri);;
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


new Planet(solarSystem, 7) @=> Planet planet;
new Planet(solarSystem2, 4) @=> Planet planet2;

while (true) {
    GG.nextFrame() => now;
}
