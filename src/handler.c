#include <stdio.h>

volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;
volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
 while(*s != '\0') { /* Loop until end of string */
 *UART0DR = (unsigned int)(*s); /* Transmit char */
 s++; /* Next char */
 }
}

void handler_timer() {
 *TIMER0X = (unsigned int)0x0;
 print_uart0("#");
}
 
void c_entry() {
 print_uart0("Hello world!\n");
}

void undefined() {
 print_uart0("Instrução inválida!\n");
}

void space() {
 print_uart0(" ");
}

void um(){
 print_uart0("1");
}

void dois(){
 print_uart0("2");
}
