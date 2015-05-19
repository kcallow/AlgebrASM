%include "GetVariables.asm"
%include "Stack.asm"

section	.data
Operators	db	'_*/+-'
OpLen		equ	$ - Operators
OpPrecedence	db	'01122'
Error		db	'Error: invalid parenthesis.',10
ErrorLen	equ	$ - Error

section	.text
postfix:
	mov	rsi, Input
	mov	rdi, Temp
	mov	rcx,21*BUFSIZE
	call	clearString
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
	call	testRightBrace
.skip:
	cmp	rsi, Input + BUFSIZE
	jne	.loop

	call	popFinal
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

testOperator:
	call	isOperator
	jne	.end
	call	stackEmpty
	je	.skip


.operatorLoop:
	call	cmpPrecedence
	jg	.skip
	call	pop2String
	call	stackEmpty
	jne	.operatorLoop

.skip:
	call	push2Stack
	call	addSpace
	;call	printStack
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
	jne	.foundParen		;If a paren, skip to end
	call	getPrecedence
	xchg	ah,al
	xchg	bh,bl
	cmp	bh, bl
	ret

.foundParen:
	xchg	ah,al
	ret
;end cmpPrecedence

getPrecedence:
	mov	bl, [OpPrecedence + rcx - 1]
	ret
;end getPrecedence

testRightBrace:
	cmp	al, ')'
	jne	.end
.loop:
	call	stackEmpty
	je	invalidBraces
	call	getTop
	cmp	ah, '('
	je	.skip
	call	pop2String
	jmp	.loop
.skip:
	dec	r8
.end:	
	ret
;end testRightBrace

popFinal:
;While stack not empty, pop to string
.loop:
	call	stackEmpty
	je	.end
	call	pop2String
	cmp	byte [rdi-1],'(' 	;If just popped left paren, error bitch
	je	invalidBraces
	jmp	.loop
.end:	ret
;end popFinal

addSpace:
	mov	al, ' '
	stosb
	ret
;end addSpace

invalidBraces:
	mov	rsi, Error
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,ErrorLen    
	syscall

	mov	rax,60
	mov	rdi,-1
	syscall
;end invalidBraces
