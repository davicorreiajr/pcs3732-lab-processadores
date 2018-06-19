  .text
  .globl main

main:
  LDR r0, =dados               @ i = 0
loop:
  B loop
final:



dados: .space 100
dados: .byte 0x4, 0x2, 0x8, 0x21, 0x4

.end
