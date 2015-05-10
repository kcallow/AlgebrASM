%include "String.asm"
section	.data
mask	equ	BUFSIZE-1

section .bss
Input	resb	21*BUFSIZE	;Create 21 buffers: one for expression and 20 for variables
Temp	resb	21*BUFSIZE

section .text

removeWhitespace:
	mov	rsi,Input 	;Read characters from Input
	mov	rdi,Temp 	;Write characters to Temp
	mov	r8, BUFSIZE	;r8 counts bytes to next buffer to read
	mov	r9,BUFSIZE		;r9 counts bytes to next buffer to write
.loop:
	;Get current char in Input
	cmp	byte [rsi],' '	;If not whitespace, copy to Temp
	jng	.skip
	movsb			;Copy current char from Input to Temp
	dec	r9
	jmp	.skip2
.skip:	
	inc	rsi		;Skip whitespace char
.skip2:
	dec	r8
	jz	.nextBuffer	;If a multiple of BUFSIZE, go to next buffer in Temp
.continue:
	cmp	rsi,Temp	;Once all chars in Input have been read, end.
	jne	.loop
	ret

.nextBuffer:
	add	rdi,r9
	mov	r8, BUFSIZE
	mov	r9, BUFSIZE
	jmp	.continue

;end removeWhitespace

copyTemp2Input:
	mov	rsi,Temp 	;Read characters from Temp
	mov	rdi,Input	;Write characters to Input
	mov	rcx,21*BUFSIZE	;Do for all buffers
	rep	movsb		;Repeat copy operation for all 21*BUFSIZE chars
	ret
;end copyTemp2Input
