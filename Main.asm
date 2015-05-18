%include "Postfix.asm"
section .data
global _start
_start:
	mov	rdi, Input	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,21*BUFSIZE	;Read 21 buffers
	call	getString
	call	removeWhitespace
	call	copyTemp2Input

	call	addAsterisks
	call	copyTemp2Input

	call	getAndReplaceAllVars

	call	postfix
	call	copyTemp2Input

	mov	rsi, Input
	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
