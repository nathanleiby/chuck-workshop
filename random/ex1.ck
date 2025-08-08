// Base library reference:
// https://chuck.stanford.edu/doc/reference/

// ChuGL ref
// https://chuck.stanford.edu/chugl/api/

// If you find a bug, please report it. They'll fix it!
// If something gos wrong, it's probably not your fault, it's ChucK (or ChuGL)!

// Patch a sin osc to the sound output
// => is a "patch cable" from output to input
SinOsc andrew => dac;

// NOTE: the below two are equivalent.
// version 1:
// 1108.73 => andrew.freq;
// .5 => andrew.gain;


// version 2:
// andrew.freq(440); // frequency
// andrew.gain(.5); // amplitude

// You need to deal with time, to deal with sound.

// "not just any old looop, an infinite loop!"
// "a loop that never ends. here in ChucK, we write a lot of them"
// note, if the loop caused us to reset the "phase", we'll hear a click
while(true)
{

Math.random2f(30,1000) => andrew.freq; // frequency
andrew.freq(440); // frequency
andrew.gain(.5); // amplitude

// debug print current frequency
<<< andrew.freq() >>>; // <- this caused a crash when 1::samp => in miniaudicle

// 2::second => now;
100::ms;
// 10::ms;
// 1::samp => now;
}


