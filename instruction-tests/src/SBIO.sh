#!/bin/bash
# Skip on Bit, IO
# 2,048 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I for all register values and bits ---"
# Only GPIOR0 is safe to use and in range.
for ADDRESS in $GPIOR0_IO; do
for BIT in $(seq 0 7); do
cat <<- EOM
	; Load counter.
	clr r16
	1:
	; Set register.
	out $ADDRESS, r16
	; Use r17 to check skip.
	clr r17
	; Test.
	$I $ADDRESS, $BIT
	ldi r17, 0xff
	break
	; Loop over all values.
	inc r16
	brne 1b
EOM
done
done
