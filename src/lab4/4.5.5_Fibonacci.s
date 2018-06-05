  .text
  .globl main

main:
  LDR r1, =12 /* n */
  LDR r2, =0x4000
  LDR r3, =1
  LDR r4, =0
  STRB r4, [r2]
  STRB r3, [r2, r3]
loop:
  SUB r6, r3, #1
  LDRB r4, [r2, r6]
  LDRB r5, [r2, r3]
  ADD r4, r4, r5
  ADD r3, r3, #1
  STRB r4, [r2, r3]
  CMP r3, r1
  BLT loop
end:
