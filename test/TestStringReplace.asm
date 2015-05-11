%include "../String.asm"

section .bss
origin	resb	BUFSIZE
keyword	resb	BUFSIZE
subs	resb	BUFSIZE
result	resb	BUFSIZE

section .text
global _start
_start:
;Get a string
	mov	rsi, origin	;Write to buffer
	call	read

;Get keyword
	mov	rsi, keyword	;Write to buffer
	call	read

;Get subsstitution
	mov	rsi, subs	;Write to buffer
	call	read

;Print result with all substitutions
	mov	rdi, origin
	mov	rsi, keyword
	mov	r8, subs
	mov	r10, result
	mov	rcx,BUFSIZE	;BUFSIZE chars max length
	mov	rdx,BUFSIZE	;BUFSIZE chars max length
	mov	r9,BUFSIZE	;BUFSIZE chars max length
	mov	r11,BUFSIZE	;BUFSIZE chars max length
	call	strReplaceAll
	mov	rsi, origin
	call	printBuffer
	mov	rsi, keyword
	call	printBuffer
	mov	rsi, subs
	call	printBuffer
	call 	printResult

	mov	rax,60
	mov	rdi,0
	syscall
;end _start

read:
	mov	rax,0
	mov	rdi,0
	mov	rdx,BUFSIZE
	syscall
	ret
;end read

printResult:
	mov	rsi, result
	call	printBuffer
	ret
;end printOrigin

