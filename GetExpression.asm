section .bss
Input	resb	1024
Temp	resb	1024
CharIn	resb	1

section .data
global _start
_start:
	mov	rdi, Input	;Write to input buffer
	mov	bl, ','		;Comma is delimitor for input
	call	getString
	call	removeWhitespace

	call	copyTemp2Input

        mov     rsi,Input
	call	print

	mov	rdi,Input
	call	clearString

	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start

clearString:
	mov	al,0		;Write zeros to string in rdi
	mov	rcx,1024	;Do for all 1024 chars in string
	rep	stosb
	ret
;end clearString

getString:
;Puts to string given by rdi
;Reads separator character from bl
	mov	rcx,1024
.loop:
	call	getChar
	cmp	bl,al		;If separator found, end.
	je	.end
	stosb			;Else write char
	dec	rcx		;Unless more than 1024
	jnz	.loop
.end:
	ret
;end getString

getChar:
;Puts char from stdin to al
	push	rdi
	push	rcx
        mov     rax,0           ;sys_read
	mov     rdi,0           ;Read from std input
	mov	rsi,CharIn
	mov     rdx,1		;read 1 character
	syscall
	pop	rcx
	pop	rdi
	mov	al,[CharIn]
	ret
;end getChar

removeWhitespace:
	mov	rsi,Input 	;Read characters from Input
	mov	rdi,Temp 	;Write characters to Temp
.loop:
	;Get current char in Input
	cmp	byte [rsi],' '	;If not whitespace, copy to Temp
	jng	.skip
	movsb			;Copy current char from Input to Temp
	jmp	.skip2
.skip:	
	inc	rsi		;Skip whitespace char
.skip2:
	cmp	rsi,Temp	;Once all chars in Input have been read, end.
	jne	.loop
	ret
;end removeWhitespace

copyTemp2Input:
	mov	rsi,Temp 	;Read characters from Temp
	mov	rdi,Input	;Write characters to Input
	mov	rcx,1024	;Do 1024 times
	rep	movsb		;Repeat copy operation for all 1024 chars
	ret
;end copyTemp2Input

print:
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1024        ;input is at most 1024 chars
        syscall
	ret
;end print
