#!/bin/bash
# Immediate Arithmetic with Carry.
# 139,264 breaks.

I=$1

echo "; --- Test $I for all values ---"
A=16
for K in $(seq 0 255); do
	cat <<- EOM
		; Setup counter.
		ldi r18, 0
		; Loop over values.
		1:
		; Test with carry.
		mov r$A, r18
		sec
		$I r$A, $K
		break
		; Test without carry.
		mov r$A, r18
		clc
		$I r$A, $K
		break
		; Next r$A value.
		inc r18
		brne 1b
	EOM
done

echo "; --- Test $I for all registers and immediate values ---"
MAGIC=229 # Kind of interesting bit pattern.
for A in $(seq 16 31); do
for K in $(seq 0 255); do
	cat <<- EOM
		; Test with carry.
		ldi r$A, $MAGIC
		sec
		$I r$A, $K
		break
		; Test without carry.
		ldi r$A, $MAGIC
		clc
		$I r$A, $K
		break
	EOM
done
done
