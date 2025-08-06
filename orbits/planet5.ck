// Start position and orbit circle

SphereGeometry sphere_geo;
FlatMaterial mat3;

mat3.color(Color.GRAY);
GMesh sphere(sphere_geo, mat3) @=> GMesh planet;
0.6 => float planet_radius;
planet.sca(planet_radius);
planet --> GG.scene();



3.1 => float orbit_radius;
0.5 * Math.PI  => float theta;

0.6::second => dur BEAT; // 100 BPM
8 * BEAT => dur period; // "year"?

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
    color( @(.5, 1, .5) );
    // default line width
    circle.width(.01);

    // initialize a circle
    fun void init( int resolution, float radius )
    {
        // incremental angle from 0 to 2pi in N-2 step, plus to steps to close the line loop
        2*pi / (resolution-2) => float theta;
        // positions of our circle
        vec2 pos[resolution];
        // previous, init to 1 zero
        @(radius) => vec2 prev;
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
        .35 + .25*Math.sin(now/second*rate) => float s;
        circle.sca( s );
        // uncomment for xtra weirdness
        // circle.rotateY(dt*rate/3);
    }
}

Circle circ;
// initialize each
circ.init( N, RADIUS );
// connect it
circ --> GG.scene(); // TODO: Why --> vs =>
// randomize location in XY

@( 0,0,0 ) => circ.pos;


// Add a "tick" at each "beat" within the period


while (true) {
    GG.nextFrame() => now;
    (now % period) / period=> float phase; // phase from 0 -> 1
    2 * Math.PI * phase => theta; // map phase to angle
    @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => sphere.pos;
}
