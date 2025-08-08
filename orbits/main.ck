@import "globals.ck"
@import "sound_maker.ck"

// window title
GG.windowTitle( "Orbits" );
// fullscreen
// GG.fullscreen();
// position
// GG.camera().posZ( 3 );

GCamera cam --> GG.scene();
GG.scene().camera(cam);

class Galaxy extends GPlane {

}

class SolarSystem extends GGen
{
    fun @construct() {

    }
}

// How best to listen for one of many events? General "event bus" listener
class PlanetEvent extends Event
{
    string name;
}

class Planet extends GGen
{

    SphereGeometry sphere_geo;
    FlatMaterial mat3;

    Color.GREEN => vec3 planet_color;
    mat3.color(planet_color);
    GMesh sphere(sphere_geo, mat3);
    sphere --> this;
    0.2 => float planet_radius;
    sphere.sca(planet_radius);

    0. => float orbit_radius;

    // position within the orbit (init theta to control starting position)
    0. => float theta;

    Globals.BEAT_DUR => dur BEAT_DUR;
    7 => float BEAT_COUNT;

    Globals.measure => dur period; // "year"?

    PlanetEvent e;
    time startTime;

    // initialize a planet
    fun @construct(GGen parent, int beat_count, int isPercussion)
    {
        now => startTime;

        0.6 + beat_count * planet_radius * 2. => orbit_radius;

        // https://chuck.stanford.edu/chugl/api/chugl-basic.html#Color .. Convert RGB to 0->1
        // [0x4B0082, 0x4682B4, 0xFF6EC7, 0x000000, 0xFFD700, 0x00FF00, 0x808080] @=> int colorPalette[];
        [0x4B0082, 0x4682B4, 0xFF6EC7, 0xFFD700, 0x00FF00, 0x808080] @=> int colorPalette[];
        // Math.random2(0, colorPalette.size()-1) => int colorIndex;
        beat_count % colorPalette.size() => int colorIndex;
        0.6 * Color.hex(colorPalette[colorIndex]) => planet_color;
        mat3.color(planet_color);
        this --> parent;

        beat_count => BEAT_COUNT;

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

        Math.random2(0,8) => int variant;
        spork ~ poly(beat_count, Globals.measure, variant, e, isPercussion);
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
            // <<< "Planet event received: ", event.name, " at time: ", now >>>;
            if (event.name == "sound_on") {
                sphere.sca(planet_radius * 1.5);
                mat3.color(planet_color * 2.);
            } else if (event.name == "sound_off") {
                sphere.sca(planet_radius * 1.);
                mat3.color(planet_color);
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

// poly() schedules a sound to occur within a polyrhythmic pulse
// note that it can be "on" or "off" beat within that pulse type
// TODO(nate): Make this controllable. Then decide if randomness is nicer
fun poly(int n, dur period, int variant, PlanetEvent e, int isPercussion) {
    //
    period => dur T;
    T / n => dur division;
    division / 2 => dur step;

    // wait til the next step
    // (step - now % step) => now;
    // wait til the next division
    (division - now % division) => now;

    new SoundMaker() @=> SoundMaker sm;
    while (true) {
        "sound_on" => e.name;
        e.signal();
        if (isPercussion) {
            variant % 4 => int variation;
            if (variation == 0) spork ~ sm.playSample("kick.wav");
            if (variation == 1) spork ~ sm.playSample("snare.wav");
            if (variation == 2) spork ~ sm.playSample("hihat-open.wav");
            if (variation == 3) spork ~ sm.playSample("snare-hop.wav");
        } else {
            // various chords available
            [
                [0, 4, 7, 11], // M7
                [0, 4, 7, 10], // 7
                [0, 3, 7, 10], // m7
            ] @=> int chords[][];

            // SONG
            // SONG #1:
            [42, 44, 46, 47] @=> int rootNotes[];
            [0,2,2,0] @=> int chordTypes[];
            4 => Globals.songLength;

            // SONG #2: @0:00 https://chordify.net/chords/plini-songs/selenium-forest-chords
            // Right now transitions are at the measure level, but the real song is transitioning at the "beat" level
            // TODO: consider 1/2time or double time interpretations
            // Consider also BPM
            // [51, 51, 47, 47, 44, 46, 46, 46] @=> int rootNotes[];
            // [2,  2,  0,  0,  2,  2,  2,  2] @=> int chordTypes[];
            // 8 => int songLength;

            // SONG #3: @2:58 https://chordify.net/chords/plini-songs/selenium-forest-chords
            // - guitar riff in the actual song is 7 against 2 polyrhythm
            // TODO: consider 1/2time or double time interpretations
            // TODO: can always offset by +12 too
            // B, Db, B,  Abm
            // [35, 37, 35, 44] @=> int rootNotes[];
            // [0,  1,  0,  2] @=> int chordTypes[];
            // 4 => int songLength;

            // SONG #4: @3:10 https://chordify.net/chords/plini-songs/selenium-forest-chords

            if (rootNotes.size() != Globals.songLength || chordTypes.size() != Globals.songLength) {
                <<< "ERROR -- need a chord for each root note in the song ... expected songLength = ", Globals.songLength >>>;
                me.exit();
            }
            getSongIdx() => int songIdx;

            rootNotes[songIdx] => int rootMidiNote; // current root
            // Allow adjusting octave based on planet variant
            rootMidiNote - 12 + ((variant % 2) * 12) => rootMidiNote;

            chordTypes[songIdx] => int chordIdx; // current chord

            chords[chordIdx] @=> int chordOffsets[];

            Math.random2(0, chordOffsets.size() - 1) => int notesIdx; // random note within the chord
            // variant % chordOffsets.size() => int notesIdx; // consistent note within the chord
            // Keep it the same one for the planet

            // TODO(temp): always play the root
            // 0 => notesIdx;
            rootMidiNote + chordOffsets[notesIdx] => int midiNote; // specific midiNote, accounting for root

            spork ~ sm.playNote(step, midiNote);
        }
        step => now;
        "sound_off" => e.name;
        e.signal();
        step => now;
    }
}

fun float getSongProgress() {
    return getClockPos() * Globals.songRate / (Globals.songLength $ float);
}

fun int getSongIdx() {
    return ((getClockMeasure() * Globals.songRate) $ int) % Globals.songLength;
}

fun float getClockPos() {
    // TODO: beats per measure-- centralize this
    4 * Globals.BEAT_DUR => dur measure;
    // measure => dur period; // "year"?
    return now / measure;
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

fun clock() {
    false => int SHOW_DEBUG_UI;

    4 * Globals.BEAT_DUR => dur measure;
    measure => dur period; // "year"?

    while (true) {
        Globals.BEAT_DUR => now;

        getClockPos() => float pos;
        Math.floor(pos) => float whichMeasure;
        pos - whichMeasure => float beat;
        // <<< "Measure:", whichMeasure, "Beat:", beat >>>;
        if (SHOW_DEBUG_UI) {
            measureText.text("M = " + whichMeasure);
            beatText.text("B = " + beat);
        }
    }

}

fun vec3 randomPos3() {
    Math.random2f(-1, 1) => float x;
    Math.random2f(-1,1) => float y;
    return @(x, y, 0.);
}



GText measureText() --> GG.scene();
measureText.text("");
measureText.pos(1., 1., 0);
measureText.sca(0.1);
GText beatText() --> GG.scene();
beatText.text("");
beatText.pos(1., 0.9, 0);
beatText.sca(0.1);

spork ~ clock(); // Do this after creating the UI that clock may update (measureText, beatText)

// TODO: consider a small UI layer to expose these sorts of things, for debugging.
// so I can control the next planet(s)spork ~ clock();
false => int isPercussion;
0 => int instrumentVariant;

// Start position and orbit circle
GGen galaxy --> GG.scene();

GGen solarSystemNotes --> galaxy;
solarSystemNotes.pos(5.,0.,0.);

SphereGeometry sphere_geo;
FlatMaterial mat3;
mat3.color(2. * Color.YELLOW);
GMesh sun1(sphere_geo, mat3);
sun1 --> solarSystemNotes;
sun1.sca(0.7);
GPointLight sun1light --> sun1;

GGen solarSystemPercussion --> galaxy;
solarSystemPercussion.pos(-5.,0.,0.);
FlatMaterial sun2mat;
sun2mat.color(3.0 * Color.RED);
GMesh sun2(sphere_geo, sun2mat);
sun2 --> solarSystemPercussion;
sun2.sca(0.9);

// cam.pos(solarSystemNotes.posX(), solarSystemNotes.posY(), 0. );

// CAMERA VARIANTS
// Galaxy view
cam.pos(0, 0, 20.);

// start looking at solar system one
cam.pos(solarSystemNotes.pos() + @(0., 0., 10.));


fun handleUserInput() {
    // TODO: Allow creating Solar Systems

    if (GWindow.keyDown(GWindow.Key_P)) {
        1 - isPercussion => isPercussion; // invert bool
    }

    // if (GWindow.keyDown(GWindow.Key_V)) {
    //     (instrumentVariant + 1) %  => instrumentVariant;
    // }

    int keyCodes[10];
    for (int i; i < 10; i++) {
        GWindow.Key_1 + i - 1 @=> keyCodes[i];
    }

    for (int keyCode : keyCodes) {
        if (GWindow.keyDown(keyCode)) {
            keyCode - GWindow.Key_1 + 1 => int keyNumber;
            <<< "key down", keyNumber, "(CodAe =", keyCode, ")" >>>;
            GGen whichSystem;
            if (isPercussion) {
                solarSystemPercussion @=> whichSystem;
            } else {
                solarSystemNotes @=> whichSystem;
            }

            new Planet(whichSystem, keyNumber, isPercussion) @=> Planet planet;
        }
    }
}



// render graph
GG.outputPass() @=> OutputPass output_pass;
GG.renderPass() --> BloomPass bloom_pass --> output_pass;
bloom_pass.input(GG.renderPass().colorOutput());
output_pass.input(bloom_pass.colorOutput());
output_pass.tonemap(4); // 4 is "ACES"

// Only ultra bright objects get blooom
bloom_pass.threshold(1.1);

while (true) {
    GG.nextFrame() => now;

    // Pulsing suns
    Math.sin(Math.PI + 2*Math.PI * getClockMeasureProgress()) => float bloom_pulse;
    0.9 - (bloom_pulse / 2.) => float bloom_intensity;
    bloom_pass.intensity(bloom_intensity);

    // Galactic rotation
    getSongProgress() * 2. * Math.PI => float rotationProgress;
    // galaxy.rotateZ(Math.PI * 0.01 * GG.dt());
    galaxy.rot(@(0, 0, rotationProgress));

    handleUserInput();

    // Camera storyteller
    // // 0.01 => float zoomOutRate;
    solarSystemNotes @=> GGen target;
    // 0.02 => float zoomOutRate;
    // if (getClockMeasure() > 4) 0.1 => zoomOutRate;
    // if (getClockMeasure() > 8) 0.2 => zoomOutRate;
    // if (getClockMeasure() > 16) {
    //     0.2 => zoomOutRate;
    // }

    // cam.posZ(cam.posZ() + zoomOutRate * GG.dt());
    // cam.lookAt(target.pos());c

    // follow 1 system
    target.posWorld() => vec3 gPos;
    cam.posX(gPos.x);
    cam.posY(gPos.y);
    // cam.posY(target.globalPosY);


    // move outward and rotate in polar coords
}

