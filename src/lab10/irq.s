.global _start
.text
_start:
	b _Reset @posição 0x00 - Reset
	ldr pc, _undefined_instruction @posição 0x04 - Intrução não-definida
	ldr pc, _software_interrupt @posição 0x08 - Interrupção de Software
	ldr pc, _prefetch_abort @posição 0x0C - Prefetch Abort
	ldr pc, _data_abort @posição 0x10 - Data Abort
	ldr pc, _not_used @posição 0x14 - Não utilizado
	ldr pc, _irq @posição 0x18 - Interrupção (IRQ)
	ldr pc, _fiq @posição 0x1C - Interrupção(FIQ)

@_undefined_instruction: .word undefined_instruction
@_software_interrupt: .word software_interrupt
@_prefetch_abort: .word prefetch_abort
@_data_abort: .word data_abort
@_not_used: .word not_used
@_irq: .word irq
@_fiq: .word fiq

_Reset:
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

	bl main
	b .

_undefined_instruction:
 	b .

_software_interrupt:
	b do_software_interrupt @vai para o handler de interrupções de software

_prefetch_abort:
	b .

_data_abort:
 	b .

_not_used:
 	b .

_irq:
	b do_irq_interrupt @vai para o handler de interrupções IRQ

_fiq:
 	b .

do_software_interrupt: @Rotina de Interrupçãode software
	add r1, r2, r3 @r1 = r2 + r3
	mov pc, r14 @volta p/ o endereço armazenado em r14

do_irq_interrupt: @Rotina de interrupções IRQ
	STMFD sp!, {R0-R12, lr}
	LDR r0, INTPND @Carrega o registrador de status de interrupção
	LDR r0, [r0]
	TST r0, #0x0010 @verifica se é uma interupção de timer
	BNE handler_timer @vai para o rotina de tratamento da interupção de timer
	LDMFD sp!, {R0-R12, pc}^

handler_timer:
	LDR r0, TIMER0X
	MOV r1, #0x0
	STR r1, [r0] @Escreve no registrador TIMER0X para limpar o pedido de interrupção

	@ Inserir código que sera executado na interrupção de timer aqui (chaveamento de processos, ou alternar LED por exemplo)

	LDMFD sp!, {r0 - r3,lr}
	mov pc, r14 @retorna
	
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

main:
	bl timer_init @initialize interrupts and timer 0
stop: b stop

INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 interrupt clear register
