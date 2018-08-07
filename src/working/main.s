.global _start
.global linhaA
.global linhaB
.global nproc
.text
_start:
    b _Reset                            @posição 0x00 - Reset
    ldr pc, _undefined_instruction      @posição 0x04 - Intrução não-definida
    ldr pc, _software_interrupt         @posição 0x08 - Interrupção de Software
    ldr pc, _prefetch_abort             @posição 0x0C - Prefetch Abort
    ldr pc, _data_abort                 @posição 0x10 - Data Abort
    ldr pc, _not_used                   @posição 0x14 - Não utilizado
    ldr pc, _irq                        @posição 0x18 - Interrupção (IRQ)
    ldr pc, _fiq                        @posição 0x1C - Interrupção (FIQ)

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq

INTPND:   .word 0x10140000 @Interrupt status register
INTSEL:   .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN:    .word 0x10140010 @interrupt enable register
TIMER0L:  .word 0x101E2000 @Timer 0 load register
TIMER0V:  .word 0x101E2004 @Timer 0 value registers
TIMER0C:  .word 0x101E2008 @timer 0 control register
TIMER0X:  .word 0x101E200c @timer 0 interrupt clear register

_Reset:
    MRS r0, cpsr    			@ salvando o modo corrente em R0
    MSR cpsr_ctl, #0b10010 		@ alterando o modo para irq - o SP eh automaticamente 						@ 							@chaveado ao chavear o modo
    LDR sp, =irq_stack_top 		@ a pilha de irq eh setada 
    MSR cpsr, r0 			@ volta para o modo anterior
    LDR sp, =stack_top
	ADR r2, linhaA+52
	ADR r1, taskA
	STR sp, [r2]
	STR r1, [r2, #8]!
    	AND r0, r0, #0x3F
	STR r0, [r2, #4]

	
	ADR r2, linhaB+52
	ADR r3, taskB
	SUB r1, sp, #0x1000
	STR r1, [r2]
	STR r3, [r2, #8]!
	STR r0, [r2, #4]
    bl  main
    b   .

undefined_instruction:
    b   .

software_interrupt:
    b   do_software_interrupt @vai para o handler de interrupções de software

prefetch_abort:
    b   .

data_abort:
    b   .

not_used:
    b   .

irq:
    b   do_irq_interrupt      	@vai para o handler de interrupções IRQ

fiq:
    b   .

do_software_interrupt:        	@Rotina de Interrupção de software
	add r1, r2, r3          @r1 = r2 + r3
	mov pc, r14             @volta p/ o endereço armazenado em r14

do_irq_interrupt:            	@Rotina de interrupções IRQ
	STMFD sp!, {r0-r1}	@Salva registradores r0 e r1 para poder usá-los nesta função 
	ADR r0, nproc		@Calcula endereço de nproc
	LDR r1, [r0]		@Carrega valor de nproc
	CMP r1, #0		@Compara para verificar qual contexto esta
	BEQ contextoA_B		@Pula para contextoA_B
	BNE contextoB_A		@Pula para contextoB_A

contextoA_B:
	ADD r1, r1, #1		@Como está no prog A incialmente temos de somar 1 no nproc para identifica que prog B estará executando 
	STR r1, [r0]		@Atualiza valor de nproc
	LDMFD sp!, {r0-r1}	@Recupera os registradores r0 e r1
	
	@Guarda registradores taskA
	STMFD sp!, {r1}		@Salva r1 na pilha para não perder o contexto
	ADR r1, linhaA		@Calcula endereço de LinhaA
	STMIA r1!, {r0}		@Salva r0 na LinhaA e atualiza o index de r1
	MOV r0, r1		@Troca o endereço de LinhaA+index de r1 para r0
	LDMFD sp!, {r1}		@Recupera r1 da pilha
	STMIA r0!, {r1-r12}	@Salva r1 a r12 na LinhaA e atualiza o index de r0
	ADD r0, r0, #8		@Pula os endereços de SP e LR, estes serão inseridos mais para frente
	MRS r2, spsr		@Guarda spsr no r2
	SUB r1, LR, #4		@LR aponta para a instrução seguinte ao invés da instrução de retorno quando se entra em uma interrupção (coisa 				@do arms), para apontar para a instrução de retorno devemos subtrair 4. Esse valor será o PC e será guardado em 				@r1 
	STMIA r0, {r1-r2}	@Guarda PC e SPSR na LinhaA
	ORR r2, r2, #0b11000000	@Garante que exista 1 nos campos I e F do cpsr, para que não ocorram interrupções quando mudarmos de Modo para 					@pegar os valores de SP e LR 
	SUB r0, r0, #8		@Retorna o index de LinhaA para apontar para o endereço de SP
	MRS r1, cpsr		@Guarda o cpsr para poder mudar de Modo
	MSR cpsr_c, r2		@Muda para o Modo do processo A 
	STMIA r0!, {SP, LR}	@Guarda o valor de SP e LR em LinhaA
	MSR cpsr, r1		@Retorna para o Modo de Interrupções

	@Logica de limpar requisição de interrupção
	LDR r0, INTPND          @Carrega o registrador de status de interrupção
	LDR r0, [r0]		@Carrega valor que está no INTPND

	TST r0, #0x0010         @Verifica se é uma interupção de timer
	BLNE handler_timer      @Vai para o rotina de tratamento da interupção de timer
	
	@Recupera registradores taskB
	ADR r0, linhaB+60	@Calcula o endereço de PC do processo B, que está guardado em LinhaB 
	LDMIA r0, {r1, r2}	@Carrega o PC em r1 e SPSR (que está em linhaB+64) em r2
	STMFD sp!, {r1}		@Guarda PC do processo B na pilha
	SUB r0, r0, #48		@Retorna para o endereço de r3 na LinhaB
	LDMIA r0, {r3-r12}	@Recupera valores de r3 a r12 do processo B, que estavam em LinhaB 
	STMFD sp!, {r3-r12}	@Coloca na pilha os registradores de r3 a r12. 
				@Pilha => PC, r12, ..., r3 
	MOV r3, r2		@Move SPSR para r3
	SUB r4, r0, #12		@Calcula o endereço do início da LinhaB, ou seja aponta para registrador 0 do processo B
	LDMIA r4!, {r0-r2}	@Carrega os registradores de r0 a r2 do processo B, r4 aponta para LinhaB+12
	STMFD sp!, {r0-r2}	@Coloca na pilha os registradores de r0 a r12
				@Pilha => PC, r12, ..., r3, r2, r1, r0
	ADD r0, r4, #40		@Aponta para o LinhaB+52, ou seja, aponta para o endereço de SP de processo B
	MRS r1, cpsr		@Carrega valor de CPSR em r1
	ORR r4, r3, #0b11000000	@Garante que exista 1 nos campos I e F do cpsr, para que não ocorram interrupções quando mudarmos de Modo para 					@pegar os valores de SP e LR
	MSR cpsr_c, r4		@Altera o Modo para o Modo do Processo B, com interrupções desabilitadas
	LDMIA r0!, {SP, LR}	@Carrega o SP e o LR do processo B que estavam na LinhaB+52 e LinhaB+56
	MSR cpsr, r1		@Retorno para o Modo de Interrupção
	MSR spsr, r3		@Altera para o Modo do Processo B com as interrupções habilitadas
	LDMFD sp!, {r0-r12, PC}^@Carrega da pilha os valores de PC a R0 e atualiza o valor do CPSR
	
contextoB_A:
	SUB r1, r1, #1	
	STR r1, [r0]
	LDMFD sp!, {r0-r1}
	@Guarda registradores taskB
	STMFD sp!, {r1}
	ADR r1, linhaB
	STMIA r1!, {r0}
	MOV r0, r1
	LDMFD sp!, {r1}
	STMIA r0!, {r1-r12}
	ADD r0, r0, #8
	MRS r2, spsr
	SUB r1, LR, #4
	STMIA r0, {r1-r2}
	ORR r2, r2, #0b11000000
	SUB r0, r0, #8
	MRS r1, cpsr
	MSR cpsr_c, r2
	STMIA r0!, {SP, LR}
	MSR cpsr, r1

	@Logica de limpar requisição de interrupção
	LDR r0, INTPND            @Carrega o registrador de status de interrupção
	LDR r0, [r0]

	TST r0, #0x0010           @verifica se é uma interupção de timer
	BLNE handler_timer        @vai para o rotina de tratamento da interupção de timer
	
	@Recupera registradores taskA
	ADR r0, linhaA+60
	LDMIA r0, {r1, r2}
	STMFD sp!, {r1}
	SUB r0, r0, #48
	LDMIA r0, {r3-r12}
	STMFD sp!, {r3-r12}
	MOV r3, r2
	SUB r4, r0, #12
	LDMIA r4!, {r0-r2}
	STMFD sp!, {r0-r2}
	ADD r0, r4, #40
	MRS r1, cpsr
	ORR r4, r3, #0b11000000
	MSR cpsr_c, r4
	LDMIA r0!, {SP, LR}
	MSR cpsr, r1
	MSR spsr, r3
	LDMFD sp!, {r0-r12, PC}^

@handler_timer:
@    STMFD sp!, {r0-r3, lr}
@    LDR r0, TIMER0X
@    MOV r1, #0x0
@    STR r1, [r0]              @Escreve no registrador TIMER0X para limpar o pedido de interrupção

    @Inserir código que sera executado na interrupção de timer aqui (chaveamento de processos,  ou 	   	@alternar LED por exemplo)
@    LDMFD   sp!, {r0-r3,lr}   @retorna
@    mov pc, r14

timer_init:
    LDR r0, INTEN
    LDR r1, =0x10             @bit 4 for timer 0 interrupt enable
    STR r1, [r0]
    LDR r0, TIMER0L
    LDR r1, =0xff	      @setting timer value
    STR r1, [r0]
    LDR r0, TIMER0C
    MOV r1, #0xE0             @enable timer module
    STR r1, [r0]
    mrs r0, cpsr
    bic r0, r0, #0x80
    msr cpsr_c,r0             @enabling interrupts in the cpsr
    mov pc, lr

main:
	BL c_entry
	BL timer_init             @initialize interrupts and timer 0
	ADR r0, nproc
	MOV r1, #0
	LDR r1, [r0]
	B taskA

taskA:
	BL um
	B taskA
taskB:
	BL dois
	B taskB

linhaA:
	.space	68
linhaB:
	.space	68
nproc:
	.space	4
