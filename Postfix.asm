%include "GetVariables.asm"

section .bss
Stack	resb	1024

section	.data
Operators	db	'*/+-'
OpLen		equ	$ - Operators
OpPrecedence	db	'1122'
Error		db	'Error: invalid parenthesis.',10
ErrorLen	equ	$ - Error

section	.text
postfix:
	mov	rsi, Input
	mov	rdi, Temp
	mov	r8, Stack	;Use r8 as stack pointer
.loop:
	lodsb		;Put current char in al, inc rsi
	call	testNumber
	je	.skip
	call	testLeftBrace
	je	.skip
	call	testOperator
	je	.skip
;	call	testRightBrace
.skip:
	cmp	rsi, Input + BUFSIZE
	jne	.loop

	call	newline
	call	printStack
	call	newline
	ret
;end postfix

testNumber:
	mov	ah,al
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

printStack:
	push	rsi
	push	rax
	push	rdi
	push	rdx
	mov	rsi, Stack
	call	print
	pop	rdx
	pop	rdi
	pop	rax
	pop	rsi
	ret
;end printStack

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

.skip:	
	call	equals
	call	push2Stack
	call	addSpace
	cmp	rax,rax		;Set zf
.end:	ret
;end testOperator

isOperator:
	mov	rcx, OpLen
.loop:
	cmp	[Operators+rcx-1], al
	je	.end
	dec	rcx
	jz	.notOp
	jmp	.loop
.notOp:
	inc	rcx
.end:
	ret
;end isOperator

cmpPrecedence:
	call	isOperator
	call	getPrecedence
	call	getTop
	xchg	ah,al
	xchg	bh,bl
	call	isOperator
	call	getPrecedence
	xchg	ah,al
	xchg	bh,bl
	push	rcx
	push	rsi
	push	rax
	push	rdi
	push	rdx
	mov	byte [CharIn], bh
	mov	rsi, CharIn
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;equals is single char
        syscall
	mov	byte [CharIn], bl
	mov	rsi, CharIn
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;equals is single char
        syscall
	pop	rdx
	pop	rdi
	pop	rax
	pop	rsi
	pop	rcx
	cmp	bh, bl
;	pop	rax
.skip	ret
;end cmpPrecedence

getPrecedence:
	mov	bl, [OpPrecedence + rcx - 1]
	ret
;end getPrecedence

getTop:
	xchg	r8, rbx
	mov	ah, [rbx-1]
	xchg	r8, rbx
	ret
;end getTop

testRightBrace:
	cmp	al, ')'
	jne	.end
.loop:
	call	stackEmpty
	je	.error
	call	getTop
	cmp	ah, '('
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
	dec	r8
	mov	al, [r8]
	stosb
	ret
;end pop2String

addSpace:
	mov	al, ' '
	stosb
	ret
;end addSpace

invalidBraces:
	mov	rsi, Error
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,ErrorLen    ;input is at most 1024 chars

	mov	rax,60
	mov	rdi,-1
	syscall
;end invalidBraces
