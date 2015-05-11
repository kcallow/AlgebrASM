%include "Implicit2ExplicitMul.asm"

section .bss
ValuLen	equ	26
VarName	resb	BUFSIZE	; BUFSIZE char variable name
VarValu	resb	ValuLen	; 64 bit integers are max ValuLen chars long

section	.text

getAndReplaceAllVars:

	mov	rsi, Input	;Read from Input buffer
	add	rsi,BUFSIZE	;Skip expression buffer
.loop:
	call	.loopBody
	call	.loopBody
	call	.loopBody
	call	.loopBody
;	cmp	rsi, Temp	;If no more buffers, end
;	jnz	.loop
.end:
	ret

.loopBody:
	mov	rdi, Temp
	push	rsi
	call	getVar
	call	replaceNameWithValue
	call	copyExpression
	pop	rsi
	add	rsi,BUFSIZE	;Go to next buffer
	call	newline
	call	printVar
	ret
;end .loopBody

;end getAndReplaceAllVars

printVar:
	push	rcx
	push	rsi
	push	rax
	push	rdi
	push	rdx
	mov	rsi,VarName
	call	printBuffer
	call	equals
        mov     rax,1           ;call to system's 'write'
	mov	rsi,VarValu
        mov     rdi,1           ;write to the standard output
        mov     rdx,ValuLen
        syscall
	pop	rdx
	pop	rdi
	pop	rax
	pop	rsi
	pop	rcx
	ret
;end printVar

getVar:
;Puts the first variable found in rsi to VarName
;Puts its value in VarValu
	call	clearVarName
	mov	rcx, BUFSIZE
	call	nameLoop

	cmp	ah,'='		;If ah is not equals sign, raise error!
	jne	.error

	inc	rsi		;Skip =

	call	clearVarValu
	mov	rcx, ValuLen
	call	testNegative
	call	valLoop
.end:
	ret

.error:
	ret
;end getVar

clearVarName:
	mov	rdi, VarName	;Write to VarName
	mov	rcx,BUFSIZE	;Erase BUFSIZE chars
	call	clearString	;Erase previous data in VarName
	ret
;end clearVarName
	
clearVarValu:
	mov	rdi, VarValu	;Write to VarValu`
	mov	rcx, ValuLen
	call	clearString	;Erase previous data in VarName
	ret
;end clearVarValu
	
nameLoop:
	;Write while reading letters
	mov	ah,[rsi]
	call	isLetter
	jnz	.end		;Stop writing if char not letter because found end of variable name

	movsb			;Write letter to VarName and keep reading if Input not done 
	dec	rcx
	jnz	nameLoop
.end:
	ret
;end nameLoop

testNegative:
	cmp	byte [rsi], '-'	;If negative number, write sign
	jne	.end
	movsb			;Write number to VarName and keep reading if Input not done 
	dec	rcx		
.end:	ret
;end testNegative

valLoop:
	;Write while reading numbers
	mov	ah,[rsi]
	call	isDigit
	jnz	.end		;Stop writing if char not number because found end of variable value

	movsb			;Write number to VarName and keep reading if Input not done 
	dec	rcx	
	jnz	valLoop
.end:
	ret
;end valLoop


replaceNameWithValue:
	mov	rdi, Input
	mov	rcx, BUFSIZE
	mov	rsi, VarName
	mov	rdx, BUFSIZE
	mov	r8, VarValu
	mov	r9,ValuLen
	mov	r10, Temp
	mov	r11, BUFSIZE
	call	strReplaceAll
	ret
;end replaceNameWithValue:

copyExpression:
	push	rsi
	push	rdi
	push	rcx
	mov	rsi,Temp 	;Read characters from Temp
	mov	rdi,Input	;Write characters to Input
	mov	rcx,BUFSIZE	;Do for first buffer
	rep	movsb		;Repeat copy operation for all BUFSIZE chars
	pop	rcx
	pop	rdi
	pop	rsi
	ret
;end copyExpression
