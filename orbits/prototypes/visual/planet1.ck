SphereGeometry sphere_geo;
FlatMaterial mat3;

mat3.color(Color.BROWN);
GMesh sphere(sphere_geo, mat3) @=> GMesh planet;
0.2 => float planet_radius;
planet.sca(planet_radius);
planet --> GG.scene();



0.5 => float orbit_radius;
Math.PI => float theta;
@(orbit_radius, orbit_radius, 0) => sphere.translate;

// // render graph
// GG.outputPass() @=> OutputPass output_pass;
// GG.renderPass() --> BloomPass bloom_pass --> output_pass;
// bloom_pass.input(GG.renderPass().colorOutput());
// output_pass.input(bloom_pass.colorOutput());
// output_pass.tonemap(4); // 4 is "ACES"


while (true) {
    GG.nextFrame() => now;

    // // Pulsing sun
    // (Math.sin((GG.fc()/10.)) / 5.) => float bloom_pulse;
    // 0.9 - bloom_pulse => float bloom_intensity;
    // bloom_pass.intensity(bloom_intensity);
}
