  .text
  .globl main

main:
  LDR r1, =30 /* n */
  LDR r2, =0 /* f(n-2) */
  LDR r3, =1 /* f(n-1) */
  LDR r4, =1 /* contador */
loop:
  CMP r4, r1
  BGE end
  ADDS r2, r2, r3
  BVS error
  ADD r4, r4, #1
  B swap

swap:
  EOR r3, r2, r3
  EOR r2, r2, r3
  EOR r3, r3, r2
  B loop

end:
  MOV r0, r3

error:

