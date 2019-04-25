#!/bin/bash
# Instruction specific test for ldi.
# 544 breaks.

source src/constants.sh
I=$1

echo "; --- Test $I for all immediates values and selected register values ---"
A=16
for K in $(seq 0 255); do
cat <<- EOM
	; Test with zeroes.
	clr r$A
	$I r$A, $K
	break
	; Test with ones.
	ori r$A, 0xff
	$I r$A, $K
	break
EOM
done

echo "; --- Test $I for all registers with selected registers values ---"
K=229 # Kind of interesting bit pattern.
for A in $(seq 16 31); do
cat <<- EOM
	; Test with zeroes.
	clr r$A
	$I r$A, $K
	break
	; Test with ones.
	ori r$A, 0xff
	$I r$A, $K
	break
EOM
done
