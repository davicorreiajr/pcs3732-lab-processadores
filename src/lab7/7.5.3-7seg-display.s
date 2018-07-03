  .text
  .globl main

main:
  LDR	r0, =0x3ff5000 	    @ r0 = IOPMOD
  LDR r3, =0x3FF5008      @ r3 = IOPDATA
  LDR	r1, =0xfe00	        @ seta 1 nos bits [16:10]
  STR	r1, [r0]	          @ seta IOPMOD como output
  LDR r6, =0x4000
  MOV r7, #11
  STR r7, [r6]
seg_display:
  LDR r2, [r6]            @ r2 = MEM[r6] (r2 = 0x4000)
map:
  CMP r2, #0x0
  BEQ hex0
  CMP r2, #0x1
  BEQ hex1
  CMP r2, #0x2
  BEQ hex2
  CMP r2, #0x3
  BEQ hex3
  CMP r2, #0x4
  BEQ hex4
  CMP r2, #0x5
  BEQ hex5
  CMP r2, #0x6
  BEQ hex6
  CMP r2, #0x7
  BEQ hex7
  CMP r2, #0x8
  BEQ hex8
  CMP r2, #0x9
  BEQ hex9
  CMP r2, #0xA
  BEQ hexA
  CMP r2, #0xb
  BEQ hexB
  CMP r2, #0xc
  BEQ hexC
  CMP r2, #0xd
  BEQ hexD
  CMP r2, #0xe
  BEQ hexE
  CMP r2, #0xf
  BEQ hexF
seta:
  STR r5, [r3]            @ IOPDATA recebe numero a ser mostrado
  MOVS r0, #0
  SWI 0x0
@   LDR r4, =0xffffffff
@   BL loop
@   ADDS r2, r2, #0x1      @ r2 = r2 + 0x1
@   CMP r2, #0xf
@   BNE seta
@   MOV r2, #0x0
@   BL seta
@ loop:
@   SUBS r4, r4, #1
@   CMP r4, #0
@   BNE loop
@ fim_loop:
@   MOV pc, lr

hex0:
  LDR r5, =0b1111110
  MOV pc, lr

hex1:
  LDR r5, =0b0110000
  MOV pc, lr

hex2:
  LDR r5, =0b1101101
  MOV pc, lr

hex3:
  LDR r5, =0b1111001
  MOV pc, lr

hex4:
  LDR r5, =0b0110011
  MOV pc, lr

hex5:
  LDR r5, =0b1011011
  MOV pc, lr

hex6:
  LDR r5, =0b1011111
  MOV pc, lr

hex7:
  LDR r5, =0b1110000
  MOV pc, lr

hex8:
  LDR r5, =0b1111111
  MOV pc, lr

hex9:
  LDR r5, =0b1110011
  MOV pc, lr

hexA:
  LDR r5, =0b1110111
  MOV pc, lr

hexB:
  LDR r5, =0b0011111
  MOV pc, lr

hexC:
  LDR r5, =0b1001110
  MOV pc, lr

hexD:
  LDR r5, =0b0111101
  MOV pc, lr

hexE:
  LDR r5, =0b1001111
  MOV pc, lr

hexF:
  LDR r5, =0b1000111
  MOV pc, lr