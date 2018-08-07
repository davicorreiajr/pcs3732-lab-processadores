ENTRY(_start)
SECTIONS
{
 . = 0x0;
 .text : { * (.text); }
 supervisorStack = . + 0x1000;
 stackP1 = supervisorStack;
 stackP2 = supervisorStack + 0x2000;
 irqStack = stackP2 + 0x1000;
}
