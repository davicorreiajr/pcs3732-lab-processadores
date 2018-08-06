.global _start
.text
_start:
	B Reset @posição 0x00 - Reset
	B UndefinedHandler @posição 0x04 - Instrução não-definida
	B SoftwareInterruptHandler @posição 0x08 - software interrupt
	B . /* Prefetch Abort */
	B . /* Data Abort */
	B . /* reserved */
	B IRQHandler
	B . /* FIQ */

Reset:
	@setando os valores de IRQ
	MRS r0, cpsr    @ salvando o modo corrente em R0
	MSR cpsr_ctl, #0b11010010 @ alterando o modo para IRQ - o SP eh automaticamente chaveado ao chavear o modo
	LDR sp, =0x2000 @ a pilha de IRQ eh setada 
	MSR cpsr, r0 @ volta para o modo anterior

	@setando os valores de supervisor
	MRS r0, cpsr    @ salvando o modo corrente em R0
	MSR cpsr_ctl, #0b11010011 @ alterando o modo para supervisor - o SP eh automaticamente chaveado ao chavear o modo
	LDR sp, =0x1000 @ a pilha do supervisor eh setada 
	MSR cpsr, r0 @ volta para o modo anterior

	BL main
	B .

UndefinedHandler:
	B .

SoftwareInterruptHandler:
	add r1, r2, r3 @r1 = r2 + r3
	mov pc, r14 @volta p/ o endereço armazenado em r14

IRQHandler:
	@ SUB lr, lr, #4
	@ STMFD sp!, {R0-R12, lr}

	SUB lr, lr, #4
	STR r0, currentProcess

	LDR r0, currentProcess
	ADD r0, r0, #4

	STMIA r0!, {r1-r12}

	MOV r1, lr
	MRS r2, spsr
	STMIA r0!, {r1, r2}	@ pc e cpsr do programa principal
	
	MRS r1, cpsr   		 				@ salvando o modo corrente em R0
	MSR cpsr_ctl, #0b11010011 @ alterando o modo para supervisor
	STMIA r0!, {sp, lr} 			@ lr e sp do programa principal
	MSR cpsr, r1 							@ volta para o modo anterior

	LDR r0, currentProcess
	LDR r1, nextProcess
	STR r1, currentProcess
	STR r0, nextProcess

	LDR r0, INTPND @Carrega o registrador de status de interrupção
	LDR r0, [r0]
	TST r0, #0x0010

	LDR r0, TIMER0X
	MOV r1, #0x0
	STR r1, [r0]

	B loadRegisters
	
	@ LDR r0, INTPND @Carrega o registrador de status de interrupção
	@ LDR r0, [r0]
	@ TST r0, #0x0010 @verifica se é uma interupção de timer
	@ BLNE handlerTimer @vai para o rotina de tratamento da interupção de timer
	
	@ LDMFD sp!, {R0-R12, pc}^

main:
	@ r0 - r12, pc, cpsr, sp,lr
	LDR r0, =linhaA
	LDR r1, =linhaB
	LDR r3, =currentProcess
	LDR r4, =nextProcess
	STR r0, [r3]
	STR r1, [r4]

	LDR r5, =p1
	MRS r6, cpsr
	LDR r7, =stackP1

	STR r5, [r0, #52]
	STR r6, [r0, #56]
	STR r7, [r0, #60]

	LDR r5, =p2
	MRS r6, cpsr
	LDR r7, =stackP2

	STR r5, [r1, #52]
	STR r6, [r1, #56]
	STR r7, [r1, #60]


	BL timerInit @initialize interrupts and timer 0

	B p1

	
@ stop:
@ 	BL wait
@ 	BL print_espaco
	@ b stop


timerInit:
	mrs r0, cpsr
	bic r0,r0,#0x80
	msr cpsr_c,r0 @enabling interrupts in the cpsr
	LDR r0, TIMER0C
	LDR r1, [r0]
	MOV r1, #0xA0 @enable timer module
	STR r1, [r0]
	LDR r0, TIMER0L
	MOV r1, #0xff @setting timer value
	STR r1,[r0]
	LDR r0, INTEN
	LDR r1,=0x10 @bit 4 for timer 0 interrupt enable
	STR r1,[r0]
	mov pc, lr

loadRegisters:
	LDR r0, currentProcess

	MRS r3, cpsr
	MSR cpsr_ctl, #0b11010011 				@ alterando o modo para supervisor
	LDR r2, [r0, #60]
	MOV sp, r2
	LDR r2, [r0, #64]
	MOV lr, r2
	MSR cpsr, r3

	LDR r1, [r0, #56]
	MSR spsr_cxsf, r1
	
	LDMFD r0, {R0-R12, pc}^
	
linhaA: .space 68
linhaB: .space 68

INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 clear register
nextProcess: .word 0x1
currentProcess: .word 0x1
