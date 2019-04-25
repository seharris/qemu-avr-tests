#!/bin/bash -e

CC=avr-gcc
MCU=atmega2560
# List of test programs, each with a list of instructions to run it on.
declare -A TESTS=(
	[BAC]="adc cpc sbc"
	[BA]="add and cp eor or mov sub" # Covers aliases: clr, tst.
	[IA16]="adiw sbiw"
	[IA]="andi cpi ori subi" # Covers aliases: cbr, sbr.
	[UA]="asr com dec inc lsl lsr neg swap"
	[SRBT]="bclr bset" # Covers aliases: clc, clh, cli, cln, cls, clt, clv, clz, sec, seh, sei, sen, ses, set, sev, sez.
	[SRBL]="bld bst"
	[DC]="call jmp"
	[SRBB]="brbc brbs" # Covers aliases: brcc, brcs, breq, brge, brhc, brhs, brid, brie, brlo, brlt, brmi, brne, brpl, brsh, brtc, brts, brvc, brvs.
	[IOBT]="cbi sbi"
	[CPS]="cpse"
	[IC]="icall ijmp eicall eijmp"
	[IOMI]="in"
	[IOMO]="out"
	[LS]="ld/st" # Instruction pair specific.
	[DLS]="lds/sts" # Instruction pair specific.
	[LPM]="lpm elpm" # Instruction specific.
	[MOVW]="movw" # Instruction specific.
	[BAM0-31]="mul"
	[BAM16-31]="muls"
	[BAM16-23]="mulsu fmul fmuls fmulsu"
	[NOP]="nop"
	[SO]="pop push"
	[RET]="ret reti"
	[RC]="rcall rjmp"
	[SBIO]="sbic sbis"
	[SBR]="sbrc sbrs"
	[UAC]="rol ror"
	[IAC]="sbci"
	[LDI]="ldi" # Covers aliases: ser.
	# Untested: des, lac, las, lat, xch, spm, sleep, wdr.
)

echo "Generating assembly..."
mkdir -p generated
for TEST in "${!TESTS[@]}"; do
	echo "    $TEST"
	FILE="generated/$TEST.S"
	cat src/preamble.S > "$FILE"
	for I in ${TESTS[$TEST]}; do
		source "src/$TEST.sh" $I >> "$FILE"
	done
	cat src/postamble.S >> "$FILE"
done

echo "Compiling..."
mkdir -p bin
for SOURCE in $(ls generated/*.S); do
	NAME=$(basename -s .S "$SOURCE")
	echo "    $NAME"
	$CC -g -Wall -mmcu=$MCU "$SOURCE" -o "bin/$NAME.elf"
done

echo "Done."
