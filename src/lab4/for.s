  .text
  .globl main

main:
  MOVS r0, #0 /* i */
  MOVS r1, #0x100 /* r1 = a */
  MOVS r2, #0x200 /* r2 = b */
loop:
  CMP r0, #8
  BGE end
  RSB r3, r0, #7 /* 7 - i */
  LDR r4, [r2, r3, LSL #2]
  STR r4, [r2, r0]
  ADDS, r0, r0, #1
  B loop
end: