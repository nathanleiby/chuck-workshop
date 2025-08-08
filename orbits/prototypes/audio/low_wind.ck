// https://chuck.stanford.edu/doc/examples/basic/wind.ck

// noise generator, biquad filter, dac (audio output)
Noise n => BiQuad f => dac;
// set biquad pole radius
0.5 => f.prad;
// set biquad gain
.05 => f.gain;
// set equal zeros
1 => f.eqzs;
// our float
0.0 => float t;

// infinite time-loop
while( true )
{
    // sweep the filter resonant frequency
    10.0 + Std.fabs(Math.sin(t)) * 200.0 => f.pfreq;
    t + .01 => t;
    // advance time
    100::ms => now;
}
