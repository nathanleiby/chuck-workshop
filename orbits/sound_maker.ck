
// TODO: pass in a "sound is done" event so we can signal on complete
public class SoundMaker {
    fun playSample(string name) {
        // Example samples:
        // "kick.wav"
        // "snare.wav"
        // "hihat-open.wav"
        // "snare-hop.wav"
        "/Applications/miniAudicle.app/Contents/Resources/examples/data/" => string dataPath;
        SndBuf buf => Gain g => dac;
        // add more variation to drums, for humanity
        Math.random2f(0.11, 0.15) => g.gain;
        // buf.freq() * Math.random2f(0.9, 1.1) =>  buf.freq;

        <<< "playing sample: ", name >>>;
        buf.read(dataPath + name);
        buf.pos(0);
        buf.length() => now;
    }

    fun playNote(dur length, int midiNote) {
        Osc osc;
        Math.randomize();
        Math.random2(0,2) => int variant;
        if (variant == 0) {
            <<< "Using SinOsc variant" >>>;
            new SinOsc() => osc;
        } else if (variant == 1) {
            <<< "Using SawOsc variant" >>>;
            new SawOsc() => osc;
        } else if (variant == 2) {
            <<< "Using TriOsc variant" >>>;
            new TriOsc() => osc;
        }

        Gain g;
        osc => g => dac;
        g.gain(0.);

        osc.freq(Std.mtof(midiNote));
        g.gain(0.1);

        length => now;
        g.gain(0.);
    }
}

// fun void playSample(string name) {
//     // Example samples:
//     // "kick.wav"
//     // "snare.wav"
//     // "hihat-open.wav"
//     // "snare-hop.wav"
//     "/Applications/miniAudicle.app/Contents/Resources/examples/data/" => string dataPath;
//     SndBuf buf => Gain g => dac;
//     .2 => g.gain;

//     <<< "playing kick drum" >>>;
//     buf.read(dataPath + name);
//     buf.pos(0);
//     buf.length() => now;
// }
