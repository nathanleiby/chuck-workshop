// window title
GG.windowTitle( "Orbits" );
// fullscreen
// GG.fullscreen();
// position
// GG.camera().posZ( 3 );

GOrbitCamera cam --> GG.scene();
GG.scene().camera(cam);
cam.pos(0, 0, 10);


// time loop
while( true )
{
    GG.nextFrame() => now;
}
