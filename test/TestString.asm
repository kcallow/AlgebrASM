%include "../String.asm"

section .bss
string1	resb	1024
string2	resb	1024

section .data
true	db	"True or equal.   ",10
false	db	"False or unequal.",10


section .text
global _start
_start:
;Get a string
	mov	rdi, string1	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString

;Print string
	mov	rsi, string1
	call	print

;Get string length
	mov	rdi, string1	;Write to input buffer
	mov	rcx,1024	;1024 chars max
	call	strLen

;Print an asterisk for each non null character. len(string1) times
;This is to test value in rcx
	mov	byte [CharIn], '*'
	mov	rsi, CharIn
	mov	r9,rcx
.loop:
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;asterisk is single char
        syscall
	dec	r9
	jnz	.loop

	mov	byte [CharIn], 10
	mov	rsi, CharIn
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;newline is single char
        syscall

;Get another string
	mov	rdi, string2	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	mov	rcx,1024	;Read 1024 chars max
	call	getString

;Print string2
	mov	rsi, string2
	call	print

;Get string2 length
	mov	rdi, string2	;Write to input buffer
	mov	rcx,1024	;1024 chars max
	call	strLen

;Print an asterisk for each non null character. len(string2) times
;This is to test value in rcx
	mov	byte [CharIn], '*'
	mov	rsi, CharIn
	mov	r9,rcx
.loop2:
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;asterisk is single char
        syscall
	dec	r9
	jnz	.loop2

	mov	byte [CharIn], 10
	mov	rsi, CharIn
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;newline is single char
        syscall

;Compare strings. Print message
	mov	rdi, string1
	mov	rsi, string2
	mov	rcx,1024	;1024 chars max length
	call	strCompare
	call	printMessage

	mov	rax,60
	mov	rdi,0
	syscall
;end _start

printMessage:
	jne	.notEqual
	mov	rsi, true
	jmp	.skip
.notEqual:
	mov	rsi, false
.skip:
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,18        	;message is 18 chars
        syscall
	ret
;end printMessage

