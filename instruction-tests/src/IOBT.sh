#!/bin/bash
# IO register bit twiddling.
# 48 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I on safe IO registers, clear and set, all bits ---"
for R in $GPIOR0_IO; do
for K in $(seq 0 7); do
	cat <<- EOM
		; Test with register clear.
		ldi r18, 0
		out $R, r18
		$I $R, $K
		in r18, $R ; Read register so it's visible to the debugger.
		break
		; Test with register set.
		ldi r18, 0xff
		out $R, r18
		$I $R, $K
		in r18, $R ; Read register so it's visible to the debugger.
		break
	EOM
done
done
