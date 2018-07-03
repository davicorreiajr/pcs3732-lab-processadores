  .text
  .globl main

main:
  LDR	r0, =0x3ff5000 	    @ r0 = IOPMOD
  LDR	r1, =0xfe00	        @ seta 1 nos bits [16:10]
  STR	r1, [r0]	          @ seta IOPMOD como output
  LDR r6, =0x4000
  MOV r7, #8
  STR r7, [r6]
seg_display:
  LDR r2, [r6]            @ r2 = MEM[r6] (r2 = 0x4000)
  BL print_in_hex
  MOV r0, #0

print_in_hex:             @ r2 deve ter o valor a imprimir
  STMDB sp!, {r2, r3, r4, r5}
  LDR r3, =0x3FF5008      @ r3 = IOPDATA
  LDR r4, =display_values
  LDR r5, [r4, r2, LSL #2]
  MOV r5, r5, LSL #10
  STR r5, [r3]            @ IOPDATA recebe numero a ser mostrado
  LDMIA sp!, {r2, r3, r4, r5}
  MOV pc, lr

display_values:
    .word    0x5f, 0x06, 0x3b, 0x2f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x77, 0x7c, 0x59, 0x3e, 0x79, 0x71