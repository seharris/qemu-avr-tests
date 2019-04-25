#!/bin/bash
# Immediate Arithmetic.
# 5,872 breaks.

I=$1

echo "; --- Test $I for r$A, all register values, and selected immediate values ---"
A=16
MAGIC=229 # Kind of interesting bit pattern.
for K in 0 1 3 $MAGIC 253 254 255; do
	cat <<- EOM
		; Setup counter.
		ldi r18, 0
		1:
		; Test.
		mov r$A, r18
		$I r$A, $K
		break
		; Next r$A value.
		inc r18
		brne 1b
	EOM
done

echo "; --- Test $I for all registers and immediate values ---"
for A in $(seq 16 31); do
for K in $(seq 0 255); do
	cat <<- EOM
		ldi r$A, $MAGIC
		$I r$A, $K
		break
	EOM
done
done
