%include "../Implicit2ExplicitMul.asm"

section .data
global _start
_start:
	call	getInput

	call	addAsterisks

        mov     rsi,Temp
	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
