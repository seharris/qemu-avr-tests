#!/bin/bash
# Stack Operation.
# 576 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I for all registers ---"
STACK=1024
for A in $(seq 0 31); do
	B=16
	if [ $A -eq $B ]; then
		B=17
	fi
	C=18
	if [ $A -eq $C ]; then
		C=19
	fi
	cat <<- EOM
		; Set stack pointer.
		ldi r16, lo8($STACK)
		out $SPL_IO, r16
		ldi r16, hi8($STACK)
		out $SPH_IO, r16
		; Load stack and register, using register number as counter.
		ldi r16, $A
		sts $STACK + 1, r16
		ldi r16, $A + 1
		mov r$A, r16
		; Test.
		$I r$A
		lds r$B, $STACK ; Include stack state in register dump.
		lds r$C, $STACK + 1 ; Include stack state in register dump.
		break
	EOM
done

START=2048
A=0
cat <<- EOM
	; --- Test $I for various addresses ---
	; Set stack pointer.
	ldi r16, lo8($START)
	out $SPL_IO, r16
	ldi r16, hi8($START)
	out $SPH_IO, r16
	; Load counter.
	clr r18
	clr r19
	1:
	; Load stack and register using counter.
	mov r$A, r19
	mov r16, r19
	inc r16 ; Make sure values are different.
	in ${LO[Z]}, $SPL_IO
	in ${HI[Z]}, $SPH_IO
	st Z, r16
	; Test.
	$I r$A
	ld r16, Z ; Include stack state in register dump.
	break
	; Loop until the address counter has overflowed into it's second byte and then some.
	inc r19
	brne 1b
	inc r18
	ldi r16, 2
	cpse r18, r16
	rjmp 1b
EOM

cat <<- EOM
	; --- Test $I for overlapping register and destination ---
	; Set stack pointer.
	clr r16
	out $SPH_IO, r16
EOM
for A in $(seq 0 31); do
cat <<- EOM
	; Set stack pointer.
	ldi r16, $A
	out $SPL_IO, r16
	; Load register, using register number as counter.
	mov r$A, r16
	; Test.
	$I r$A
	break
EOM
done
