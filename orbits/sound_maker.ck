@import "Globals.ck"

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
        // StkInstrument fm;
        Math.randomize();
        Math.random2(0,2) => int variant;
        // if (variant == 0) {
        // <<< "Using SinOsc variant" >>>;
        // new Clarinet() => fm;
        //  BandedWG fm(); // Good sound just quiet!
        // BlowBotl fm(); // glitchy
        // BlowHole
        // Bowed fm();
        // Brass
        // Clarinet
        // Flute
        // Mandolin
        // ModalBar
        // Moog
        // Saxofony
        // Shakers
        // Sitar
        // StifKarp
        // VoicForm
        // FM
        // BeeThree
        // FMVoices
        // HevyMetl
        // PercFlut
        // Rhodey fm();
        // TubeBell fm();
        // Wurley
        //   fm();

        // StkInstrument fm();
        //  => FM fm;
        // }
        // else if (variant == 1) {
        //     <<< "Using SawOsc variant" >>>;
        //     new SawOsc() => osc;
        // } else if (variant == 2) {
        //     <<< "Using TriOsc variant" >>>;
        //     new TriOsc() => osc;
        // }

        // Wurley fm();

        // ModalBar pop => ExpDelay ed => dac;

        // fm => Gain g => dac;

        // Rhodey fm => JCRev r => Echo a => Echo b => Echo c => dac;
        Rhodey fm => dac;
        // fm => JCRev rev => gain g => dac;

        // fm => ExpDelay ed => JCRev rev => gain g => dac;
        // 3::second => ed.max;
        // 3::second => ed.delay;

        // fm => g => dac;
        // fm.noteOff(0.);
        fm.freq(Std.mtof(midiNote));
        // TODO: how to make less "clicky"
        fm.noteOn(.5);
        // g.gain(0.1);

        // length => now;
        0 => int i;
        2 * Math.random2( 1, 3 ) => int pick;
        0 => int pick_dir;
        0.0 => float pluck;
        for(int i; i < pick; i++ )
        {
            Math.random2f(.4,.6) + i*.035 => pluck;
            pluck + -0.02 * (i * pick_dir) => fm.noteOn;
            !pick_dir => pick_dir;
            Globals.BEAT_DUR / 8 => now;
        }
        // fm.noteOff(.0);
        // g.gain(1.);
        // let the sound fade out, before spork is removed removed and sound crunches away
        10::second => now;
    }
}

// 0.8::second => dur T;
// T => dur quarterNote;
// T / 2 => dur eighthNote;

// SoundMaker sm();
// sm.playNote(quarterNote, 42);
// sm.playNote(quarterNote, 44);
// sm.playNote(quarterNote, 46);
// sm.playNote(quarterNote, 47);
// sm.playNote(quarterNote, 42);
// sm.playNote(quarterNote, 44);
// sm.playNote(quarterNote, 46);
// sm.playNote(quarterNote, 47);

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
