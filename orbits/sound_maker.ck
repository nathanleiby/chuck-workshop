
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

    fun playNote(dur length) {
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

        42 => int rootMidiNote; // current "chord" / "color"

        // various chords:
        // [0, 4, 7, 11] @=> int chordOffsets[];// M7
        // [0, 4, 7, 10] @=> int chordOffsets[];// 7
        [0, 3, 7, 10] @=> int chordOffsets[];// m7
        Math.random2(0, chordOffsets.size() - 1) => int notesIdx;

        // TODO: Randomly adjust octave
        rootMidiNote + chordOffsets[notesIdx] => int midiNote;

        osc.freq(Std.mtof(midiNote));
        g.gain(0.01);

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
