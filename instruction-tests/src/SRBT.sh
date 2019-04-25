#!/bin/bash
# Status register bit twiddling.
# 16 breaks.

source src/constants.sh
I=$1

for K in $(seq 0 7); do
	cat <<- EOM
		; --- Test $I with SREG clear and set ---
		; Test with SREG zeroes.
		ldi r18, 0
		out $SREG_IO, r18
		$I $K
		break
		; Test with SREG ones.
		ldi r18, 0xff
		out $SREG_IO, r18
		$I $K
		break
	EOM
done
