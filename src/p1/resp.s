@ Davi Cesar Correia Jr. - 8988880
  .text
  .globl main

main:
  LDR r7, =8988880  /* r7 = dividend = nusp 8988880 */
  LDR r6, =80000 @ r6 = base address of primes
  MOVS r8, #1
comeco:
  MOVS r1, r7
  ADDS r8, r8, #1 @ r8 = r8 + 1
  MOVS r2, r8 @ r2 = r8 = divisor
  MOVS r3, #0 /* r3 = quocient */
  CMP r1, r2
  BCC final
  BL alignDivisorLeft
compare:
  CMP r5, #0
  BMI final
  BL divide
  BL shiftDivisorRight
  SUB r5, r5, #1
  B compare
final:
  MOVS r5, r1 /* r5 = remainder */
  MOVS r5, #0
  MOVS r8, #1
  MVN r5, #0
  CMP r1, r5
  BEQ comeco
  STMIB r6, {r8}
  B comeco
  SWI	0x0

alignDivisorLeft:
  CLZ r0, r1
  CLZ r4, r2
  SUB r5, r4, r0 /* r5 = leading 0 of r2 - leading zero of r1 */
  MOV r2, r2, LSL r5
  MOV	pc, lr

divide:
  MOV r10, lr
  CMP r1, r2
  BCC onlyShiftDivisorToLeft
  SUB r1, r1, r2
  MOV r3, r3, LSL #1
  ADD r3, r3, #1
  B endDivide
onlyShiftDivisorToLeft:
  MOV r3, r3, LSL #1
endDivide:
  MOV lr, r10
  MOV	pc, lr

shiftDivisorRight:
  MOV r2, r2, LSR #1
  MOV	pc, lr


@ fatores: .space 10000

.end
