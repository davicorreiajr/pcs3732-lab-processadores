 @ Pedro Vanderlinde Darvas
 @ Para rodar e visualizar resultados:
 @
 @ gcc -o prova resp.s
 @ gdb prova
 @ target sim
 @ load
 @ b final
 @ x/10d fatores

  .text
  .globl main


main:
  LDR r1, =9347991  @ r1 recebe meu NUSP
  LDR r2, =2        @ r2 recebe primeiro valor a ser testado (i)
  LDR r8, =fatores  @ r8 recebe base de ponteiro para gravacao do resultado
loop1:
  CMP r2, r1        @ i < nusp ?
  BGT final
loop2:
  STMDB sp!, {r1, r2}
  BL division
  LDMIA sp!, {r1, r2}
  CMP r5, #0       @ compara resto com 0
  BNE fimLoop2
  STR r2, [r8], #4
  MOVS r1, r3      @ atualiza valor de r1
  B loop2
fimLoop2:
  ADDS r2, r2, #1   @ i++
  B loop1
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
  MOV	pc, lr

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
  MOV	pc, lr

shiftDivisorRight:
  MOV r2, r2, LSR #1
  MOV	pc, lr


fatores: .space 1000
