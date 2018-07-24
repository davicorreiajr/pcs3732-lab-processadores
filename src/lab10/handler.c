volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;

void handlerTimer() {
    *TIMER0X = 0;
}