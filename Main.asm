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

	call	negativeSubs
	call	positiveSubs

	call	postfix
	call	copyTemp2Input

	mov	rsi, Input
	call	printBuffer

	mov	rax,60
	mov	rdi,0
	syscall
;end _start

negativeSubs:
;Substitute '+-' for '-'
	mov	rdi, Input
	mov	rsi, .keywrd
	mov	r8, .subs
	mov	r10, Temp
	mov	rcx,BUFSIZE	;BUFSIZE chars max length
	mov	rdx,2		;2	 chars max length
	mov	r9,1		;1	 chars max length
	mov	r11,BUFSIZE	;BUFSIZE chars max length
	call	strReplaceAll
	ret
.keywrd db	'+-'
.subs	db	'-'
;end negativeSubs

positiveSubs:
;Substitute '--' for '+'
	mov	rdi, Input
	mov	rsi, .keywrd
	mov	r8, .subs
	mov	r10, Temp
	mov	rcx,BUFSIZE	;BUFSIZE chars max length
	mov	rdx,2		;2	 chars max length
	mov	r9,1		;1	 chars max length
	mov	r11,BUFSIZE	;BUFSIZE chars max length
	call	strReplaceAll
	ret
.keywrd db	'--'
.subs	db	'+'
;end positiveSubs

