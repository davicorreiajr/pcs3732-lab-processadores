  .text
  .globl main

main: 
  LDR r0, =dados 			  /* ponteiro para dados */
  LDR r1, =4 				    /* N */
  MUL r2, r1, r1		    /* r2 = N^2 */
  ADD r2, r2, #1        /* r2 = N^2 + 1 */
  MUL r2, r2, r1 			  /* r2 = N(N^2 + 1) */
  MOV r2, r2, LSR #1		/* r2 = N(N^2 + 1)/2 */

row:
  MOV r3, r0
  MOV r10, #0
rowLoop:
  CMP r10, r1
  BGE column
  LDMIA r3!, {r5-r8}
  ADD r4, r5, r6
  ADD r4, r4, r7
  ADD r4, r4, r8
  ADD r10, r10, #1
  CMP r4, r2
  BEQ rowLoop
  B final

column:


columnLoop:


diagonals:



final:
  SWI 0x0




data: .word 0x10, 0x3, 0x2, 0xD, 0x5, 0xA, 0xB, 0x8, 0x9, 0x6, 0x7, 0xC, 0x4, 0xF, 0xE, 0x1
.end
