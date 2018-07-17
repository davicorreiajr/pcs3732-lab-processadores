.section INTERRUPT_VECTOR, "x"
.global _Reset
_Reset:
  B Reset_Handler /* Reset */
  B Undefined_Handler /* Undefined */
  B . /* SWI */
  B . /* Prefetch Abort */
  B . /* Data Abort */
  B . /* reserved */
  B . /* IRQ */
  B . /* FIQ */
 
Reset_Handler:
  @setando os valores de undefined
  MRS r0, cpsr    @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11011011 @ alterando o modo para undefined - o SP eh automaticamente chaveado ao chavear o modo
  LDR sp, =0x2000 @ a pilha de undefined eh setada 
  MSR cpsr, r0 @ volta para o modo anterior
  @setando os valores de supervisor
  MRS r0, cpsr    @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11010011 @ alterando o modo para supervisor - o SP eh automaticamente chaveado ao chavear o modo
  LDR sp, =0x1000 @ a pilha do supervisor eh setada 
  MSR cpsr, r0 @ volta para o modo anterior

  LDR sp, =stack_top
  .word 0xffffffff
  BL c_entry
  B .

Undefined_Handler:
  STMFD sp!, {R0-R12, lr}
  BL undefined
  LDMFD sp!, {R0-R12, pc}^
