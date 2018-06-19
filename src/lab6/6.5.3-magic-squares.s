  .text
  .globl main

main: 
  LDR r0, =dados 			/* ponteiro para dados */
  LDR r1, =4 				/* N */
  MLA r2, r1, r1, #1 		/* r2 = N^2 + 1 */
  MUL r2, r2, r1 			/* r2 = N(N^2 + 1) */
  MOV r2, r2, LSR #1		/* r2 = N(N^2 + 1)/2 */

row:
  MOV r3, r0
  MOV r10, #0
rowLoop:
  CPM r10, r1
  BGE column
  LDM r3!, {r5-r8}
  ADD r4, r5, r6
  ADD r4, r4, r7
  ADD r4, r4, r8
  ADD r10, r10, #1
  CPM r4, r2
  BEQ rowLoop
  B final

column:


columnLoop:


diagonals:



final:
  SWI 0x0





data: .byte #16, #3, #2, #13, #5, #10, #11, #8, #9, #6, #7, #12, #4, #15, #14, #1
.end