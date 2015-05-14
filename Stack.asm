
section .bss
Stack	resb	1024

section	.text
printStack:
	push	rsi
	push	rax
	push	rdi
	push	rdx
	mov	rsi, Stack
        mov     rax,1           ;call to system's 'write'
        mov     rdi,1           ;write to the standard output
        mov     rdx,1024        ;input is at most 1024 chars
        syscall
	pop	rdx
	pop	rdi
	pop	rax
	pop	rsi
	ret
;end printStack

getTop:
	xchg	r8, rbx
	mov	ah, [rbx-1]
	xchg	r8, rbx
	ret
;end getTop

stackEmpty:
	cmp	r8, Stack
	ret
;end stackEmpty

push2Stack:
	mov	[r8], al
	inc	r8
	ret
;end push2Stack

pop2String:
	push	rax
	dec	r8
	mov	al, [r8]
	stosb
	pop	rax
	ret
;end pop2String

