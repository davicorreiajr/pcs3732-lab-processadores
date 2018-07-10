	.file	"imprime-pre.c"
	.section	.rodata
	.align	2
	.global	str
	.data
	.align	2
	.type	str, %object
	.size	str, 4
str:
	.ascii	"numero = %d\n\000"
	.text
	.align	2
	.global	imprime
	.type	imprime, %function
imprime:
	@ args = 0, pretend = 0, frame = 4
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #4
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bge	.L2
	mov	r0, #1
	bl	exit
.L2:
	ldr	r0, =str
	ldr	r1, [fp, #-16]
	bl	printf
	
	ldr	r3, [fp, #-16]
	sub	r3, r3, #1
	mov	r0, r3
	bl	imprime
	ldmfd	sp, {r3, fp, sp, pc}
	.size	imprime, .-imprime
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	mov	r0, #5
	bl	imprime
	mov	r3, #0
	mov	r0, r3
	ldmfd	sp, {fp, sp, pc}
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.3"
