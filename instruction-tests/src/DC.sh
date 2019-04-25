#!/bin/bash
# Direct Call.
# 21 breaks.

source src/constants.sh
I=$1

echo "; Test $I for a range of stack pointer values and origin addresses."
for STACK in $(seq 1010 1030); do
cat <<- EOM
	; Clear top of stack.
	clr r18
	sts $STACK, r18
	sts $STACK - 1, r18
	sts $STACK - 2, r18
	; Set stack pointer.
	ldi r18, lo8($STACK)
	out $SPL_IO, r18
	ldi r18, hi8($STACK)
	out $SPH_IO, r18
	; Test.
	$I 1f
	break ; Unreachable.
	1:
	; Copy top of stack to registers so debugger can see it.
	lds r19, $STACK
	lds r20, $STACK - 1
	lds r21, $STACK - 2
	break
EOM
done
