%include "../GetVariables.asm"
section .data
global _start
_start:
	mov	rdi, Input	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,21*BUFSIZE	;Read 21*BUFSIZE chars max
	call	getString
	call	removeWhitespace
	call	copyTemp2Input

	call	getAndReplaceAllVars

        mov     rsi,Temp
	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
