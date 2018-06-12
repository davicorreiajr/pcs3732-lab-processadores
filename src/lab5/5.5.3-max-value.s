.text
.globl main

main:
  MOVS r0, #31
  LDR r1, =0x5004
  STR r0, [r1]

  MOVS r0, #512
  LDR r1, =0x5008
  STR r0, [r1]

  LDR r0, =3145
  LDR r1, =0x500C
  STR r0, [r1]

  LDR r0, =1
  LDR r1, =0x5010
  STR r0, [r1]

  LDR r0, =6431235
  LDR r1, =0x5014
  STR r0, [r1]

  LDR r0, =231
  LDR r1, =0x5018
  STR r0, [r1]

  LDR r0, =31234
  LDR r1, =0x501C
  STR r0, [r1]

  LDR r0, =312
  LDR r1, =0x5020
  STR r0, [r1]

  LDR r0, =31123
  LDR r1, =0x5024
  STR r0, [r1]




  LDR r5, =9                 @ r5 = 9
  LDR r0, =0                 @ r0 = 0
  LDR r1, =0x5000            @ r1 = 0x5000
  LDR r2, =0x5004            @ r2 = 0x5006
  LDR r3, =0                 @ r3 = 0
  
loop:
  CMP r0, r5
  BGE end
  LDR r4, [r2], #4    @ r4 = valor em 0x5006
  CMP r4, r3
  MOVGT r3, r4
  ADDS r0, r0, #1
  B loop
end:
  STR r3, [r1]
