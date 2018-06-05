  .text
  .globl main

main:
  MOV r0, #5
  RSB r0, r0, #0
  ADDS r0, r0, #0
  RSBMI r1, r0, #0
end:
  SWI	0x0
