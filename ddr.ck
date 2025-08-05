

// Scene Setup =======================================================
GOrbitCamera cam --> GG.scene();
GG.scene().camera(cam);

GText text --> GG.scene();
text.sca(.1);

UI_String text_input(text.text());

UI_Int font_index;
[
    "chugl:cousine-regular",
    "chugl:karla-regular",
    "chugl:proggy-tiny",
    "chugl:proggy-clean",
] @=> string builtin_fonts[];

UI_Float4 text_color;
@(1, 1, 1, 1) => text_color.val;

[0.5, 0.5] @=> float control_points[];

UI_Float line_spacing(1.0);
UI_Float text_scale(text.sca().x);
UI_Bool text_rotate;
UI_Float antialias(text.antialias());

// main loop
while (true)
{
    GG.nextFrame() => now;
    text.text(<< GG.fc() >>);
}
