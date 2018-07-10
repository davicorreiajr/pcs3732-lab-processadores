  .text
  .globl main

main:
  LDR	r0, =0x3ff5000 	    @ r0 = IOPMOD
  LDR	r1, =0xfe00	        @ seta 1 nos bits [16:10] e 0 nos bits [3:0]
  STR	r1, [r0]	          @ seta IOPMOD 
  BL get_fourth_switch
  MOVS r5, r7             @ valor inicial do switch. r5 é base de comparacao.
  MOVS r2, #0             @ contador de vezes
  BL print_in_hex
loop:
  BL get_fourth_switch
  CMP r7, r5
  BEQ loop
  BL wait
  CMP r7, r5
  BEQ loop
  ADD r2, r2, #1
  MOV r5, r7
  BL print_in_hex
  B loop
end:
  MOVS r0, #0


@ retorna em r7 o valor do 4o switch, 1 ou 0
get_fourth_switch:
  STMDB sp!, {r3}
  LDR r3, =0x3FF5008
  LDR r7, [r3]            @ le os valores de switches do IOPDATA
  MOVS r7, r7, LSR #1
  MOVCS r7, #1
  MOVCC r7, #0
  LDMIA sp!, {r3}
  MOV pc, lr



 
@ Essa funcao recebe um numero 0 <= x < 16 e printa no display de 7 segmentos
@ O numero x deve estar no  registrador r2
@ Nao retorna nada
print_in_hex:
  STMDB sp!, {r2, r3, r4, r5}
  LDR r3, =0x3FF5008      @ r3 = IOPDATA
  LDR r4, =display_values
  LDR r5, [r4, r2, LSL #2]
  MOV r5, r5, LSL #10
  STR r5, [r3]            @ IOPDATA recebe numero a ser mostrado
  LDMIA sp!, {r2, r3, r4, r5}
  MOV pc, lr

  
@ Espera um tempo
wait:
  STMDB sp!, {r4}
  LDR r4, =0xfffff
wait_loop:
  SUBS r4, r4, #1
  CMP r4, #0
  BNE wait_loop
  LDMIA sp!, {r4}
  MOV pc, lr


  display_values:
    .word    0x5f, 0x06, 0x3b, 0x2f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x77, 0x7c, 0x59, 0x3e, 0x79, 0x71