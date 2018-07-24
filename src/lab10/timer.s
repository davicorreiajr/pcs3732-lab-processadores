handler_timer:
	LDR r0, TIMER0X
	MOV r1, #0x0
	STR r1, [r0] @Escreve no registrador TIMER0X para limpar o pedido de interrupção

	@ Inserir código que sera executado na interrupção de timer aqui (chaveamento de processos, ou alternar LED por exemplo)

	LDMFD sp!, {r0 - r3,lr}
	mov pc, r14 @retorna
	