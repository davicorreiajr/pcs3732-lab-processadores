  .text
  .globl main

main:
  MOVS r1, #13  /* r1 = dividend */
  MOVS r2, #2 /* r2= divisor */
  MOVS r3, #0 /* r3 = quocient */
  BL alignDivisorLeft
  SWI	0x0

alignDivisorLeft:
  CLZ r0, r1
  CLZ r4, r2
  SUB r5, r4, r0 /* leading 0 of r2 - leading zero of r1 */
  MOV r2, r2, LSL r5
