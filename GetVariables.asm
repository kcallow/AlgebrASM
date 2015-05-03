%include "Implicit2ExplicitMul.asm"

section .bss
VarName	resb	1024	; 1024 char variable name
VarValu	resb	26	; 64 bit integers are max 26 chars long

section	.text

getAndReplaceAllVars:
	call	getFirstVarName
	jz	.end			;Stop when none were found.
	mov	rsi, VarName
	call	print
	call	equals
	call	getVarValue

	mov	rdi, Temp
	mov	rcx, 1024
	call	clearString

	call	replaceNameWithValue
	jmp	getAndReplaceAllVars	;Try again if found a var.  
.end:
	ret
;end getAndReplaceAllVars

getFirstVarName:
;Puts the first variable found in Input to VarName
	mov	rsi, Input	;Read from Input buffer
	mov	rdi, VarName	;Write to VarName
	mov	rcx,1024	;Erase 1024 chars
	call	clearString	;Erase previous data in VarName
	
	call	goToFirstLetter	
	cmp	rsi, Temp	;If searched all of Input without finding letter, end
	jz	.end

.loop:
	movsb			;Write letter to VarName and keep reading if Input not done 
	dec	rcx		;rcx is counter for previous loop.  Holds chars after first letter
	;If searched all of Input without finding letter, end
	je	.end
	
	;Write while reading letters
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

getVarValue:
	mov	rdi, VarValu
	mov	rcx,26		;Erase 26 chars
	call	clearString	;Erase previous data in VarValu
	mov	rcx, 26
	mov	bl, ','		;Delimit with comma
	call	getString
	ret
;end getVarValue

replaceNameWithValue:
	mov	rdi, Input
	mov	rcx, 1024
	mov	rsi, VarName
	mov	rdx, 1024
	mov	r8, VarValu
	mov	r9,26
	mov	r10, Temp
	mov	r11, 1024
	call	strReplaceAll
	ret
;end replaceNameWithValue:
