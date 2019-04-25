# Common code generation for various multiply instructions.
# The variation is in the range of registers that these instructions will accept, given here as arguments.

I=$1
LOW=$2
HIGH=$3

A=16
B=17
cat <<- EOM
	; --- Test $I r$A, r$B for all values ---
	; Setup counters.
	ldi r$A, 0
	ldi r$B, 0
	; Loop over values.
	1:
	; Test.
	$I r$A, r$B
	break
	; Next r$A value.
	inc r$A
	brne 1b
	; Next r$B value.
	inc r$B
	brne 1b
EOM

MAGIC=229 # Kind of interesting bit pattern.
MAGIC2=$((MAGIC ^ 0xff))
echo "; --- Test $I with one value for all registers ---"
for A in $(seq $LOW $HIGH); do
for B in $(seq $LOW $HIGH); do
	# Avoid clobbering one register while setting the other.
	if [ $A -eq 16 ]; then
		TEMP=17
	else
		TEMP=16
	fi
	cat <<- EOM
		; Setup values.
		ldi r$TEMP, $MAGIC
		mov r$A, r$TEMP
		ldi r$TEMP, $MAGIC2
		mov r$B, r$TEMP
		; Test.
		$I r$A, r$B
		break
	EOM
done
done

A=16
cat <<- EOM
	; Test $I r$A, r$A for all values ---
	; Setup counter.
	ldi r$A, 0
	; Loop over values.
	1:
	; Test.
	$I r$A, r$A
	break
	; Next value.
	inc r$A
	brne 1b
EOM
