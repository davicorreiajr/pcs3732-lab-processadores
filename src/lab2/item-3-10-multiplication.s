	.text
	.globl	main
main:
	MOV	r2, #0xFFFFFFFF
	MOV	r1, #0x80000000
	BL	firstfunc
	MOV	r0, #0x18
	LDR	r1, =0x20026
	SWI	0x0
firstfunc:
	MULS r0, r2, r1
	MOV	pc, lr
