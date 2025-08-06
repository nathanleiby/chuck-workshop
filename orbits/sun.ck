SphereGeometry sphere_geo;
FlatMaterial mat3;

mat3.color(2. * Color.YELLOW);

GMesh sphere(sphere_geo, mat3) --> GG.scene();

@(0, 0, 0) => sphere.translate;

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

    // Pulsing sun
    (Math.sin((GG.fc()/10.)) / 5.) => float bloom_pulse;
    0.9 - bloom_pulse => float bloom_intensity;
    bloom_pass.intensity(bloom_intensity);
}
