section .bss
VarName	resb	1024	; 1024 char variable name
VarValu	resb	26	; 64 bit integers are max 26 chars long

getVarNames:
	mov	rsi, Input	;Read from Input buffer
	mov	bl, ','		;Delimit with comma
	
	mov	rcx, 1024
.loop:
	mov	ah,[rsi]
	call	isUpperCase
	call	isLowerCase
	movsb
	dec	rcx
	jnz	.loop

getFirstVarName:
;Puts the first variable found in Input to VarName
	mov	rsi, Input	;Read from Input buffer
	mov	rdi, VarName	;Write to VarName
	mov	rcx,1024	;Erase 1024 chars
	call	clearString	;Erase previous data in VarName
	
	call	goToFirstLetter	
	cmp	rsi, Temp	;If searched all of Input without finding letter, end
	je	.end
.loop:
	movsb			;Write letter to VarName and keep reading if Input not done 
	;Write while reading letters
	cmp	rsi, Temp	;If searched all of Input, end
	je	.end
	
	mov	ah,[rsi]
	call	isLetter
	jz	.loop		;Stop writing if char not letter because found end of variable name
	
.end:
	ret
;end getFirstVarName

goToFirstLetter:
;Sets rsi to the first letter in buffer pointed by rsi
	mov	rcx, 1024
.loop:
	mov	ah,[rsi]
	call	isLetter	;If letter, stop reading
	jz	.end
	inc	rsi		;Else go to next char in buffer
	dec	rcx
	jnz	.loop
	
.end:
	ret
;end goToFirstLetter

