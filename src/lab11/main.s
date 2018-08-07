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
	@ setando o sp de IRQ
	MRS r0, cpsr    					@ salvando o modo corrente em r0
	MSR cpsr_ctl, #0b11010010 @ alterando o modo para IRQ - o SP eh automaticamente chaveado ao chavear o modo
	LDR sp, =irqStack 				@ a pilha de IRQ eh setada 
	MSR cpsr, r0 							@ volta para o modo anterior

	@setando os sp do supervisor
	MRS r0, cpsr    					@ salvando o modo corrente em R0
	MSR cpsr_ctl, #0b11010011 @ alterando o modo para supervisor - o SP eh automaticamente chaveado ao chavear o modo
	LDR sp, =supervisorStack 	@ a pilha do supervisor eh setada 
	MSR cpsr, r0 							@ volta para o modo anterior

	BL processSetup
	BL timerInit
	BL enableInterruption
	B p1
	B .

UndefinedHandler:
	B .

SoftwareInterruptHandler:
	add r1, r2, r3 @r1 = r2 + r3
	mov pc, r14 @volta p/ o endereço armazenado em r14

IRQHandler:
	SUB lr, lr, #4					@ lr - 4 = pc do programa principal

	STMFD sp!, {r0}					@ guarda r0 na pilha
	LDR r0, currentProcess	@ carrega currentProcess (&linhaA) em r0
	ADD r0, r0, #4					@ soma 4, pois em r0[0] (currentProcess) ficará r0, guardado anteriormente

	STMIA r0!, {r1-r12}			@ salva registradores r1 a r12

	LDMFD sp!, {r1}					@ restaura o valor de r0 da pilha em r1, que já está guardado
	LDR r2, currentProcess	@ carrega currentProcess em r2, que já está guardado
	STR r1, [r2]						@ salva o valor de r0

	MOV r1, lr
	MRS r2, spsr
	STMIA r0!, {r1, r2}			@ salva pc e cpsr do programa principal
	
	MRS r1, cpsr   		 				@ salvando o modo corrente em r0
	MSR cpsr_ctl, #0b11010011 @ alterando o modo para supervisor
	STMIA r0!, {sp, lr} 			@ salva sp e lr do programa principal
	MSR cpsr, r1 							@ volta para o modo anterior

	LDR r0, currentProcess		@ faz a troca entre currentProcess
	LDR r1, nextProcess				@ e nextProcess
	LDR r2, thirdProcess
	STR r1, currentProcess
	STR r2, nextProcess
	STR r0, thirdProcess

	LDR r0, INTPND 		@ carrega o registrador de status de interrupção
	LDR r0, [r0]			@ e verifica se é do tipo TIMER
	TST r0, #0x0010

	BLNE handlerTimer	@ vai para 'handlerTimer' se a interrupção é TIMER
	B loadRegisters		@ carrega os registradores do modo atual

processSetup:
	@ r0 - r12, pc, cpsr, sp, lr
	LDR r0, =linhaA
	LDR r1, =linhaB
	LDR r8, =linhaC
	LDR r3, =currentProcess
	LDR r4, =nextProcess
	LDR r9, =thirdProcess
	STR r0, [r3]							@ armazena os endereços de linhaA e linhaB
	STR r1, [r4]							@ em currentProcess e nextProcess
	STR r8, [r9]							@ em currentProcess e nextProcess

	LDR r5, =p1								@ pc do processo 1
	MOV r6, #0x13							@ cpsr do processo 1
	LDR r7, =stackP1					@ sp do processo 1

	STR r5, [r0, #52]					@ armazena os valores iniciais necessários
	STR r6, [r0, #56]					@ para o processo 1
	STR r7, [r0, #60]

	LDR r5, =p2								@ pc do processo 2
	MOV r6, #0x13							@ cpsr do processo 2
	LDR r7, =stackP2					@ sp do processo 2

	STR r5, [r1, #52]					@ armazena os valores inicias necessários
	STR r6, [r1, #56]					@ para o processo 2
	STR r7, [r1, #60]

	LDR r5, =p3								@ pc do processo 3
	MOV r6, #0x13							@ cpsr do processo 3
	LDR r7, =stackP3					@ sp do processo 3

	STR r5, [r8, #52]					@ armazena os valores inicias necessários
	STR r6, [r8, #56]					@ para o processo 3
	STR r7, [r8, #60]

	MOV pc, lr

timerInit:
	LDR r0, INTEN
	LDR r1, =0x10       @ bit 4 for timer 0 interrupt enable
	STR r1, [r0]
	LDR r0, TIMER0L
	LDR r1, =0xff	      @ setting timer value
	STR r1, [r0]
	LDR r0, TIMER0C
	MOV r1, #0xA0       @ enable timer module
	STR r1, [r0]
	MOV pc, lr

enableInterruption:
	MRS r0, cpsr
	BIC r0, r0, #0x80
	MSR cpsr_c, r0       @ enabling interrupts in the cpsr
	MOV pc, lr

@ handlerTimer:
@ 	LDR r0, TIMER0X
@ 	MOV r1, #0x0
@ 	STR r1, [r0]
@ 	MOV pc, lr

loadRegisters:
	LDR r0, currentProcess			@ carrega linhaA ou linhaB em r0

	MRS r3, cpsr
	MSR cpsr_ctl, #0b11010011 	@ alterando o modo para supervisor (modo dos processos)
	LDR r2, [r0, #60]
	MOV sp, r2									@ salva sp no modo correto
	LDR r2, [r0, #64]
	MOV lr, r2									@ salva lr no modo correto
	MSR cpsr, r3								@ volta para o modo anterior

	LDR r1, [r0, #56]
	MSR spsr_cxsf, r1						@ seta spsr para "enganar" o processador com ^
	
	LDMFD r0, {r0-r12, pc}^			@ restaura r0-r12 e pc
	
linhaA: .space 68
linhaB: .space 68
linhaC: .space 68

INTPND: .word 0x10140000 	@Interrupt status register
INTSEL: .word 0x1014000C 	@interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 	@interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 clear register
nextProcess: .word 0x1
currentProcess: .word 0x1
thirdProcess: .word 0x1
