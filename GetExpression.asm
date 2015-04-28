section .bss
Input	resb	1024
Temp	resb	1024

section .data
global _start
_start:
	call	getInput
	call	removeWhitespace

        mov     rsi,Temp
	call	print

	call	copyTemp2Input

        mov     rsi,Input
	call	print

	mov	rdi,Input
	call	clearString

	call	print

	mov	rax,1
	int	80h
;end _start

clearString:
	mov	al,0		;Write zeros to string in rdi
	mov	rcx,1024	;Do for all 1024 chars in string
	rep	stosb
	ret
;end clearString

getInput:
        mov     rax,0           ;sys_read
	mov     rdi,0           ;Read from std input
	mov     rsi,Input       ;Put in input space
	mov     rdx,1024        ;read 1 character
	syscall
	ret
;end getInput

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
