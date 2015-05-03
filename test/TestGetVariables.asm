%include "../GetVariables.asm"
section .data
global _start
_start:
	mov	rdi, Input	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString
	call	removeWhitespace

	call	copyTemp2Input

	call	getAndReplaceFirstVar

        mov     rsi,Temp
	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
