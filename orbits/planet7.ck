// Start position and orbit circle

SphereGeometry sphere_geo;
FlatMaterial mat3;

Color.GREEN => vec3 planet_color;
mat3.color(planet_color);
GMesh sphere(sphere_geo, mat3) @=> GMesh planet;
0.5 => float planet_radius;
planet.sca(planet_radius);
planet --> GG.scene();



1.3 => float orbit_radius;
0.8 * Math.PI  => float theta;

0.6::second => dur BEAT_DUR; // 100 BPM
4 => float BEAT_COUNT;
BEAT_COUNT * BEAT_DUR  => dur period; // "year"?

// how many circles?
1=> int NUM_CIRCLES;
// how many vertices per circle? (more == smoother)
128 => int N;
// normalized radius
orbit_radius => float RADIUS;

// creating a custom GGen class for a 2D circle
class Circle extends GGen
{
    // for drawing our circle
    GLines circle --> this;
    // randomize rate
    Math.random2f(2,3) => float rate;
    // default color
    color( planet_color );
    // default line width
    circle.width(.01);
    // does it pulse?
    0 => float pulse;
    0 => float radius;

    // initialize a circle
    fun void init( int resolution, float radius, float newPulse )
    {
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

Circle circ;
circ.init( N, RADIUS, 0 );
circ --> GG.scene(); // TODO: Why --> vs => ... --> for visual, => for audio
@( 0,0,0 ) => circ.pos;


// Add a "tick" at each "beat" within the period
for (int i; i < BEAT_COUNT; i++) {

    Circle tick;
    .2 => float TICK_RADIUS;
    tick.init( N, TICK_RADIUS, 0.05 );
    tick --> GG.scene(); // TODO: Why --> vs => ... --> for visual, => for audio

    (period) / BEAT_COUNT => dur stepSize;
    (stepSize * i) / period=> float phase; // phase from 0 -> 1
    2 * Math.PI * phase => theta; // map phase to angle
    @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => tick.pos;
}



while (true) {
    GG.nextFrame() => now;
    (now % period) / period=> float phase; // phase from 0 -> 1
    2 * Math.PI * phase => theta; // map phase to angle
    @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => sphere.pos;
}
