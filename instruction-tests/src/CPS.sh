#!/bin/bash
# Compare and skip.
# 131,840 breaks.

I=$1

echo "; --- Test $I for all values, one word skip ---"
A=0
B=16
cat <<- EOM
	; Setup counters.
	ldi r18, 0
	ldi r$B, 0
	; Loop over values.
	1:
	; Test.
	mov r$A, r18
	ldi r19, 0
	$I r$A, r$B
	ldi r19, 1
	break
	; Next r$A value.
	inc r18
	brne 1b
	; Next r$B value.
	inc r$B
	brne 1b
EOM

echo "; --- Test $I for all registers, two word skip ---"
MAGIC=229 # Kind of interesting bit pattern.
for A in $(seq 0 31); do
for B in $(seq 0 31); do
cat <<- EOM
	ldi r18, $MAGIC
	mov r$A, r18
	mov r$B, r18
	$I r$A, r$B
	adiw r26, 1
	break
EOM
done
done
