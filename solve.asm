section .bss

	num resb 1024

	prueba resb 1024

	op1 resb 1024

	op2 resb 1024

	resul resb 1024

	stack resb 1024

	cambio resb 1024



section .data

		Postfix db '71 101 10++',10
		lenPos equ $ -Postfix

		Input db '71+28',10
		lenInput equ $ -Input

		error db 'No se puede hacer division entre 0',10
		lenError equ $ - error
	

section .text

	global _start

_start:

inicio:
	mov 	r11,0 ;contador para meter a num
	mov 	r10,0 ;contador para recorrer expresion
	mov 	cl,'0' ; se va a meter un '0' porque se va a comparat cl y al
	mov 	r15,-1 ;coontador para crear expresion concatenada
	mov 	r8,0	;contador de cuantos caracteres hay en pila 
	mov 	r13,0	;contador para ver cuantos numeros hay

eval: 
	mov 	al, byte[Postfix+r10]; moviendo lo que hay en
	cmp 	al,'0'				;30h, viendo si es un operando u operador
	jb 		operador 			; si es menor es un operador, de lo contratario

concat:
	mov 	byte[num+r11],al	;si no es operador, es operando
	inc 	r11					; se incrementa el contador del numero en construccion
	inc 	r10					; se incrementa contador de la cadena principal 
	mov 	cl, al				; se va a copiar valor en cl para hacer comparaciones
	cmp 	r10,lenPos 			; si es igual termine, pero igual nunca va a terminar aca porque siempre de ultimo esta un operador 
	jne 	eval  				;si no es igual salte
	jmp 	fin


preCreoExpresion1:
	push 	r8
	push 	r15 
	push 	rcx
	mov 	r15,-1;limpio contador 
	xor 	r8,r8 ;limpio contador para recorrer expresion destino


creoExpresion1:
	inc 	r15 ; se va a recorrer 15 para concatenar a buffer
	cmp 	byte [op1+r15],0; si es vacio
	je 		preCreoExpresion2 ;se va a crear numero 2 para concatenar
	mov 	cl,byte [op1+r15]
	mov 	byte [cambio+r8],cl
	inc 	r8 ;r8 va a recorrer expresion donde se va a guardar
	jmp 	creoExpresion1 

preCreoExpresion2:
	mov 	r15,-1 ;limpio contador 
	;no se va a limpiar contador r8 porque se ocupa para seguir concat
	mov 	byte[cambio+r8],al ;se le va a mover signo actual
	inc 	r8

creoExpresion2:
	inc 	r15 ; se va a recorrer 15 para concatenar a buffer
	cmp 	byte [num+r15],0; si es vacio
	je 		preCambio ;se va a crear numero 2 para concatenar
	mov 	cl,byte[num+r15]
	mov 	byte [cambio+r8],cl
	inc 	r8 ;r8 va a recorrer expresion donde se va a guardar
	jmp 	creoExpresion2

preCambio
	;mov byte[prueba+0],al 
	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,op1
	;mov 	rdx, 1024												
	;syscall

	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,prueba
	;mov 	rdx, 1024												
	;syscall

	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,num
	;mov 	rdx, 1024												
	;syscall

	pop 	rcx
	pop 	r15 
	pop 	r8 
	jmp 	operoexpresion


operador:
	cmp 	al,' ' 
	je 		pushnum

	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,stack
	;mov rsi,num
	;mov 	rdx, 1024												
	;syscall
	;jmp fin 

; mov [buff],al

operar:
	;tengo que hacer pop de ultimo numero 
	;al tiene signo actual
;	jmp fin 
	push 	rdi 
	push 	rsi
	push 	rdx
	push 	rax
	mov byte[prueba+0],al  ;estoy guardando el signo en prueba 

	jmp popstack

;	jmp popstack ;tengo que sacar primer numero 
conseguiNum1:

	pop 	rax 
	jmp preCreoExpresion1



operoexpresion:
	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,cambio
	;mov 	rdx, 1024												
	;syscall
	;jmp fin

	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,cambio
	;mov 	rdx, 1024												
	;syscall

	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,prueba
	;mov 	rdx, 1024												
	;syscall

	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov 	rsi,num
	;mov 	rdx, 1024												
	;syscall
	;jmp fin 

	;pop 	rax

	mov al,byte[prueba+0] ;pasando el signo 
	pop 	rdx 
	pop 	rsi 
	pop 	rdi 

.atoi:
		mov edi, 0
		mov r13,-1

		.dameLen1:
			inc r13
			cmp byte[op1 + r13], 0
			jne .dameLen1
			inc r13

			xor r12,r12
			mov r12,10;para dividir entre 10
			xor rcx,rcx
			mov rcx,-1;indice de los chats
			xor r11,r11
			xor r10,r10
			mov r10,0;respuesta
			xor r9,r9;recorrido total
			mov r9,r13
			dec r9
	
	.ciclo11:
		inc rcx
		mov r11,r13
		dec r11
		sub r11,rcx
	
		mov bl, byte[op1 + rcx]
		sub bl,'0'
		mov rax,rbx

		.ciclo21:
			mul r12
			dec r11
			cmp r11,0

		ja .ciclo21
		div r12
		add r10,rax
		dec r9
		cmp r9,0
	ja .ciclo11

;atoi2

		mov r14,r10
		;mov edi, 0
		mov r13,-1

		.dameLen2:
			inc r13
			cmp byte[num + r13], 0
			jne .dameLen2
			inc r13

			xor r12,r12
			mov r12,10;para dividir entre 10
			xor rcx,rcx
			mov rcx,-1;indice de los chats
			xor r11,r11
			xor r10,r10
			mov r10,0;respuesta
			xor r9,r9;recorrido total
			mov r9,r13
			dec r9
	
	.ciclo12:
		inc rcx
		mov r11,r13
		dec r11
		sub r11,rcx
	
		mov bl, byte[num + rcx]
		sub bl,'0'
		mov rax,rbx

		.ciclo22:
			mul r12
			dec r11
			cmp r11,0

		ja .ciclo22
		div r12
		add r10,rax
		dec r9
		cmp r9,0
	ja .ciclo12

	mov edi,-1
	xor rax,rax

	mov rax,r14
;atoi:
;	push rcx	;tengo valor anterior 
	;push rax	;tengo signo 
;	push r10 	;contador para recorrer expresion principa;
;	push rbx 
;	push r14
	;op1
;	xor rax,rax 
;	xor rbx,rbx 
;	mov rcx, 0 	
;	xor r14,r14											; contador
;	mov al, byte[op1 + rcx]								; mueve el primer caracter
;	sub rax, 0x30										; transforma el rax a numero
;	mov r10, 10		

												; mueve 10 para multiplicar con el rax
;	.loopAtoi1:	
;		inc rcx											; incrementa contador
;		mov bl, byte[op1 + rcx]							; mueve el siguiente caracter al bl
;		sub rbx, 0x30									; transforma a numero
;		mul r10											; multiplica el rax * 10
;		add rax, rbx									; suma el rbx con el rax 
;		cmp bl,'0'										; comparo a ver si termine de ver buffer , es menor a 0 un espacio 
;		jae .loopAtoi1									; si es mayor o igual es un numero 


;	mov r14,rax											;copio valor de rax, que tiene primer numero 
;	xor rax,rax											;limpio rax de nuevo	
;	xor rbx,rbx											;se limpia para volver a usar 
;	mov rcx, 0 											; contador

;	mov al, byte[num + rcx]								; mueve el primer caracter
;	sub rax, 0x30										; transforma el rax a numero										; mueve 10 para multiplicar con el rax
;	.loopAtoi2:	
;		inc rcx											; incrementa contador
;		mov bl, byte[num + rcx]							; mueve el siguiente caracter al bl
;		sub rbx, 0x30									; transforma a numero
;		mul r10											; multiplica el rax * 10
;		add rax, rbx									; suma el rbx con el rax 
;		cmp bl,'0'								; compara el rcx con el largo del numero.
;		jae .loopAtoi2	


	;mov 	bl,byte[prueba+0];
;	xchg rax, r14 ;se cambia el valor  
;	cmp 	al,'*'
;	je 		multi
;	cmp 	al,'/'
;	je 		divide
;	cmp 	bl,'+' 
;	je 		suma
;	cmp 	al,'-'
;	je		resta
	
suma:
;	add rax,r10;voy a guardar en rax el resultado de la operacion 
	;xchg rax,r14
	mov rbx,0
	mov r14,rax ;voy a copiar resultado de rax para

	mul r10
;	jmp fin 
;	jmp trans
 

trans:
	pop 	r14
	pop 	rbx
	pop 	r10
	pop 	rcx 

	push rax 
	push rcx
	push rdx 
	push rsi 

	mov rcx, 5	; mueve la cantidad de digitos del numero 
	xor rdx,rdx 
	;call ITOA

Int2Char:
	xor r12,r12 		
	mov r12,10 ;voy a divir entre 10
	xor r11,r11
	mov r11,-1;indice
	xor r8,r8
	mov r8, -1;contador 

	.digito:

		div r12
		add rdx,'0'
		push rdx
		.prox:
			xor rdx,rdx
			inc r11
			cmp rax,0
	jne .digito
	
	.imp:
		.l:
		inc r8
  		pop rdx	
  		mov [resul+r8],dl
		cmp r8,r11
		jne .l
;ITOA:
;	mov r12, 10							;va a divir rax entre 10	
	;Mientras el rcx sea menor al largo del numero													;		seguira dividiendo y agregando al buffer numero. 
;	.loop:
;		idiv r12						; divide al rax (el numero), por 10 esto nos da el digito menos significativo
;		add rdx, 48				; convierta al residuo de la division en un numero
;		mov [resul + rcx], dl		; mueve el numero convertido a ascii al buffer en su posicion correspondiente.
;		xor rdx, rdx 				; limpia el rdx, donde quedan los residuos de las divisiones por 10
;		dec rcx						; decrementa al rcx, para seguir con el siquiente operando
;		cmp rcx, 0					; compara el rcx con el tamaño del numero, si es menor a 0 sale del cilo
;		jl ITOA.print
;		jmp ITOA.loop				; si no es menor a cero, vuelve al loop 
;	
	.print:
		mov rax,1					; Sys_write
		mov rdi,1 					; stdout
		mov rsi, resul				; resultado del ITOA
		mov rdx, 1024				; el largo del resultado del ITOA
		syscall
;		;mov num,resul
		jmp fin 



popstack:
	push r9 ;es un contador temporal
	push r8 
	push r15
	xor r9,r9
	mov r8,-1

ciclopop:
	;num va a tener a segundo operando
	inc r8 ;se va a utilizar para recorrer stack 
	mov al, byte[stack+r8] ;
	cmp al,' ' ;si es un espacio 
	je sumoenpop
	jmp ciclopop

sumoenpop:
	;jmp fin 
	inc r9 ;numero para ver cuantos espacios hay
	cmp r9,r13 ;r13 tiene 
	je creoOp1
	inc r8
	jmp ciclopop

creoOp1:
	mov r9,r8 ;copio posicion para usarla luego para borrar
	mov r15,0

cicloOp1:
	mov al,byte[stack+r8+1] ;sino, se va a pasar el actual
	cmp al,'0' ; se compara para ver si es vacio
	jb limpioStack;si es igual se va a limpiar lo ultimo 

	mov byte[op1+r15],al 
	inc r15 ;sumo para mover 
	inc r8	;sumo para mover 
	jmp cicloOp1

limpioStack:
	cmp byte[stack+r9],0 ; se compara para ver si es vacio y se termino la limpieza
	je preOpero ;
	mov byte[stack+r9],0 ;sino muevo al byte acutal un 0
	inc r9
	jmp limpioStack
	;si es igual salte a operar 

preOpero:
	pop r15
	pop r8
	pop r9
	dec r13 ;para senalar que se quito un numero 
	jmp conseguiNum1



pushnum: ;funcion para meter a pila numero actual 
	inc 	r10;	
	mov 	r12,0

pushstack:
	inc r13 				;contador para saber cuantos numeros estan en pila
	mov byte[stack+r8],' '	; se va a meter un espacio antes de cada numero para saber donde termina 
	inc r8 					;si estoy metiendo espacio tengo que correrlo un espacio
	push r9 				;va a ser contador temporal 
	push rax  				;se mete contenido de rax 
	mov r9,0				;le muevo 0 para empezar a comparar con r11

ciclopush:
	mov al, byte[num+r9] 	;muevo a al el byte actual 
	cmp r11,r9				;comparo si el contador r9 es igual al final del numero que esta en r11
	je finciclo 			;si es igual termino el ciclo 
	mov byte[stack+r8],al 	;se va a mover a stack 
	inc r8 
	inc r9 
	jmp ciclopush

finciclo:
	mov 	r11,0	
	pop 	rax
	pop 	r9

	;cuando termino el ciclo hago salto a lo que sigue

;cuando meto numero se esta imprimiendo 
printeo:
	push 	rax
	push 	rdi 
	push 	rsi
	push 	rdx

	;mov 	rax, 1													
	;mov 	rdi, 1 													
	;mov rsi, num
	;mov 	rsi,cambio 
	;mov 	rdx, 1024												
	;syscall
	;jmp fin
	pop 	rdx 
	pop 	rsi 
	pop 	rdi 
	pop 	rax 
	cmp 	r10 , lenPos
	je 		fin
	;jmp limpionum

limpionum:
	mov 	byte[num+r12],0h ;
	inc 	r12
	cmp 	r12,1024;
	jne 	limpionum
	jmp 	eval 


fin:
	mov		rax,60
	mov		rdi,-1
	syscall