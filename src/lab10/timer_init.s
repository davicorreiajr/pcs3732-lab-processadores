timer_init:
	mrs r0, cpsr
	bic r0,r0,#0x80
	msr cpsr_c,r0 @enabling interrupts in the cpsr
	LDR r0, INTEN
	LDR r1,=0x10 @bit 4 for timer 0 interrupt enable
	STR r1,[r0]
	LDR r0, TIMER0C
	LDR r1, [r0]
	MOV r1, #0xA0 @enable timer module
	STR r1, [r0]
	LDR r0, TIMER0V
	MOV r1, #0xff @setting timer value
	STR r1,[r0]
	mov pc, lr
