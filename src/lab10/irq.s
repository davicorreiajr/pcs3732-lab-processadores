.global _start
.text
_start:
	B Reset @posição 0x00 - Reset
	B UndefinedHandler @posição 0x04 - Intrução não-definida
	B . /* SWI */
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

	@setando os valores de FIQ
	MRS r0, cpsr    @ salvando o modo corrente em R0
	MSR cpsr_ctl, #0b11010001 @ alterando o modo para FIQ - o SP eh automaticamente chaveado ao chavear o modo
	LDR sp, =0x1000 @ a pilha do FIQ eh setada 
	MSR cpsr, r0 @ volta para o modo anterior

	BL main
	B .

UndefinedHandler:
	B .

SoftwareInterruptHandler:
	add r1, r2, r3 @r1 = r2 + r3
	mov pc, r14 @volta p/ o endereço armazenado em r14

IRQHandler:
	STMFD sp!, {R0-R12, lr}
	LDR r0, INTPND @Carrega o registrador de status de interrupção
	LDR r0, [r0]
	TST r0, #0x0010 @verifica se é uma interupção de timer
	BNE handlerTimer @vai para o rotina de tratamento da interupção de timer
	SUB lr, #4
	LDMFD sp!, {R0-R12, pc}^

handlerTimer:
	LDR r0, TIMER0X
	MOV r1, #0x0
	STR r1, [r0] @Escreve no registrador TIMER0X para limpar o pedido de interrupção

	@ Inserir código que sera executado na interrupção de timer aqui (chaveamento de processos, ou alternar LED por exemplo)

	LDMFD sp!, {r0 - r3,lr}
	mov pc, r14 @retorna

main:
	BL timerInit @initialize interrupts and timer 0
stop: b stop

timerInit:
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

INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 interrupt clear register
