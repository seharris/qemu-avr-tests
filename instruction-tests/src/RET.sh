#!/bin/bash
# RETurn.
# 516 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I for various stack pointer locations and return destinations ---"
# Range chosen to test eight bit overflow in arithmetic.
for STACK in $(seq 515 1030); do
cat <<- EOM
	; Set stack pointer.
	ldi r16, lo8($STACK)
	out $SPL_IO, r16
	ldi r16, hi8($STACK)
	out $SPH_IO, r16
	; Push destination to stack.
	ldi r16, lo8(pm(1f))
	push r16
	ldi r16, hi8(pm(1f))
	push r16
	clr r16
	push r16
	; Clear status flags.
	out $SREG_IO, r16
	; Test.
	$I
	break ; Unreachable.
	1:
	; Make top of stack visible to debugger.
	lds r16, $STACK - 2
	lds r17, $STACK - 1
	lds r18, $STACK
	break
EOM
done
