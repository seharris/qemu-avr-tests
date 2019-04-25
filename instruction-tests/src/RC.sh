#!/bin/bash
# Relative Call.
# 10 breaks.

source src/constants.sh
I=$1

STACK=1010 # Chosen to check arithmetic is 16 bit.
cat <<- EOM
	; --- Test $I for various destinations and stack locations ---
	; Setup stack pointer.
	ldi r16, lo8($STACK)
	out $SPL_IO, r16
	ldi r16, hi8($STACK)
	out $SPH_IO, r16
EOM
# Note that offsets are in bytes, not instructions (jmp is four bytes).
for OFFSET in -14 -12 -10 -8 -6 +0 +2 +4 +6 +8; do
cat <<- EOM
	; Use r16 to work out where the jump lands.
	clr r16
	; Jump to test using a different type of jump.
	jmp 1f
	; Test, the padding provides a mechanism to check where the jump lands.
	ori r16, 0b00000001
	ori r16, 0b00000010
	ori r16, 0b00000100
	ori r16, 0b00001000
	jmp 2f ; Prevent infinite loop.
	1: $I .$OFFSET
	ori r16, 0b00010000
	ori r16, 0b00100000
	ori r16, 0b01000000
	ori r16, 0b10000000
	2:
	; Load stack so debugger can see it.
	pop r17
	pop r18
	pop r19
	break
	; Next stack location.
	pop r16
EOM
done
