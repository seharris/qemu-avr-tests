#!/bin/bash
# Load/Store (instruction specific test).
# 1,696 breaks.

source src/constants.sh

ADDRESS=512
INDIRECT=Z
cat <<- EOM
	; --- Test ld/st for all source registers, except Z. ---
	; Load address.
	ldi r${LO[$INDIRECT]}, lo8($ADDRESS)
	ldi r${HI[$INDIRECT]}, hi8($ADDRESS)
	; Load counter.
	; This counter is used to generate constantly changing values to shuffle about.
	; Hopefully this will help detect errors where data is overwritten.
	ldi r18, 0
EOM
for SOURCE in $(seq 0 31); do
	if [ $SOURCE -eq ${LO[Z]} ]; then
		INDIRECT=Y
		cat <<- EOM
			; Load address.
			ldi r${LO[$INDIRECT]}, lo8($ADDRESS)
			ldi r${HI[$INDIRECT]}, hi8($ADDRESS)
		EOM
	fi
	cat <<- EOM
		; Get value.
		mov r$SOURCE, r18
		; Test store.
		st $INDIRECT, r$SOURCE
		break
		; Test load.
		clr r$SOURCE
		ld r$SOURCE, $INDIRECT
		break
		; Next value
		inc r18
	EOM
done

echo "; --- Test ld/st for all indirect registers. ---"
SOURCE=18
for INDIRECT in X Y Z; do
cat <<- EOM
	; Load address.
	ldi r${LO[$INDIRECT]}, lo8($ADDRESS)
	ldi r${HI[$INDIRECT]}, hi8($ADDRESS)
	; Test store.
	st $INDIRECT, r$SOURCE
	break
	; Test load.
	clr r$SOURCE
	ld r$SOURCE, $INDIRECT
	break
	; Next value.
	inc r18
EOM
done

SOURCE=18
INDIRECT=Z
echo "; --- Test ld/st for selected destinations. ---"
for ADDRESS in $(seq 0 29) $GPIOR0_MEM $GPIOR1_MEM $GPIOR2_MEM; do
if [ $ADDRESS != $SOURCE ]; then
cat <<- EOM
	; Load address.
	ldi r${LO[$INDIRECT]}, lo8($ADDRESS)
	ldi r${HI[$INDIRECT]}, hi8($ADDRESS)
	; Test store.
	st $INDIRECT, r$SOURCE
	break
	; Test load.
	clr r$SOURCE
	ld r$SOURCE, $INDIRECT
	break
	; Next value.
	inc r18
EOM
fi
done
START=512
STOP=1024
cat <<- EOM
	; Load first address.
	ldi r${LO[$INDIRECT]}, lo8($START)
	ldi r${HI[$INDIRECT]}, hi8($START)
	1:
	; Test store.
	st $INDIRECT, r$SOURCE
	break
	; Test load, next address.
	clr r$SOURCE
	ld r$SOURCE, $INDIRECT+
	break
	; Next value.
	inc r18
	; Loop.
	ldi r16, lo8($STOP)
	cpse r16, r${LO[$INDIRECT]}
	rjmp 1b
	ldi r16, hi8($STOP)
	cpse r16, r${HI[$INDIRECT]}
	rjmp 1b
EOM

echo "; --- Test ld/st for overlapping source/destination/indirect registers. ---"
for INDIRECT in X Y Z; do
	echo "; Load address MSB."
	echo "ldi r${HI[$INDIRECT]}, 0"
	for SOURCE in ${LO[$INDIRECT]} ${HI[$INDIRECT]}; do
	cat  <<- EOM
		; Load address LSB.
		ldi r${LO[$INDIRECT]}, lo8($SOURCE)
		; Test store.
		st $INDIRECT, r$SOURCE
		break
		; Test load.
		ld r$SOURCE, $INDIRECT
		break
	EOM
	done
done

SOURCE=18
ADDRESS=1023 # Chosen to cause overflow.
INDIRECT=X
cat <<- EOM
	; --- Test ld/st pre-decremenet/post-increment. ---
	; Load address.
	ldi r${LO[$INDIRECT]}, lo8($ADDRESS)
	ldi r${HI[$INDIRECT]}, hi8($ADDRESS)
	; Test store, post-increment.
	st $INDIRECT+, r$SOURCE
	break
	; Next value.
	inc r18
	; Test store, pre-decrement.
	st -$INDIRECT, r$SOURCE
	break
	; Test load, post-increment.
	inc r18
	ld r$SOURCE, $INDIRECT+
	break
	; Test load, pre-decrement.
	inc r18
	ld r$SOURCE, -$INDIRECT
	break
	; Next value.
	inc r18
EOM

echo "; --- Test ldd/std for all indirect registers and displacements. ---"
ADDRESS=512
SOURCE=18
for INDIRECT in Y Z; do
	echo "; Load address."
	echo "ldi r${LO[$INDIRECT]}, lo8($ADDRESS)"
	echo "ldi r${HI[$INDIRECT]}, hi8($ADDRESS)"
	for DISPLACEMENT in $(seq 0 63); do
	cat <<- EOM
		; Test store.
		std $INDIRECT+$DISPLACEMENT, r$SOURCE
		break
		; Test load.
		clr r$SOURCE
		ldd r$SOURCE, $INDIRECT+$DISPLACEMENT
		break
		; Next value.
		inc r18
	EOM
	done
done
