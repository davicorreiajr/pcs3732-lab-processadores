volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;
volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
 
void print_uart0(const char *s) {
 while(*s != '\0') { /* Loop until end of string */
 *UART0DR = (unsigned int)(*s); /* Transmit char */
 s++; /* Next char */
 }
}

void handlerTimer() {
    *TIMER0X = 0;
    print_uart0("#");
}

void c_entry() {
 print_uart0("Hello world!\n");
}

void print_espaco() {
 print_uart0(" ");
}

void wait() {
    int i = 50000;
    while (--i < 0){}
}