_Reset:
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

_do_software_interrupt: @Rotina de Interrupçãode software
	add r1, r2, r3 @r1 = r2 + r3
	mov pc, r14 @volta p/ o endereço armazenado em r14

_do_irq_interrupt: @Rotina de interrupções IRQ
	STMFD sp!, {r0 - r3, LR} @Empilha os registradores
	LDR r0, INTPND @Carrega o registrador de status de interrupção
	LDR r0, [r0]
	TST r0, #0x0010 @verifica se é uma interupção de timer
	BNE handler_timer @vai para o rotina de tratamento da interupção de timer
	LDMFD sp!, {r0 - r3,lr} @retorna
	mov pc, r14
