ENTRY(_start)
SECTIONS
{
 . = 0x0;
 .text : { * (.text); }
 stackP1 = . + 0x1000;
 stackP2 = . + 0x2000;
 stackP3 = . + 0x4000;
}
