#include <stdlib.h>
#include <stdio.h>

#include "segment.h"

// Mapemanto do microcontrolador

#define SYSCFG	     0x03ff0000
#define IOPMOD          ((volatile unsigned *)(SYSCFG+0x5000))
#define IOPDATA         ((volatile unsigned *)(SYSCFG+0x5008))

static unsigned int numeric_display [16] =
{
	DISP_0,	DISP_1,	DISP_2,	DISP_3,	DISP_4,	DISP_5,	DISP_6,	DISP_7,	DISP_8,	DISP_9,
    DISP_A,	DISP_B,	DISP_C,	DISP_D,	DISP_E,	DISP_F
};

void imprime(unsigned numero) {
	if ( numero >= 0 & numero <= 0xf )  {
		// *IOPDATA 	&= ~SEG_MASK;
		// *IOPDATA 	|= (unsigned) numeric_display[numero];
		__asm__(
			"mov	r2, #66846720\n\t"
			"add	r2, r2, #217088\n\t"
			"add	r2, r2, #8\n\t"
			"mov	r3, #66846720\n\t"
			"add	r3, r3, #217088\n\t"
			"add	r3, r3, #8\n\t"
			"ldr	r3, [r3, #0]\n\t"
			"bic	r3, r3, #130048\n\t"
			"str	r3, [r2, #0]\n\t"
			"mov	r2, #66846720\n\t"
			"add	r2, r2, #217088\n\t"
			"add	r2, r2, #8\n\t"
			"mov	r3, #66846720\n\t"
			"add	r3, r3, #217088\n\t"
			"add	r3, r3, #8\n\t"
			"ldr	ip, L3\n\t"
			"ldr	r1, [fp, #-16]\n\t"
			"ldr	r0, [r3, #0]\n\t"
			"ldr	r3, [ip, r1, asl #2]\n\t"
			"orr	r3, r0, r3\n\t"
			"str	r3, [r2, #0]\n\t"
			"L1:\n\t"
			"	ldmfd	sp, {r3, fp, sp, pc}\n\t"
			"L4:\n\t"
			"	.align	2\n\t"
			"L3:\n\t"
			"	.word	numeric_display\n\t"
			"	.size	imprime, .-imprime\n\t"
			"	.ident	"GCC: (GNU) 3.4.3"\n\t"

		);
 	}
}
