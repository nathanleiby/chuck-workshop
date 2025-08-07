public class SoundMaker {
    fun playSample(string name) {
        // Example samples:
        // "kick.wav"
        // "snare.wav"
        // "hihat-open.wav"
        // "snare-hop.wav"
        "/Applications/miniAudicle.app/Contents/Resources/examples/data/" => string dataPath;
        SndBuf buf => Gain g => dac;
        .2 => g.gain;

        <<< "playing kick drum" >>>;
        buf.read(dataPath + name);
        buf.pos(0);
        buf.length() => now;
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
