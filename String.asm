section .data
BUFSIZE	equ	1024

section	.bss
CharIn	resb	1

section	.text

strReplaceAll:
;Replaces all instances of rsi string in rdi string with r8 string
;Writes result to buffer in r10
;Takes rdi string len in rcx
;Takes rsi string len in rdx
;Takes r8 string len in r9
;Takes result max len in r11
.loop:
	call	strReplace
	cmp	rbx,0		;If str was not found, end.  rbx is find counter
	je	.end
	call	.copy
	jmp	.loop
.end:
	ret

.copy:
	push	rsi
	push	rdi
	push	rcx
	mov	rsi, r10
	rep	movsb
	pop	rcx
	pop	rdi
	pop	rsi
	ret
;end .copy
;end strReplaceAll

strReplace:
;Finds rsi keyword in rdi string. 
;Then writes rdi string to r10 result 
;with rsi keyword substituted by r8 substitution.
;Takes rsi keyword max len in rdx
;Takes rdi string max len in rcx
;Takes r8 substitution max len in r9
;Takes r10 result max len in r11
	push	rsi
	push	rdx
	push	rdi
	push	rcx
	push	r8
	push	r9
	push	r10
	push	r11

	mov	r15, rdi	;Preserve beginning of string
	cmp	r11, rcx	;If insufficient space, do nothing
	jl	.end
	cmp	rbx,0		;If str was not found, end.  rbx is find counter
	je	.end

	call	strFind		;Sets rdi to first instance of keyword.  Gets lengths.
	add	rdi, rdx	;Skip over keyword
	call	.clearR10Buffer
	call	.R8Len

	xchg	rdi, r10	;Make the result buffer the destination
	call 	.copyBeforeMatch
	call	.copySubstitution
	call	.copyAfterSubstitution
.end:
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rcx
	pop	rdi
	pop	rdx
	pop	rsi
	ret

.R8Len:
	push	rdi
	mov	rdi,r8		;To get lenght of r8, copy temorarily with rdi
	xchg	rcx,r9		;Treat r9 as rcx to get rsi length
	call	strLen		;Store r8 len in r9
	xchg	rcx,r9
	pop	rdi
	ret
;end .R8Len

.clearR10Buffer:
	push	rdi
	push	rcx
	mov	rdi, r10	;Make the result buffer the destination
	mov	rcx, r11
	call	clearString
	pop	rcx
	pop	rdi
	ret
;end .clearR10Buffer

.copyBeforeMatch:
	push	rsi
	push	rcx
	sub	rcx, rbx	;Get characters before match
	sub	rcx, rdx	;Skip keyword in chars to read from original string
	inc	rcx
	mov	rsi, r15	;Use beginning of string as source
	rep	movsb
	pop	rcx
	pop	rsi
	ret
;end .copyBeforeMatch

.copySubstitution:
	push	rsi
	push	rcx
	mov	rsi, r8		;Use substitution as source
	mov	rcx, r9		;Use len of substitution
	rep	movsb
	pop	rcx
	pop	rsi
	ret
;end .copySubstitution

.copyAfterSubstitution:
	push	rsi
	push	rcx
	mov	rsi, r10	;Use original string as source
	mov	rcx,rbx		;Use characters at and after match
	sub	rdx, r9
	jg	.skip
	neg	rdx
.skip:	add	rcx,rdx		;Skip keyword in chars to read 
	rep	movsb
	pop	rcx
	pop	rsi
	ret
;end .copyAfterSubstitution
;end strReplace

strFind:
;Finds first instance of rsi keyword in rdi string 
;Increments rdi to that position
;Takes rdi string max len in rcx
;Takes rsi keyword max len in rdx
	call	strLens
	;Read a until position strLen(rdi) - strLen(rsi) + 1
	mov	rbx,rcx		;Use rbx as counter for loop
	sub	rbx, rdx
	inc	rbx
	jl	.end		;If length of string is less than keyword, end
	xchg	rcx,rdx		;Compare the amount of chars in keyword
.loop:
	call	strCompare
	je	.end
	inc	rdi
	dec	rbx
	jnz	.loop		;If not found, try with next position
.end:	
	xchg	rcx,rdx		;Undo the exchange so rcx holds rdi len and rdx holds rsi len.
	ret
;end strFind

strCompare:
;Compares str in rdi to str in rsi
;Compares rcx chars
	push	rsi
	push	rdi
	push	rcx
	rep	cmpsb
	pop	rcx
	pop	rdi
	pop	rsi
	ret
;end strCompare

strLens:
;Gets lengths of rdi and rsi strings, puts in rcx and rdx respectively
	call	strLen		;Get length of rdi string, put in rcx

	xchg	rdi,rsi		;To get lenght of rsi, swap temorarily with rdi
	xchg	rcx,rdx		;Treat rdx as rcx to get rsi length
	call	strLen		;Store rsi len in rdx
	xchg	rcx,rdx
	xchg	rdi,rsi		
	ret
;end strLens


strLen:
;Reads string in rdi. Preserves its value
;Takes maximum length in rcx and decrements for each unused char
	push	rdi
.loop:	;Decrement for each null char at end of string
	cmp	byte [rdi + rcx - 1],0
	jne	.end		;If non null char found, stop decrementing
	dec	rcx
	jnz	.loop
.end:
	pop	rdi
	ret
;end strLen

print:
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,21*BUFSIZE        ;input is at most BUFSIZE chars
        syscall
	ret
;end print

clearString:
;Clears rcx bytes from string in rdi
	push	rdi
	push	rcx
	mov	al,0		;Write zeros to string in rdi
	rep	stosb
	pop	rcx
	pop	rdi
	ret
;end clearString


getString:
;Puts to string given by rdi
;Reads separator character from bl
;Reads maximum of rcx chars
;r8 holds chars to next buffer
	mov	r8, BUFSIZE
.loop:
	call	getChar
	cmp	rax,0		;If no chars found, end.
	je	.end

	mov	al,[CharIn]
	cmp	bl,al		;If separator found, end.
	je	.nextBuffer
	stosb			;Else write char
	dec	r8
	dec	rcx		;Unless more than size
	jnz	.loop
.end:
	call	getChar		;Consume final newline
	ret
	
.nextBuffer:
	add	rdi,r8		;Go to next buffer
	mov	r8, BUFSIZE
	jmp	.loop
;end getString

getChar:
;Puts char from stdin to CharIn
	push	rdi
        mov     rax,0           ;sys_read
	mov     rdi,0           ;Read from std input
	mov	rsi,CharIn
	mov     rdx,1		;read 1 character
	syscall
	pop	rdi
	ret
;end getChar

newline:
	push	rcx
	push	rsi
	push	rax
	push	rdi
	push	rdx
	mov	byte [CharIn], 10
	mov	rsi, CharIn
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;newline is single char
        syscall
	pop	rdx
	pop	rdi
	pop	rax
	pop	rsi
	pop	rcx
	ret
;end newline

equals:
	push	rcx
	push	rsi
	push	rax
	push	rdi
	push	rdx
	mov	byte [CharIn], '='
	mov	rsi, CharIn
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1		;equals is single char
        syscall
	pop	rdx
	pop	rdi
	pop	rax
	pop	rsi
	pop	rcx
	ret
;end equals
