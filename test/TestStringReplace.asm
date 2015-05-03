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

;Test strFind
;Print from first instance on
	mov	rdi, origin
	mov	rsi, keyword
	mov	rcx,1024	;1024 chars max length
	mov	rdx,1024	;1024 chars max length
	call	strFind

	xchg	rsi,rdi

        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,rbx
        syscall

;Test strReplace

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
