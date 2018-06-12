  .text
  .globl main

main:
  MOVS r0, #0                 @ r0 = i = 0
  MOVS r1, #0b1011            @ r1 = input
  MOVS r2, #0                 @ r2 = count
  MOVS r3, #0                 @ r3 = answer
loop:
  CMP r0, #32
  BGE end
  MOVS r1, r1, LSL #1
  ADDCS r2, r2, #1
  ADDS r0, r0, #1
  B loop
end:
  MOVS r4, r2, LSR #1
  ADDCS r3, r3, #1            @ answer = 1 if count is odd
  SWI	0x0
