#!/bin/bash
# Immediate Arithmetic, 16 bit.
# 65,792 breaks.

I=$1

A=24
B=$((A + 1))
MAGIC=37 # Kind of interesting bit pattern.
cat <<- EOM
	; --- Test $I r$A:r$B, $MAGIC for all values ---
	; Setup counters.
	ldi r18, 0
	ldi r19, 0
	; Loop over values.
	1:
	; Test.
	mov r$A, r18
	mov r$B, r19
	$I r$A, $MAGIC
	break
	; Next r$A value.
	inc r18
	brne 1b
	; Next r$B value.
	inc r19
	brne 1b
EOM

for A in 24 26 28 30; do
for K in $(seq 0 63); do
	B=$((A + 1))
	cat <<- EOM
		; --- Test $I r$A:r$B $K for one value ---
		ldi r$A, $MAGIC
		ldi r$B, $MAGIC
		$I r$A, $K
		break
	EOM
done
done
