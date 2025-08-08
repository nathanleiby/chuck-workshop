
// GPlane is a GGen
// GGen means it has pos, rot, and scale .. andcan be grucked to other GGens
// GPlane plane --> GG.scene();

FlatMaterial flat_material; // how it looks
PlaneGeometry plane_geo; // what shape
GMesh plane(plane_geo, flat_material) --> GG.scene();
// GPlane plane --> GG.sccene(); // equiv
// GPlane plane() --> GG.scene(); // equiv?

GPlane plane2 --> GG.scene();
plane2.pos(1., 0, 0); // move it back a bit
plane2.color(Color.RED);
GPlane plane3 --> GG.scene();
plane3.pos(-1., 0, 0);
plane3.color(Color.GREEN);

// if you're doing Pixel art, you probably don't want 3d lighting, and instead want "flat shading"
// default Material is PhongMaterial. But we may prefer FlatMaterial here.

TextureLoadDesc load_desc;
true => load_desc.flip_y;
Texture.load(me.dir() + "./assets/flare-tng-1.png") @=> Texture tex;
// plane.scaY(0.5);
// Texture.load(me.dir() + "./assets/cat.png", load_desc) @=> Texture tex2;
plan.scaX(5.);
Texture.load(me.dir() + "./assets/birb-idle.png", load_desc) @=> Texture tex2;


// TODO: how to update the texture point by point?
// GG.nextFrame() => now;
// for (auto t : tex.data()) {
//     <<< "" + t >>>;
// }


// plane.colorMap(tex); // interestingly, if you use an invalid texture, it makes the plane turn purple!
flat_material.colorMap(tex2);
plane2.colorMap(tex);
plane3.colorMap(tex);

while (true) {
    GG.nextFrame() => now;
}
