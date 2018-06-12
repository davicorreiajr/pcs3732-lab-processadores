  .text
  .globl main

main:
  LDR r8, =0b1101101010011110101010101011101 /* X */
  LDR r2, =0 /* Z */
  LDR r1, =0b1111 /* Máscara */
  LDR r3, =0 /* Counter */
  LDR r4, =0b1011 /* Gabarito */
  LDR r5, =32 /* MAX */
  SUB r5, r5, #4
loop:
  AND r6, r1, r8
  CMP r6, r4
  ADDEQ r2, r2, #1
  ADD r3, r3, #1
  CMP r3, r5
  BEQ end
  MOV r2, r2, LSL #1
  MOV r1, r1, LSL #1
  MOV r4, r4, LSL #1
  BLT loop
end:
