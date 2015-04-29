%include "../GetExpression.asm"
section .data
global _start
_start:
	mov	rdi, Input	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString
	call	removeWhitespace

	call	copyTemp2Input

        mov     rsi,Input
	call	print

	mov	rdi,Input
	mov	rcx,1024	;Do for all 1024 chars in string
	call	clearString

	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
