%include "GetExpression.asm"

section .bss
Stack	resb	1024

section	.data
Operators	db	'*/+-'
OpLen		db	$ - Operators
OpPrecedence	db	'1122'
Error		db	'Error: invalid parenthesis.',10
ErrorLen	db	$ - Error

section	.text
postfix:
	mov	rsi, Input
	mov	rdi, Temp
	mov	r8, Stack	;Use r8 as stack pointer
.loop:
	lodsb		;Put current char in al
	call	testNumber
	je	.skip
	call	testLeftBrace
	je	.skip
	call	testOperator
	je	.skip
	call	testRightBrace
.skip:
	cmp	rsi, Temp
	jne	.loop

	ret
;end postfix

testNumber:
	call	isDigit
	jne	.end
	stosb
.end:	ret
;end testNumber

testLeftBrace:
	cmp	al, '('
	jne	.end
	call	push2Stack
.end:	ret
;end testLeftBrace

testOperator:
	call	isOperator
	jne	.end
	call	stackEmpty
	je	.skip
.operatorLoop:
	call	cmpPrecedence
	jle	.skip
	call	pop2String
	call	stackEmpty
	jne	.operatorLoop
.skip:	call	push2Stack
.end:	ret
;end testOperator

isOperator:
	mov	rcx, OpLen
.loop:
	cmp	[Operators+rcx], al
	je	.end
	dec	rcx
	jnz	.loop
.end:
	ret
;end isOperator

cmpPrecedence:
	mov	bl, [OpPrecedence + rcx]
	mov	ah, [r8]
	xchg	ah,al
	call	isOperator
	mov	bh, [OpPrecedence + rcx]
	xchg	ah,al
	cmp	bh, bl
	ret
;end cmpPrecedence

testRightBrace:
	cmp	al, ')'
	jne	.end
.loop:
	call	stackEmpty
	je	.error
	cmp	[r8], '('
	je	.end
	call	pop2String
	jmp	.loop
.error:	
	call	invalidBraces
.end:	
	dec	r8
	ret
;end testRightBrace

stackEmpty:
	cmp	r8, Stack
	ret
;end stackEmpty

push2Stack:
	mov	[r8], al
	inc	r8
	ret
;end push2Stack

pop2String:
	mov	al, [r8]
	dec	r8
	stosb
	ret
;end pop2String

invalidBraces:
	mov	rsi, Error
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,ErrorLen    ;input is at most 1024 chars

	mov	rax,60
	mov	rdi,-1
	syscall
;end invalidBraces
