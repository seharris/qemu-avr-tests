#!/bin/bash
# Status register bit loading.
# 4096 breaks.

source src/constants.sh
I=$1

for A in $(seq 0 31); do
for K in $(seq 0 7); do
	echo "; --- Test $I r$A with selected values ---"
	SET=$((1 << K))
	CLEAR=$((SET ^ 0xff))
	for AVALUE in 0x00 0xff $CLEAR $SET; do
	for SVALUE in 0x00 0xff $CLEAR $SET; do
		cat <<- EOM
			ldi r18, $SVALUE
			out $SREG_IO, r18
			ldi r18, $AVALUE
			mov r$A, r18
			$I r$A, $K
			break
		EOM
	done
	done
done
done
