#!/bin/bash
# Status register bit branch.
# 576 breaks.

source src/constants.sh
I=$1

for K in $(seq 0 7); do
	KSET=$((1<<K))
	KCLEARED=$((255^KSET))
	cat <<- EOM
		; --- Test $I $K for a range of offsets ---
		; Test with bit set.
		ldi r18, $KSET
		out $SREG_IO, r18
		; Loop.
		1:
		$I $K, .+126
		nop
		break
	EOM
	for OFFSET in $(seq 58 -4 6); do
		BYTE_OFFSET=$((OFFSET * 2))
		echo "$I $K, .+$BYTE_OFFSET"
		echo "break"
	done
	echo "$I $K, .+0"
	echo "break"
	echo "$I $K, 2f"
	for OFFSET in $(seq 4 4 64); do
		BYTE_OFFSET=$((OFFSET * 2))
		echo "break"
		echo "$I $K, .-$BYTE_OFFSET"
	done
	cat <<- EOM
		2: break
		$I $K, .+0
		break
		$I $K, .+4
		break
		$I $K, .+2
		$I $K, .-4
		break
		; Re-test with bit cleared.
		cpi r18, $KCLEARED
		breq 1f
		ldi r18, $KCLEARED
		out $SREG_IO, r18
		jmp 1b
		1:
	EOM
done
