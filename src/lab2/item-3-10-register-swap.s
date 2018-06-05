	.text
	.globl	main
main:
	LDR	r1, =0xF631024C
	LDR	r2, =0x17539ABD
	BL	firstfunc
	LDR	r0, =0x18
	LDR	r1, =0x20026
	SWI	0x123456
firstfunc:
	EOR	r1, r2, r1
	EOR	r2, r2, r1
	EOR	r1, r1, r2
	MOV	pc, lr
