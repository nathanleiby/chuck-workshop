
- let's think the following thought: "how could this not work?"

- UGen "an object that processes digital audio"

- "This personified sinosc"
- "It's a weird feeling, to be coded up"

- FrameRate in video:
    - TV: 29.976 TV frames per second (PAL)
    - Lotr: 24 frames per second
    - Hobbit: 48 frames per second
    - "doubling the frame rate doesn't make a movie better.. at least not to me"
    - Gaming: people want 100+ FPS in CounterStrike
    - VR: at least 90hz
    - Some games are locked at some FPS (30FPS)
- In Audio, we have a similar concept.
    - In Chuck, you can go down to a very fine level of granularity. (`1::samp => now;`)
      - You can actually go to sub-sample! `0.1::samp`
    - can go to higher time (hour, day, week)
        - longest dur is `year`
        - potentially interesting for installations
- Q: where does ChucK get its time from? A: from your sound card.
   - it counts samples and turns them into a time unit
   - chucks time is locked to audio

- `blit` examples have become a meme / theme song for ChucK
    - uses `mtof` to convert MIDI note to frequency
    - blit3 - waiting must for Spork's concert
    - blit4 - rising, fizzing .. W25 hackathon - harmonic series like, dominant 7 chord feel
        - `Blit s => LPF lpf => PoleZero dcb => ADSR e => Gain g => JCRev r => dac;`
            - low pass filter
            - pole zero filte
            - adsr envelope
            - jcrev reverb
        - echo var was named "eicho" because that's someone on their team?!
- wind - `wind2.ck`
- thx - `thx.ck`
    - approximation of the THX "deep note" from cinema
- q: can you easily visualize the state of the audio chain? (DAG?)
- q: how can you tell if ChucK is failing to keep up with real time?
- sheperd tones - `sheperd.ck`
    - "infinite rising tone" (or falling)
- super mario bros - `smb.ck`
    - really faithful repro
- How might we run several ChucK samples and synchronize them?
  - lots of possible ways to synchronize.
  - parallelism -- multiple chuck programs running concurrently
  - option 1:
    1. agree on a time period
    2. have each sync to the by `now % T`
  - option 2: `spork`
    - `chant.ck`
        - 3 programs running at same time
            - `doImpulse()` - models the glottis of throat opening and closing
            - `doInterpolation()` - smoothing as you move between pitches
            - `main()` - choose the scale note and vowel to sing
            - formant imply vowel
                - first 3 peaks map to vowel
        - how? `spork ~ doImpulse()`
        - "spork a shred" (fork a thread)
        - "shreds managed by shreduler"
    - `clap.ck`
      - Steve Reich clapping music - 2 shreds

ChuGL

structure:
- initialization
- data
- runtime


---



Bluetooth headphones can cause weird behavior in ChucK.
There's a sample rate issue.
But can use the input mic from laptop paired with output of Bluetooth headphones.

"They make crashing so fun, like a day on the beach. No, it's not!"

'it's all good'. only rule: "protect your ears" -- super loud

"We want audio to be smooth, without glitches. Unless that's what we intended"
