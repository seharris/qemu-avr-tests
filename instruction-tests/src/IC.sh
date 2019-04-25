#!/bin/bash
# Indirect Call.
# 21 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I with various destinations and stack locations ---"
for STACK in $(seq 1010 1030); do
cat <<- EOM
	; Clear top of stack.
	ldi r18, 0xff
	sts $STACK, r18
	sts $STACK - 1, r18
	sts $STACK - 2, r18
	; Set stack pointer.
	ldi r18, lo8($STACK)
	out $SPL_IO, r18
	ldi r18, hi8($STACK)
	out $SPH_IO, r18
	; Load destination.
	ldi r30, lo8(pm(1f))
	ldi r31, hi8(pm(1f))
	; Test.
	$I
	1:
	; Copy top of stack to registers so debugger can see it.
	lds r18, $STACK
	lds r19, $STACK - 1
	lds r20, $STACK - 2
	break
EOM
done
