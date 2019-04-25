#!/bin/bash
# Binary Arithmetic with Carry.
# 132,608 breaks.

I=$1

A=0
B=16
cat <<- EOM
	; --- Test $I r$A, r$B for all values ---
	; Setup counters.
	ldi r18, 0
	ldi r$B, 0
	; Loop over values.
	1:
	; Test with carry.
	mov r$A, r18
	sec
	$I r$A, r$B
	break
	; Test with no carry.
	mov r$A, r18
	clc
	$I r$A, r$B
	break
	; Next r$A value.
	inc r18
	brne 1b
	; Next r$B value.
	inc r$B
	brne 1b
EOM

MAGIC=229 # Kind of interesting bit pattern.
for A in $(seq 0 31); do
for B in $(seq 0 31); do
cat <<- EOM
	; --- Test $I r$A, r$B for one value ---
	ldi r18, $MAGIC
	mov r$A, r18
	mov r$B, r18
	sec
	$I r$A, r$B
	break
EOM
done
done

A=0
cat <<- EOM
	; Test $I r$A, r$A for all values ---
	; Setup counter.
	ldi r18, 0
	; Loop over values.
	1:
	; Test with carry.
	mov r$A, r18
	sec
	$I r$A, r$A
	break
	; Test with no carry.
	mov r$A, r18
	clc
	$I r$A, r$A
	break
	; Next value.
	inc r18
	brne 1b
EOM
