 .text
 .globl main

main: 
 LDR r0, =data            /* ponteiro para dados */
 LDR r1, =4 				      /* N */
 MUL r2, r1, r1		        /* r2 = N^2 */
 ADD r2, r2, #1           /* r2 = N^2 + 1 */
 MUL r2, r1, r2 			    /* r2 = N(N^2 + 1) */
 MOV r2, r2, LSR #1		    /* r2 = N(N^2 + 1)/2 */
 MOV r9, #0

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
 MOV r3, r0
 MOV r11, #0
columnLoop:
 CMP r11, r1
 BGE diagonals
 MOV r10, #0
 MOV r6, #0
columnSubLoop:
 MUL r12, r10, r1
 MOV r4, r11
 ADD r4, r4, r12
 LDR r5, [r4]
 ADD r6, r6, r5
 ADD r10, #1
 CMP r10, r1
 BMI columnSubLoop
 ADD r11, #1
 CMP r6, r2
 BEQ columnLoop
 B final

diagonals:
 MOV r9, #1


final:
 MOV r1, r2




data: .word 0x10, 0x3, 0x2, 0xD, 0x5, 0xA, 0xB, 0x8, 0x9, 0x6, 0x7, 0xC, 0x4, 0xF, 0xE, 0x1
.end
