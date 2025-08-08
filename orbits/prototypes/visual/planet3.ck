// Rotation rate

SphereGeometry sphere_geo;
FlatMaterial mat3;
mat3.color(Color.BLUE);
GMesh sphere(sphere_geo, mat3) @=> GMesh planet;
0.2 => float planet_radius;
planet.sca(planet_radius);
planet --> GG.scene();



2.5 => float orbit_radius;
0.5 * Math.PI  => float theta;

5::second => dur period; // "year"?

while (true) {
    GG.nextFrame() => now;
    // <<< "Now: ", now / 1::second, "Period: ", period / 1::second, "Now % Period", (now % period) / 1::second >>>;
    (now % period) / period=> float phase; // phase from 0 -> 1
    // <<< "Phase: ", phase, " (", now, ")" >>>;
    2 * Math.PI * phase => theta; // map phase to angle
    // theta + GG.dt() => theta;
    @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => sphere.pos;
}
