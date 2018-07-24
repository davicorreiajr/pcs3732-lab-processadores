#include <stdio.h>
int *TIMER0X = 0x101E200c;

void handlerTimer() {
    *TIMER0X = 0;
}