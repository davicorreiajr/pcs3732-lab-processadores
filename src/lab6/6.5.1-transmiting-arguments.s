  .text
  .globl main
  dados: .space 100

main:
by_register:
  MOV r0, #2      @ b = 2
  MOV r1, #3      @ c = 3
  MOV r2, #5      @ d = 5
  BL function_by_register
  SWI 0x0

function_by_register:
  MLA r3, r0, r1, r2