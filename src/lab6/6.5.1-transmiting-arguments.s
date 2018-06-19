  .text
  .globl main
  dados: .space 100

main:
  B by_stack

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

by_stack:
  MOV r0, #2                  @ b = 2
  MOV r1, #3                  @ c = 3
  MOV r2, #5                  @ d = 5
  STMFA r13!, {r0, r1, r2}    @ values into the stack
  BL function_by_stack_1
  MOV r0, r7

function_by_register:
  MLA r3, r0, r1, r2

function_by_address:
  LDMIA r3, {r4, r5, r6}
  MLA r7, r0, r1, r2

function_by_stack_1:
  LDMFA r13!, {r4, r5, r6}
  MUL r5, r4, r5
  STMFA r13!, {r5, r6, lr}
  BL function_by_stack_2
  LDMFA r13!, {lr}
  MOV pc, lr

function_by_stack_2:
  LDMFA r13!, {r7, r8, r9}
  STMFA r13!, {r9}
  ADD r7, r7, r8
  MOV pc, lr
 