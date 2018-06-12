  .text
  .globl main

main:
  MOV r0, #1
  LDR r8, =0xaaaa5555 /* X */
  LDR r2, =0 /* Z */
  LDR r1, =0b111 /* Máscara */
  LDR r3, =0 /* Counter */
  LDR r4, =5 /* Gabarito */
  LDR r9, =33 /* MAX */
  SUB r9, r9, #3
  CMP r9, r3
  BMI end
loop:
  AND r6, r1, r8
  CMP r6, r4
  ADDEQ r2, r2, r0, LSL r3
  ADD r3, r3, #1
  CMP r3, r9
  BHI end
  MOV r8, r8, LSR #1
  BLT loop
end:
  MOV r6, r7
