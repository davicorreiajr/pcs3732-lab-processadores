  .text
  .globl main

main:
  LDR	r0, =0x3ff5000 	    @ r0 = IOPMOD
  LDR r3, =0x3FF5008      @ r3 = IOPDATA
  LDR	r1, =0xf0	          @ seta 1 nos bits [7:4] e 0 nos bits [3:0]
  STR	r1, [r0]	          @ seta IOPMOD 
loop:
  LDR r2, [r3]            @ le os valores de switches do IOPDATA
  MOVS r2, r2, LSL #4     @ shift 4 para esquerda
  STR r2, [r3]            @ IOPDATA recebe numero a ser mostrado
  B loop
end:
  MOVS r0, #0
