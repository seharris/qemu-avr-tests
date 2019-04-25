#!/bin/bash
# IO Move for Out.
# 288 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I for all registers and selected addresses ---"
for A in $(seq 0 31); do
for K in 0 229 255; do
for ADDRESS in $GPIOR0_IO $GPIOR1_IO $GPIOR2_IO; do
cat <<- EOM
	ldi r18, $K
	mov r$A, r18
	$I $ADDRESS, r$A
	lds r18, $ADDRESS + 0x20 ; Make target address visible to debugger.
	break
EOM
done
done
done
