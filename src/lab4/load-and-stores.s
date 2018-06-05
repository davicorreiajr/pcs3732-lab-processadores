  .text
  .globl main

main:
  MOVS r0, #0               @ r0 = x
  MOVS r1, #8               @ r1 = y
  MOVS r2, #0x100           @ r2 = array address
  MOVS r4, #10              @ r4 = 10
  MOVS r5, #5               @ r5 = 5
  STR r4, [r2, r5, LSL #2]  @ array[5] = 10
  B pos
pre:
  LDR r3, [r2, r5, LSL #2]  @ r3 = array[5]
  ADDS r0, r3, r1           @ x = array[5] + y
  STR r0, [r2, r4, LSL #2]  @ array[10] = x
  MOVS r4, #10              @ r4 = 10
  LDR r6, [r2, r4, LSL #2]  @ r6 = array[10]
pos:
  ADDS r2, r2, r5, LSL #2
  LDR r0, [r2], r5, LSL #2
  ADDS r0, r0, r1           @ x = array[5] + y
  STR r0, [r2]
  MOVS r4, #10              @ r4 = 10
  LDR r6, [r2]  @ r6 = array[10]
end:
