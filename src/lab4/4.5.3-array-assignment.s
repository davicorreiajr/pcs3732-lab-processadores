.text
.global main

@ for (i = 0; i <= 10; i++) {
@		a[i] = b[i] + c;
@	}
@ r1 = *a
@ r2 = *b
@ r3 = i = 0
@ r4 = c = 5
main:
	MOVS r1, 0x100
	MOVS r2, 0x200
	MOVS r3, #0
	MOVS r4, #5
loop:
	CMP r3, #10
	BGT end
	LDR r5, [r2, r3, LSL #2]
	ADDS r5, r5, r4
	STR r5, [r1, r3, LSL #2]
	B loop
end:
	