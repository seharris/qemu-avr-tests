#!/bin/bash

avr-gcc -Wall -g -mmcu=atmega2560 -o demo.elf  main.c regtest.c ParTest/ParTest.c serial/serial.c \
	../../Source/{croutine.c,list.c,queue.c,tasks.c} \
	../../Source/portable/MemMang/heap_1.c \
	../../Source/portable/GCC/ATMega2560/port.c \
	../Common/Minimal/{crflash.c,integer.c,PollQ.c,comtest.c} \
	-I. -I../../Source/include -I../../Source/portable/GCC/ATMega2560 -I../Common/include
