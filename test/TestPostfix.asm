%include "../Postfix.asm"
section .text
global _start
_start:
	mov	rdi, Input	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString
	call	postfix

	call	copyTemp2Input

        mov     rsi,Input
	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
