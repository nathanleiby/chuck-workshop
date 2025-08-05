GText text --> GG.scene();
text.pos(0, -1, 0);
text.sca(0.5);

// public class Note
// {
//     1::second => dur ttl;
//     0::second => dur age;

//     public void setTtl( dur d)
//     { d => ttl; }

//     public void addAge(dur d)
//     { age + d => age; }
// }

// Note notes[10];

fun spawnNote(dur arrivalTime, int noteType)  {
    GTorus note --> GG.scene();
    note.sca(0.2);
    note.pos(-1. * (arrivalTime/second), 0, 0);

    if (noteType == 0) {

    } else if (noteType == 1) {
        note.color(Color.RED);
    } else if (noteType == 2) {
            note.color(Color.GREEN);
    } else if (noteType == 3) {
        note.color(Color.BLUE);
    } else {
        <<< "Invalid note type: " + noteType >>>;
        me.exit();
    }

}

for (int i; i < 10; i++) {
    spawnNote(i::second, i % 3 );
    // new Note();
}

// main loop
while (true)
{
    // Keyboard input
    // check if Q is pressed
    if (GWindow.keyDown(GWindow.Key_Q)) {
        <<< "user pressed 'q'... quitting" >>>;
        me.exit();
    }

    // Check if arrows pressed
    if (GWindow.keyDown(GWindow.Key_Up)) {
        <<< "user pressed 'up'" >>>;
    } else if (GWindow.keyDown(GWindow.Key_Down)) {
        <<< "user pressed 'down'" >>>;
    } else if (GWindow.keyDown(GWindow.Key_Left)) {
        <<< "user pressed 'left'" >>>;
    } else if (GWindow.keyDown(GWindow.Key_Right)) {
        <<< "user pressed 'right'" >>>;
    }

    GG.nextFrame() => now;
    text.text("Frame: " + GG.fc());
}
