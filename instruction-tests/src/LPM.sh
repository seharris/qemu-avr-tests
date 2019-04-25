#!/bin/bash
# Instruction specific test for lpm.
# TODO: 1444? breaks.

source src/constants.sh
I=$1

ADDRESS=30 # Arbitrary
cat <<- EOM
	; --- Test $I for all non-overlapping registers ---
	; Set read address.
	ldi r${LO[Z]}, lo8($ADDRESS)
	ldi r${HI[Z]}, hi8($ADDRESS)
EOM
for A in $(seq 0 29); do
cat <<- EOM
	; Test.
	clr r$A
	$I r$A, Z
	break
EOM
done

cat <<- EOM
	; --- Test $I for all defined source addresses ---
	; Set start address.
	ldi r${LO[Z]}, 0
	ldi r${HI[Z]}, 0
	1:
	; Test with implied parameters.
	$I
	break
	; Test and increment.
	$I r0, Z+
	break
	; Loop.
	ldi r18, lo8(end)
	cpse r${LO[Z]}, r18
	rjmp 1b
	ldi r18, hi8(end)
	cpse r${HI[Z]}, r18
	rjmp 1b
EOM

ADDRESS=32 # Arbitary
cat <<- EOM
	; --- Test $I where destination and indirect use the same register ---
	; Set address.
	ldi r${LO[Z]}, lo8($ADDRESS)
	ldi r${HI[Z]}, hi8($ADDRESS)
	; Test low byte.
	$I r30, Z
	break
	; Set address.
	ldi r${LO[Z]}, lo8($ADDRESS)
	ldi r${HI[Z]}, hi8($ADDRESS)
	; Test high byte.
	$I r31, Z
	break
EOM
