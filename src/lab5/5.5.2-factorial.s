  .text
  .globl main

main:
  MOVS r6, #0x4       @ r6 = 10
  MOVS r4, r6         @ r4 = r6 (r4 is temp)
loop:
  SUBS r4, r4, #1     @ r4 = r4 -1
  MULNE r5, r4, r6    @ result = product * r4
  MOVNE r6, r5        @ product = result
  BNE loop
end:
