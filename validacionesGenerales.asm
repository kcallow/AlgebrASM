section .bss
	varTmp:		resb 26			;cada # de 26 chars 
	lenVarTmp:	equ $ - varTmp	;array Variables**
	textIn:		resb 1024	
	lenTextIn:	equ $ - textIn

section .data
	msgErrRead:     db "Info. No se ingresaron datos.",0x0A
        lenMsgErrRead:  equ $ - msgErrRead
	msgErr:		db 0x0A,"Error. Simbolos mal empleados",0x0A
        lenMsgErr:	equ $ - msgErr
        msgOk:          db "Validación aprobada.",0x0A
        lenMsgOk:       equ $ - msgOk

	msgErrVar:	db 0x0A,"Error. Variable no inicializada o simbología incorrecta.",0x0A
        lenMsgErrVar:	equ $ - msgErrVar

	operandos:	db "*/+)-(0" ; 0 marca el fin. NO CAMBIAR ORDEN
	lenOperandos:	equ $ -operandos
section .text
	global _start
	_start

main:	
	call read
	xor r9, r9	;curret
	xor r11, r11
	xor rcx, rcx
	call first
	call checkVar
	call main
	call exit

checkVar:	;r8 max len
	mov rcx, r8
	.bucle:	
		;cmp rcx, 0
		;je exit
		mov ax,[textIn + r9]	;mov al, ...
                cmp al, '0'
		jb .operandosExp	; por debajo del '0'
                cmp al, '9'
		ja .errorVar
		jmp .pass	        ;ja .error
	.operandosExp:
		xor rdx, rdx	;	!!!!!
		dec rdx
	.nextOp:
		inc r9	
		cmp r9, r8
		je lastChar
		dec r9
		inc rdx
		cmp rdx, lenOperandos
		je .error	
		mov bl, [operandos + rdx]	;mov bl, 
		cmp al, bl		;je .pass
		je .nextInExp;.pass
		jne .nextOp
	;end .nextOP
	.nextInExp:	;"*-+/)(0"
		xor rdx, rdx
		cmp al, ')';	jne .auxNext
		je .pass
	.auxNext:
		cmp rdx, 3
		je .pass
		cmp ah, [operandos +rdx]
		je .error
		inc rdx
		jmp .auxNext
	.errorVar: ; error de variables
		jmp printErrVar
		jmp exit
	.error:	;error de simbolos
		jmp printErrValidacion
		jmp exit
	.pass:	
		inc r9
		cmp r9, r8
		jne .bucle	;pop rcx
		ret
;end checkVar
first:	
	mov al, [textIn]
.loop
	cmp rcx, 4
	je .continueF
	cmp al, [operandos +rcx]	
	je printErrValidacion
	inc rcx
	jmp .loop
	.continueF
	xor rcx, rcx
	ret
lastChar:
	cmp al, ')'
	jne  printErrValidacion
	jne exit
	ret

read:
            mov rax, 0              ;sys_read
            mov rdi, 1              ;std_in
            mov rsi, textIn
            mov rdx, lenTextIn
            syscall	    
            dec rax                 ;!!!! -ultimo  char
            mov r8, rax             ;guardar len
            ret
exit:
   mov rax, 60			; sys_exit (code 60)
   mov rdi, 0			; exit code (code 0 = normal)
   syscall 
; end exit
printErrValidacion:
	mov rsi, msgErr
        mov rdx, lenMsgErr
        call printError
	ret
printErrVar:
	mov rsi, msgErrVar
        mov rdx, lenMsgErrVar
        call printError
	ret
printError:
        mov rax, 1              ;sys_write
        mov rdi, 2              ;std_err
        syscall
        ret
