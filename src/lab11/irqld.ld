ENTRY(_start)
SECTIONS
{
 . = 0x0;
 .text : { * (.text); }
 supervisorStack = . + 0x2000;
 stackP1 = supervisorStack + 0x2000;
 stackP2 = stackP1 + 0x2000;
 stackP3 = stackP2 + 0x2000;
 irqStack = stackP2 + 0x2000;
}
