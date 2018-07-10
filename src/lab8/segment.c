#include <stdlib.h>
#include <stdio.h>

#include "segment.h"

// Mapemanto do microcontrolador

#define SYSCFG	     0x03ff0000
#define IOPMOD          ((volatile unsigned *)(SYSCFG+0x5000))
#define IOPDATA         ((volatile unsigned *)(SYSCFG+0x5008))

int main(void) {

	// inicalizaÃ§Ã£o
	*IOPMOD 	|= SEG_MASK;
	*IOPDATA 	|= SEG_MASK;

	unsigned numero = 0x3;

	imprime(numero);

    return 0;
}
