%include "../Implicit2ExplicitMul.asm"

section .data
global _start
_start:
	mov	rdi, Input	;Write to input buffer
	mov	bl, 4		;EOT character is delimitor for input
	call	getString

	call	addAsterisks

        mov     rsi,Temp
	call	print

	mov	rax,60
	mov	rdi,0
	syscall
;end _start
