.text
.globl main

main:
  MOVS r0, #31
  MOVS r1, #0x5006
  STR r0, [r1]

  MOVS r0, #512
  MOVS r1, #0x500A
  STR r0, [r1]

  LDR r0, =3145
  LDR r1, =0x500E
  STR r0, [r1]

  LDR r0, =1
  LDR r1, =0x5012
  STR r0, [r1]

  LDR r0, =6431235
  LDR r1, =0x5016
  STR r0, [r1]

  LDR r0, =231
  LDR r1, =0x501A
  STR r0, [r1]

  LDR r0, =31234
  LDR r1, =0x501E
  STR r0, [r1]

  LDR r0, =312
  LDR r1, =0x5022
  STR r0, [r1]

  LDR r0, =31123
  LDR r1, =0x5026
  STR r0, [r1]




  LDR r5, =9                 @ r5 = 9
  LDR r0, =0                 @ r0 = 0
  LDR r1, =0x5000            @ r1 = 0x5000
  LDR r2, =0x5006            @ r2 = 0x5006
  LDR r3, =0                 @ r3 = 0
  
loop:
  CMP r0, r5
  BGE end
  LDR r4, [r2], #4    @ r4 = valor em 0x5006
  CMP r4, r3
  MOVSGT r3, r4
  ADDS r0, r0, #1
  B loop
end:
  STR r3, [r1]
