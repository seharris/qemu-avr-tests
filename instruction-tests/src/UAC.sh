#!/bin/bash
# Unary Arithmetic with Carry.
# 8,192 breaks.

I=$1

for A in $(seq 0 31); do
	COUNTER=18
	if [ $A -eq $COUNTER ]; then
		COUNTER=19
	fi
	cat <<- EOM
		; --- Test $I r$A for all values ---
		; Load counter.
		clr r$COUNTER
		; Loop over values.
		1:
		; Test with carry.
		mov r$A, r$COUNTER
		sec
		$I r$A
		break
		; Test without carry.
		mov r$A, r$COUNTER
		clc
		$I r$A
		break
		; Next r$A value.
		inc r$COUNTER
		brne 1b
	EOM
done
