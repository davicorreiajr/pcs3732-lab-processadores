/* Guilherme Adissy - 9349541 */
/* sudo docker run --rm -ti -v "$PWD/src":/home/student/src epiceric/gcc-arm */
/* cd P1 */
/* gcc -o p1 resp.s */
/* gdb p1 */

.text
.globl main

main:
  LDR r6, =9349541  @ NUSP
  LDR r7, =1        @ pot13
  LDR r8, =base13   @ data
  MOV r11, #13
loop1:
  MUL r2, r7, r11
  MOV r1, r6
  STMDB sp!, {r1, r2}
  BL division
  LDMIA sp!, {r1, r2}
  CMP r3, #0
  BEQ prepLoop2
  MOV r7, r2
  BL loop1
prepLoop2:
  MOV r1, r6
  MOV r2, r7
loop2:
  CMP r1, #0
  BEQ final
  STMDB sp!, {r2}
  BL division
  STMDB sp!, {r5}
  BL desloca_numero @guarda os numeros
  LDMIA sp!, {r1, r2}
  STMDB sp!, {r1}
  MOV r1, r2 @r1 = pot13
  MOV r2, #13
  BL division
  MOV r2, r3
  LDMIA sp!, {r1}
  BL loop2

desloca_numero:
  @ r3 = quocient
  @ r8 = base13
  @ r7 = counter
  MOV r10, lr
  MOV r7, r8
loop_desloca1:
  LDR r1, [r7, #1]
  ADD r7, r7, #1
  CMP r1, #0
  BNE loop_desloca1
loop_desloca2:
  SUB r7, r7, #1
  CMP r7, r8
  BEQ final_desloca
  LDR r1, [r7, #1]
  ADD r7, r7, #1
  STR r1, [r7, #0]
  SUB r7, r7, #1
  BL loop_desloca2
final_desloca:
  STR r3, [r8, #0]
  MOV lr, r10
  MOV pc, lr

final:
  MOVS r0, #1


division:
  MOVS r9, lr @ guarda endereco de retorno 
  MOVS r3, #0 /* r3 = quocient */
  CMP r1, r2
  BCC fim
  BL alignDivisorLeft
compare:
  CMP r5, #0
  BMI fim
  BL divide
  BL shiftDivisorRight
  SUB r5, r5, #1
  B compare
fim:
  MOV r5, r1 /* r5 = remainder */
  MOVS lr, r9 @ restaura endereco de retorno
  MOV pc, lr

alignDivisorLeft:
  CLZ r0, r1
  CLZ r4, r2
  SUB r5, r4, r0 /* r5 = leading 0 of r2 - leading zero of r1 */
  MOV r2, r2, LSL r5
  MOV pc, lr

divide:
  MOV r10, lr
  CMP r1, r2
  BCC onlyShiftDivisorToLeft
  SUB r1, r1, r2
  MOV r3, r3, LSL #1
  ADD r3, r3, #1
  B endDivide
onlyShiftDivisorToLeft:
  MOV r3, r3, LSL #1
endDivide:
  MOV lr, r10
  MOV pc, lr

shiftDivisorRight:
  MOV r2, r2, LSR #1
  MOV pc, lr

base13: .space 100
