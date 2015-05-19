%include "Eval.asm"
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

	call	plusMinusSub
	call	minusMinusSub
	call	timesMinusSub
	call	divMinusSub

	call	postfix
	call	copyTemp2Input

	call	under2MinusSub

	call	inicio

	mov	rsi, Input
	call	printBuffer

	mov	rax,60
	mov	rdi,0
	syscall
;end _start

plusMinusSub:
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
;end plusMinusSub

minusMinusSub:
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
;end minusMinusSub

timesMinusSub:
;Substitute '*-' for '*_'
	mov	rdi, Input
	mov	rsi, .keywrd
	mov	r8, .subs
	mov	r10, Temp
	mov	rcx,BUFSIZE	;BUFSIZE chars max length
	mov	rdx,2		;2	 chars max length
	mov	r9,2		;2	 chars max length
	mov	r11,BUFSIZE	;BUFSIZE chars max length
	call	strReplaceAll
	ret
.keywrd db	'*-'
.subs	db	'*_'
;end timesMinusSub


divMinusSub:
;Substitute '/-' for '/_'
	mov	rdi, Input
	mov	rsi, .keywrd
	mov	r8, .subs
	mov	r10, Temp
	mov	rcx,BUFSIZE	;BUFSIZE chars max length
	mov	rdx,2		;2	 chars max length
	mov	r9,2		;2	 chars max length
	mov	r11,BUFSIZE	;BUFSIZE chars max length
	call	strReplaceAll
	ret
.keywrd db	'/-'
.subs	db	'/_'
;end divMinusSub

under2MinusSub:
;Substitute '_' for '-'
	mov	rdi, Input
	mov	rsi, .keywrd
	mov	r8, .subs
	mov	r10, Temp
	mov	rcx,BUFSIZE	;BUFSIZE chars max length
	mov	rdx,1		;1	 chars max length
	mov	r9,1		;1	 chars max length
	mov	r11,BUFSIZE	;BUFSIZE chars max length
	call	strReplaceAll
	ret
.keywrd db	'_'
.subs	db	'-'
;end under2MinusSub
