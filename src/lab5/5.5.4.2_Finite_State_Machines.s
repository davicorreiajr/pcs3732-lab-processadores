  .text
  .globl main

main:
  LDR r8, =0b0110110 /* X */
  LDR r2, =0 /* Z */
  LDR r1, =0b1111 /* Máscara */
  LDR r3, =0 /* Counter */
  LDR r4, =0b1011 /* Gabarito */
  LDR r9, =0x7 /* MAX */
  SUB r9, r9, #4
  CMP r9, r3
  BMI end
loop:
  AND r6, r1, r8
  CMP r6, r4
  ADDEQ r2, r2, #1
  ADD r3, r3, #1
  CMP r3, r9
  BEQ end
  MOV r2, r2, LSL #1
  MOV r1, r1, LSL #1
  MOV r4, r4, LSL #1
  BLT loop
end:
  MOV r6, r7
