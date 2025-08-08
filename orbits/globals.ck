public class Globals {
    // TODO: Explore change of tempo
    0.6::second => static dur BEAT_DUR; // 100 BPM
    4 * BEAT_DUR => static dur measure;

    4 => static int songLength;
    0.25 => static float songRate;
    // static Gain predac => dac;
    // Gain _predac @=> static Gain predac;
    //  => dac;
}
