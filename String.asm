clearString:
;Clears rcx bytes from string in rdi
	mov	al,0		;Write zeros to string in rdi
	rep	stosb
	ret
;end clearString

strLens:
;Gets lengths of rdi and rsi strings, puts in ecx and edx respectively
	call	strLen		;Get actual length of rdi string, put in rcx

	xchg	rdi,rsi		;To get lenght of rsi, swap temorarily with rdi
	xchg	rcx,rdx		;Treat rdx as rcx to get rsi length
	call	strLen		;Store rsi len in rdx
	xchg	rcx,rdx
	xchg	rdi,rsi		
	ret
;end strLens
	

strReplace:
;Replaces first instance of rsi string in rdi string with r8 string
;Takes rdi string len in rcx
;Takes rsi string len in rdx
;Takes r8 string len in r9
	call	strFind
	cmp	rcx,0		;If str was not found, end
	je	.end
	xchg	r8,rsi
	xchg	r9,rcx
	push	rcx
	rep	movsb
	pop	rcx
	xchg	r8,rsi
	xchg	r9,rcx
.end:
	ret
;strReplace

strFind:
;Finds first instance of rsi string in rdi string 
;Takes rdi string len in rcx
;Takes rsi string len in rdx
	sub	rcx,rdx		;Read a until position strLen(rdi) - strLen(rsi)
.loop:
	call	strCompare
	je	end
	inc	rdi
	dec	rcx
	jnz	.loop		;If not found, try with next position
.end:	
	ret
;end strFind

strCompare:
;Compares str in rdi to str in rsi
;Uses len of str in rdi.  Takes rcx as its maximum length.
	push	rsi
	push	rdi
	call	strLen		;Put len in rcx
	rep	cmpsb
	pop	rdi
	pop	rsi
	ret
;end strCompare

strLen:
;Reads string in rdi
;Takes maximum length in rcx and removes unused chars
.loop:	;Decrement for each null char at end of string
	cmp	byte [rdi + rcx],0
	jne	.end		;If non null char found, stop decrementing
	dec	rcx
	jnz	.loop
.end:
	ret
;end strLen
	
print:
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1024        ;input is at most 1024 chars
        syscall
	ret
;end print

getString:
;Puts to string given by rdi
;Reads separator character from bl
;Reads maximum of rcx chars
.loop:
	push	rdi
	push	rcx
	call	getChar
	pop	rcx
	pop	rdi
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
        mov     rax,0           ;sys_read
	mov     rdi,0           ;Read from std input
	mov	rsi,CharIn
	mov     rdx,1		;read 1 character
	syscall
	mov	al,[CharIn]
	ret
;end getChar
