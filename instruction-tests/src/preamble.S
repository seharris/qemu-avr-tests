.section .text
.global main
main:
; *Acutally* reset CPU, the debugger tries but doesn't seem to do it properly.
clr r0
clr r1
clr r2
clr r3
clr r4
clr r5
clr r6
clr r7
clr r8
clr r9
clr r10
clr r11
clr r12
clr r13
clr r14
clr r15
clr r16
clr r17
clr r18
clr r19
clr r20
clr r21
clr r22
clr r23
clr r24
clr r25
clr r26
clr r27
clr r28
clr r29
clr r30
clr r31
out 0x3d, r0
out 0x3e, r0
out 0x3f, r0
