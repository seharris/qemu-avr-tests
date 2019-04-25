#!/bin/bash
# Skip on Bit, Register
# 65,536 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I for all registers, values, and bits ---"
for A in $(seq 0 31); do
for BIT in $(seq 0 7); do
	FLAG=16
	if [ $A -eq $FLAG ]; then
		FLAG=17
	fi
	cat <<- EOM
		; Load first value.
		clr r$A
		1:
		; Use r$FLAG to check skip.
		clr r$FLAG
		; Test.
		$I r$A, $BIT
		ldi r$FLAG, 0xff
		break
		; Loop over all values.
		inc r$A
		brne 1b
	EOM
done
done
