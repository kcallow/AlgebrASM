%include "String.asm"

section .bss
Input	resb	1024
Temp	resb	1024

section .text

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
