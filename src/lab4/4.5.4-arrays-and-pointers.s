.text
.global main

@ init_Indices (int a[], int s) {
@   int i;
@   for ( i = 0; i < s; i ++) a[i] = 0;
@ }
@ init_Pointers (int *array, int s) {
@   int *p;
@   for ( &array[0]; p < &array[s]; p++) *p = 0;
@ }


main:
	MOVS r1, #0x100 @ r1 = *a
	MOVS r2, #5     @ r2 = s = 5
    MOVS r4, #0     @ r4 = 0 (constante)
    B exA
exA: 
	MOVS r3, #0     @ r3 = i = 0
loopA:
    CMP r3, r2
    BGE end
    STRB r4, [r1, r3]
    ADDS r3, r3, #1
    B loopA

exB:
    MOVS r3, r1
    ADDS r5, r1, r2
loopB:
    CMP r3, r5
    BGE end
    STR r4, [r3]
    ADDS r3, r3, #1
    B loopB
end: