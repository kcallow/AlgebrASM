ection .bss
           
            textIn:         resb 1024
            lenTextIn:      equ $ - textIn
     
    section .data
     
            msgErrRead:     db "Info!. No se ingresaron datos.",0x0A
            lenMsgErrRead:  equ $ - msgErrRead
     
            msgFail:        db "Error. Paréntesis mal empleados",0x0A
            lenMsgFail:     equ $ - msgFail
     
            msgOk:          db "Validación aprobada.",0x0A
            lenMsgOk:       equ $ - msgOk
     
    section .text
     
            global _start
            _start
     
    main:
            call read
            call validar2829
            jmp main
            call exit
     
    validar2829:
            xor r9, r9              ;contador
            xor r10, r10            ;resultados de validación  
     
            .validar:
     
            cmp byte [textIn + r9], '('
            je .case1        
           
            cmp byte [textIn + r9], ')'
            je .case2
     
            cmp r8, r9
            je .case3
            jne .continue
           
            .case1:
                    cmp byte [textIn+ r9 + 1 ], ')'
                    je printErrValidacion
                    inc r10
                    jmp .continue
            .case2:
                    dec r10
                    cmp r10, -1
                    je printErrValidacion
                    jmp .continue
            .case3:
                    cmp r10, 0
                    je printMsgOk
                    jne printErrValidacion
            .continue
                    inc r9
                    jmp .validar
     
    read:
            mov rax, 0              ;sys_read
            mov rdi, 1              ;std_in
            mov rsi, textIn
            mov rdx, lenTextIn
            syscall
            ;comprobar lectura. Sale si ctel + d
                    cmp rax, 0
                    je exit
            dec rax                 ;!!!! enter
            mov r8, rax             ;guardar len
            ret
     
    printMsgOk:
            mov rsi, msgOk
            mov rdx, lenMsgOk
            call print
            ret
    printErrLectura:
            mov rsi, msgErrRead
            mov rdx, lenMsgErrRead
            call printError
    printErrValidacion:
            mov rsi, msgFail
            mov rdx, lenMsgFail
            call printError
    printError:
            mov rax, 1              ;sys_write
            mov rdi, 2              ;std_err
            syscall
            ;ret
            call exit
    print:
            mov rax, 1              ;sys_write
            mov rdi, 1              ;std_out
            syscall
            ret
    exit:
            xor rsi, rsi
            mov rsi, 0x0a
            mov rdx, 1
            call  print
            mov rax, 60             ;sys_exit
            mov rdi, 0              ; return 0, success
            syscall
    ;end exit


