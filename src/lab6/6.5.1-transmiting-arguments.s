  .text
  .globl main
  dados: .space 100

main:
  B by_address
by_register:
  MOV r0, #2      @ b = 2
  MOV r1, #3      @ c = 3
  MOV r2, #5      @ d = 5
  BL function_by_register
by_address:
  MOV r0, #2                  @ b = 2
  MOV r1, #3                  @ c = 3
  MOV r2, #5                  @ d = 5
  MOV r3, #0x8000             @ r3 = 0x8000 (base address)
  STMIA r3, {r0, r1, r2}      @ store values
  BL function_by_address
  SWI 0x0

function_by_register:
  MLA r3, r0, r1, r2

function_by_address:
  LDMIA r3, {r4, r5, r6}
  MLA r7, r0, r1, r2
