#!/bin/bash
# Instruction specific test for movw.
# 131,328 breaks.

cat <<- EOM
	; --- Test for all values for overlapping and non-overlapping registers ---
	; Setup counter.
	clr r24
	clr r25
	1:
	; Test non-overlapping.
	movw r0, r24
	break
	; Test overlapping.
	movw r24, r24
	break
	; Next value.
	adiw r24, 1
	brne 1b
EOM

echo "; --- Test for all registers ---"
MAGIC=229 # Kind of interesting bit pattern.
for A in $(seq 0 2 31); do
for B in $(seq 0 2 31); do
	A1=$((A + 1))
	B1=$((B + 1))
	cat <<- EOM
		; Setup values.
		ldi r18, $MAGIC
		mov r$B, r18
		mov r$B1, r18
		clr r$A
		clr r$A1
		; Test.
		movw r$A, r$B
		break
	EOM
done
done
