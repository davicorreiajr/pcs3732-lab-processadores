  .text
  .globl main

main:
  MOVS r0, #0               @ r0 = x
  MOVS r1, #8               @ r1 = y
  MOVS r2, #0x100           @ r2 = array address
  MOVS r4, #10              @ r3 = 10
  MOVS r5, #5               @ r3 = 5
  STR r4, [r2, r5, LSL #2]
  LDR r3, [r2, r5, LSL #2]
  ADDS r0, r3, r1
end:
