%include "../String.asm"

section .bss
origin	resb	1024
keyword	resb	1024
subs	resb	1024
result	resb	1024

section .text
global _start
_start:
;Get a string
	mov	rdi, origin	;Write to buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString

;Get keyword
	mov	rdi, keyword	;Write to buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString

;Get subsstitution
	mov	rdi, subs	;Write to buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString

;Print result with single substitution
	mov	rdi, origin
	mov	rsi, keyword
	mov	r8, subs
	mov	r10, result
	mov	rcx,1024	;1024 chars max length
	mov	rdx,1024	;1024 chars max length
	mov	r9,1024		;1024 chars max length
	mov	r11,1024	;1024 chars max length
	call	strReplaceAll
	call 	printOrigin

	mov	rax,60
	mov	rdi,0
	syscall
;end _start

printOrigin:
	push	rsi
	push	rcx
	mov	rsi, origin
	call	print
	pop	rcx
	pop	rsi
	ret
;end printOrigin

