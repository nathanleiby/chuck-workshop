SphereGeometry sphere_geo;
FlatMaterial mat3;

mat3.color(Color.RED);
GMesh sphere(sphere_geo, mat3) @=> GMesh planet;
0.3 => float planet_radius;
planet.sca(planet_radius);
planet --> GG.scene();



2. => float orbit_radius;
1.5 * Math.PI  => float theta;

// // render graph
// GG.outputPass() @=> OutputPass output_pass;
// GG.renderPass() --> BloomPass bloom_pass --> output_pass;
// bloom_pass.input(GG.renderPass().colorOutput());
// output_pass.input(bloom_pass.colorOutput());
// output_pass.tonemap(4); // 4 is "ACES"


while (true) {
    GG.nextFrame() => now;
    theta + GG.dt() => theta;
    @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => sphere.pos;


    // theta => theta;
    // // (theta + GG.dt() * 0.00001) % (2 * Math.PI) => theta;
    // @(orbit_radius * Math.cos(theta), orbit_radius * Math.sin(theta), 0) => sphere.translate;

    // // Pulsing sun
    // (Math.sin((GG.fc()/10.)) / 5.) => float bloom_pulse;
    // 0.9 - bloom_pulse => float bloom_intensity;
    // bloom_pass.intensity(bloom_intensity);
}
