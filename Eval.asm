section .bss

	num resb 1024

	prueba resb 1024

	op1 resb 1024

	op2 resb 1024

	resul resb 1024

	stack resb 1024

	cambio resb 1024



section .data

		;Postfix db '2 2 2 2-+*',10
		;Postfix db '1 10 3+*4+'
		Postfix db '100 10 10 1**/'
		lenPos equ $ -Postfix

		Input db '71+28',10
		lenInput equ $ -Input

		errorDiv db 'No se puede hacer division entre 0',10
		lenError equ $ - errorDiv
		
		cambioLinea db '',10
		lenCambioLinea equ $-cambioLinea

section .text

	global _start

_start:

inicio:
	mov 	r11,0 ;contador para meter a num
	mov 	r10,0 ;contador para recorrer expresion
	mov 	cl,'0' ; se va a meter un '0' porque se va a comparat cl y al
	mov 	r15,-1 ;coontador para crear expresion concatenada
	mov 	r8,0	;contador de cuantos caracteres hay en pila 
	mov 	r13,0	;contador para ver cuantos numeros hay EN PILA


eval: 
	mov 	al, byte[Postfix+r10]; moviendo lo que hay en
	cmp 	al,'0'				;30h, viendo si es un operando u operador
	jb 		operador 			; si es menor es un operador, de lo contratario

;=======================creacion de primer numero para concatenar===================
comparoCl:
	cmp cl,'0'					;comparo el anterior con un signo,si es signo se va a hacer
	jae concat 				;push del numero 
siesmenor:
	jmp pushnum


concat:
	mov 	byte[num+r11],al	;si no es operador, es operando
	inc 	r11					; se incrementa el contador del numero en construccion
	inc 	r10					; se incrementa contador de la cadena principal 
	mov 	cl, al				; se va a copiar valor en cl para hacer comparaciones
	cmp 	r10,lenPos 			; si es igual termine, pero igual nunca va a terminar aca porque siempre de ultimo esta un operador 
	jne 	eval  				;si no es igual salte
	jmp 	fin
;++++++++++++++++++++++fin creacion de primer numero para concatenar++++++++++++++++

;=====================operadores 
operador:
	cmp 	al,' '  ;si es un espacio se va a hacer un push al 'stack'
	je 		pushnum

;sino se va a operar expresion, ya que es un signo 
operar:

	push 	rdi 
	push 	rsi
	push 	rdx
	push 	rax ;en este rax tengo el signo
	mov byte[prueba+0],al  ;estoy guardando el signo en prueba 

	jmp popstack ;estoy sacando el ultimo numero de la pila (t)

conseguiNum1: ;vuelvo con el top del stack , que se guarda en op1  

	pop 	rax  ;saco el signo 
	push 	rax 
	jmp preCreoExpresion1

operoexpresion:

	mov 	al,byte[prueba+0] ;pasando el signo 
	pop 	rax
	pop 	rdx 
	pop 	rsi 
	pop 	rdi 


;=============================================atoi==========================================

.atoi:
		push r10 ;en r10 tengo numero de concatenacion ,por lo que lo voy a guardar
		push r11
		push r13

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
	mov bl, byte[prueba+0]
;+++++++++++++++++++++++++++++++++++++++finstack++++++++++++++++++++++++++++++++++++++

;====================================== operaciones ===============================

	cmp 	bl,'*'
  	je 		multi
	cmp 	bl,'/'
	je 		divide
	cmp 	bl,'+' 
	je 		suma
	cmp 	bl,'-'
	je		resta


suma:
	add rax,r10;voy a guardar en rax el resultado de la operacion 
	jmp trans

resta:

	
	cmp r10,rax
	ja hagoNegacion
	sub rax,r10;voy a guardar en rax el resultado de la operacion 
	jmp trans
hagoNegacion:
	sub rax,r10;voy a guardar en rax el resultado de la operacion 
	neg rax 
	jmp trans
multi:
	mul r10		;voy a guardar en rax el resultado de la operacion 

	jmp trans 
divide:

	xor rdx,rdx
	cmp r10,0
	je errorDivZero
	idiv r10;voy a guardar en rax el resultado de la operacion 

	


trans:

	pop r13
	pop r11
	pop r10 ;recupero el contaador para recorrer toda la expresion  

	mov r12,0




limpionumre: 
	mov 	byte[num+r12],0h ;
	inc 	r12
	cmp 	r12,1024;
	jne 	limpionumre

mov r12,0
limpionumop1: 
	mov 	byte[op1+r12],0h ;
	inc 	r12
	cmp 	r12,1024;
	jne 	limpionumop1

;=============================================itoa==========================================

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
  		mov [num+r8],dl
		cmp r8,r11
		jne .l

	.print:
	mov cl,bl					;estoy moviendo signo anterior
	inc r10
	push 	rax
	push 	rdi 
	push 	rsi
	push 	rdx

	mov 	rax, 1													
	mov 	rdi, 1 											
	mov 	rsi,cambio
	mov 	rdx, 1024												
	syscall

	mov 	rax, 1													
	mov 	rdi, 1 													
	mov 	rsi,cambioLinea
	mov 	rdx, lenCambioLinea										
	syscall

	mov byte[prueba+0],cl
	mov 	rax, 1													
	mov 	rdi, 1 											
	mov 	rsi,num
	mov 	rdx, 1024												
	syscall

	mov 	rax, 1													
	mov 	rdi, 1 													
	mov 	rsi,cambioLinea
	mov 	rdx, lenCambioLinea										
	syscall
	pop 	rdx 
	pop 	rsi 
	pop 	rdi 
	pop 	rax 



mov r12,0
limpioCambio:
	mov 	byte[cambio+r12],0h ;
	inc 	r12
	cmp 	r12,1024;
	jne 	limpioCambio

	mov cl,byte[Postfix+r10-1]
	cmp byte[Postfix + r10],0
	je fin 
	jmp eval
;+++++++++++++++++++++++++++++++++++++++finitoa++++++++++++++++++++++++++++++++++++++


;==============codigo para crear cadena que se va a cambiar en original==========

preCreoExpresion1:
	push 	r8
	push 	r15 
	push 	rcx		

	mov 	r15,-1;limpio contador 
	xor 	r8,r8 ;limpio contador para recorrer expresion destino


creoExpresion1:
	inc 	r15 				;se va a recorrer 15 para concatenar a buffer
	cmp 	byte [op1+r15],0	; si es vacio
	je 		preCreoExpresion2 	;se va a crear numero 2 para concatenar
	mov 	cl,byte [op1+r15]	;
	mov 	byte [cambio+r8],cl
	inc 	r8 					;r8 va a recorrer expresion donde se va a guardar
	jmp 	creoExpresion1 

preCreoExpresion2:
	mov 	r15,-1 				;limpio contador 
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

preCambio;se va a empezar funcion para concatenar los 2 numeros para 
	pop 	rcx
	pop 	r15 
	pop 	r8 
	jmp 	operoexpresion
;+++++++++++++++++++++++++++++++fin de constructor de cadena de cambio++++++++++++++++++++++++++++++++++++++


;===============================pop del stack=======================================
popstack:
	push r9 			;es un contador temporal
	push r8  
	push r15
	xor r9,r9
	mov r8,-1

;		jmp fin

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
	inc r8 ;incremento r8 para que se salte el espacip

cicloOp1:
	mov al,byte[stack+r8] ;sino, se va a pasar el actual;;;;;;;;;;;;;;;;;
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

	jmp conseguiNum1 ;despues de conseguir numero vuelvo a donde quede con un jmp con el numero
	;el numero quedo guardado en op1 

;+++++++++++++++++++++++++++++++++++++++fin pop de stack++++++++++++++++++++++++++++++++++++++


;=============================================comienzo PUSH STACK==========================================
pushnum: ;funcion para meter a pila numero actual 
	mov 	r12,0
;	cmp cl,'0'
;	jb fin 
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
	pop 	rax				;para recuperar 
	pop 	r9

;+++++++++++++++++++++++++++++++++++++++fin push stack++++++++++++++++++++++++++++++++++++++


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

limpionum: ;funcion para limpiar buffer
	mov 	byte[num+r12],0h ;
	inc 	r12
	cmp 	r12,1024;
	jne 	limpionum
	jmp 	preeval 

preeval:
	cmp cl,'0'; si es menor va a ser un signo 
	jb creoNuevoCL;si es menor voy a crear nuevo cl ,ya que si anterior es numero concatena


pEval: ;si no es signo, va a ser un numero, por lo que se sigue analizando 
	inc 	r10				;incremento r10 que es el contador siga su rumbo	
	jmp 	eval 			;salto

creoNuevoCL 
	mov cl,'1'; se va a saltar de nuevo a eval pero con cl numero, para que se cree nuevo
	jmp eval 	;numero 

errorDivZero:
	mov 	rax, 1													
	mov 	rdi, 1 													
	mov rsi, errorDiv
	mov 	rdx, lenError
	syscall
	jmp fin 

fin:
	mov		rax,60
	mov		rdi,-1
	syscall
