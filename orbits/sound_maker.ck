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
        Math.random2f(0.22, 0.3) => g.gain;

        <<< "playing sample: ", name >>>;
        buf.read(dataPath + name);
        buf.pos(0);
        buf.length() => now;
    }

    fun playNote(dur length, int midiNote) {
        Math.randomize();
        Math.random2(0,2) => int variant;

        Rhodey fm => dac;

        fm.freq(Std.mtof(midiNote));
        fm.noteOn(.5);

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

        // let the sound fade out, before spork is removed removed and sound crunches away
        10::second => now;
    }
}
