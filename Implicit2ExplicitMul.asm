%include "GetExpression.asm"

section .data

addAsterisks:
	mov	rsi,Input 	;Read characters from Input
	mov	rdi,Temp 	;Write characters to Temp
.loop:
	mov	ah, [rsi]	;Get last character read
	movsb
	call	validateImpMul
	jnz	.skip
	mov	al, '*'
	stosb			;Write asterisk to Temp and increment position
.skip:	cmp	rsi,Temp	;If all chars are read, stop
	jne	.loop
	ret
;end addAsterisks

validateImpMul:
;If last char read is digit and current char is letter or left parent, set zf.
	call	isAlphaNum	;If previous character is neither digit nor letter, skip to end
	jnz	.end		;Else test if current is literal or left paren
	mov	ah, [rsi]	;Get current char
	call	isUpperCase
	jz	.end
	call	isLowerCase
	jz	.end
	cmp	ah, '('
.end:	
	ret
;end validateImpMul

isAlphaNum:
;Sets zf if ah is letter or number
	call	isDigit		;If digit, zf is set and returns
	je	.end
	call	isUpperCase	;If uppercase letter, zf is set and returns
	je	.end
	call	isDigit		;If lowercase letter, zf is set and returns
.end:
	ret
;end isDigit

isDigit:
;Sets zf if ah is digit
	cmp	ah,'0'
	jl	.end
	cmp	ah,'9'
	jg	.end
	cmp	ah,ah	;Set zf
.end:
	ret
;end isDigit

isUpperCase:
;Sets zf if ah is uppercase letter
	cmp	ah,'A'
	jl	.end
	cmp	ah,'Z'
	jg	.end
	cmp	ah,ah	;Set zf
.end:
	ret
;end isUpperCase

isLowerCase:
;Sets zf if ah is lowercase letter
	cmp	ah,'a'
	jl	.end
	cmp	ah,'z'
	jg	.end
	cmp	ah,ah	;Set zf
.end:
	ret
;end isLowerCase