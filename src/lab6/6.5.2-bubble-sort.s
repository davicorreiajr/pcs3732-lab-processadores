  .text
  .globl main

main:
  LDR r7, =dados              @ r7 recebe ponteiro para base do array
  LDRB r0, [r7], #1           @ r0 recebe numero de elementos (n)
  CMP r0, #0                  @ n > 0
loop1:
  BLE final
  MOVS r1, r7                 @ r1 recebe ponteiro que ira varrer elementos (p*), iniciando na base do array
  ADDS r2, r1, r0             @ r2 recebe p* + n
  SUB  r2, r2, #1
loop2:
  CMP r1, r2
  BGE fimLoop2
  LDRB r3, [r1]
  LDRB r4, [r1, #1]!
  CMP r3, r4
  BLE naoInverte
  STRB r4, [r1, #-1]
  STRB r3, [r1]
naoInverte:
  B loop2
fimLoop2:
  SUBS r0, r0, #1
  B loop1
final:
  MOV r0, r7


dados: .byte 0x8, 0x2, 0x8, 0x21, 0x4, 0x16, 0x6, 0x1, 0xFF

.end
