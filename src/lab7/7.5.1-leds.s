  .text
  .globl main

main:
  LDR	r0, =0x3ff5000 	    @ r0 = IOPMOD
  LDR r3, =0x3FF5008      @ r3 = IOPDATA
  LDR	r1, =0xf0	          @ seta 1 nos bits [7:4]
  STR	r1, [r0]	          @ seta IOPMOD como output
  MOV r2, #0x0            @ r2 = 0
seta_asc:
  STR r2, [r3]            @ IOPDATA recebe numero a ser mostrado
  LDR r4, =0xfffff
  BL loop
  ADDS r2, r2, #0x10      @ r2 = r2 + 0x10
  CMP r2, #0xf0
  BNE seta_asc
  MOV r2, #0xf0            @ r2 = 0
seta_desc:
  STR r2, [r3]            @ IOPDATA recebe numero a ser mostrado
  LDR r4, =0xfffff
  BL loop
  SUBS r2, r2, #0x10      @ r2 = r2 + 0x10
  CMP r2, #0xf0
  BNE seta_desc
loop:
  SUBS r4, r4, #1
  CMP r4, #0
  BNE loop
fim_loop:
  MOV pc, lr