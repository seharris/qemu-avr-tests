#!/bin/bash
# Direct Load and Store.
# 1220 breaks.

source src/constants.sh
I=$1

cat <<- EOM
	; --- Test lds/sts for non-overalpping destinations. ---"
	; Load counter.
	clr r0
EOM
for ADDRESS in $(seq 1 31) $GPIOR0_MEM $GPIOR1_MEM $GPIOR2_MEM $(seq 512 1024); do
cat <<- EOM
	; Test store.
	sts $ADDRESS, r0
	break
	; Test load.
	inc r0 ; Make sure we can tell if the load worked.
	lds r0, $ADDRESS
	break
	; Next value.
	inc r0
EOM
done

ADDRESS=512
echo "; --- Test lds/sts for all  registers. ---"
for A in $(seq 0 31); do
cat <<- EOM
	; Get value.
	mov r$A, r0
	; Test store.
	sts $ADDRESS, r$A
	break
	; Test load.
	inc r$A ; Make sure we can tell if the load worked.
	lds r$A, $ADDRESS
	break
	; Next value.
	inc r0
EOM
done

echo "; --- Test lds/sts for overlapping source/destination. ---"
for A in $(seq 0 31); do
cat <<- EOM
	; Get value.
	mov r$A, r0
	; Test store.
	sts $A, r$A
	break
	; Next value.
	inc r0
	; Test load.
	lds r$A, $A
	break
EOM
done
