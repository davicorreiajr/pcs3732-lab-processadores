  .text
  .globl main

main:
  MOVS r0, #0                 @ i = 0
  MOVS r1, #0x4000            @ r1 = a
  MOVS r2, #0x5000            @ r2 = b
loop:
  CMP r0, #8
  BGE end
  RSB r3, r0, #7              @ 7 - i
  LDR r4, [r2, r3, LSL #2]    @ r4 = b[7 - i]
  STR r4, [r2, r0, LSL #2]
  ADDS r0, r0, #1
  B loop
end:
