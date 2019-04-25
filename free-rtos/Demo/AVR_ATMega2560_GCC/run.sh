#!/bin/sh
# Script to run FreeRTOS demo under QEMU.
# A FIFO in /tmp and Netcat (nc) are used to loop QEMU's USART back to itself (needed for the demo's comms test).

mkfifo /tmp/loop
cat /tmp/loop | nc -l -p 1234 > /tmp/loop &
qemu-system-avr -bios demo.elf -serial tcp:localhost:1234
