#!/bin/bash
# Unary Arithmetic.
# 4,096 breaks.

I=$1

for A in $(seq 0 31); do
	COUNTER=18
	ONE=20
	if [ "$A" = "$ONE" ]; then
		ONE=21
	fi
	if [ "$A" = "$COUNTER" ]; then
		COUNTER=19
	fi
	cat <<- EOM
		; --- Test $I r$A for all values ---
		; Setup counter.
		ldi r$COUNTER, 0
		ldi r$ONE, 1
		; Loop over values.
		1:
		; Test.
		mov r$A, r$COUNTER
		$I r$A
		break
		; Next r$A value.
		add r$COUNTER, r$ONE
		brne 1b
	EOM
done
