global main
extern gets
extern printf
extern sscanf
extern fopen
extern fread
extern fclose

section .data
    ;------------------------ARCHIVO------------------------
    nombreArchivo    db   "archivo4.dat", 0                 ; Colocar el archivo que quiere oredenar
    modoDeApertura   db   "rb", 0
    msjErrorArchivo  db   10, "Error en apertura de %s", 10, 10, 0

    ;------------------------OUTPUTS------------------------
    mensajeOrden     db   10, "Ingrese forma de ordenar el vector, Ascendente(1) / Descendente(2): ", 0
    msjInputInvalido db   10, "Ingrese una opción válida, Ascendente(1) / Descendente(2)", 10, 10, 0
    vacio            db   '', 10, 0
    formatInput      db   "%hhi ", 0
    vecOriginal      db   10, "Vector original: ", 0
    pasosBubbleSort  db   10, "PASO %li: ", 0

    ;-------------------------VECTOR------------------------
    longVector     dq   0
    indice         dq   0

section .bss
    ;-------CHECK ALIGN-------
    plusRsp  resq  1

    ;---------ARCHIVO---------
    fileHandle  resq  1
    numero      resb  1

    ;----------INPUT----------
    buffer       resb  100
    tipoDeOrden  resq  1

    ;---------VECTOR----------
    vector  times 30 resb 1

    ;-------BUBBLESORT--------
    huboCambios  resb  1

section .text

main:
    abrirArchivo:
        mov     rdi, nombreArchivo
        mov     rsi, modoDeApertura
        call    fopen

        cmp     rax, 0
        jle     errorApertura

        mov     qword[fileHandle], rax

    call    leerArchivo
    call    determinarOrden
    call    bubbleSort

    finPrograma:
    ret

;********************************************************************************************************************************
;*                                                      ARCHIVO                                                                 *
;********************************************************************************************************************************
errorApertura:
    mov     rdi, msjErrorArchivo
    mov     rsi, nombreArchivo
    sub     rax, rax
    call    printf

    jmp     finPrograma

leerArchivo:
    mov     rdi, numero
    mov     rsi, 1  ;   1 = tamaño del número
    mov     rdx, 1
    mov     rcx, qword[fileHandle]
    call    fread

    cmp     rax, 0
    jle     eof

    call    inicializarVector

    jmp     leerArchivo

    fin_leerArchivo:
    ret

eof:
    mov     rdi, qword[fileHandle]
    call    fclose

    jmp     fin_leerArchivo

inicializarVector:
    mov     rbx, qword[indice]

    mov     rcx, 1
    lea     rsi, [numero]
    lea     rdi, [vector + rbx]
    rep     movsb

    inc     qword[indice]
    inc     qword[longVector]

    ret

;********************************************************************************************************************************
;*                                                      ELEGIR ORDEN                                                            *
;********************************************************************************************************************************
determinarOrden:
    call    imprimirVectorOriginal

    mov     rdi, mensajeOrden
    sub     rax, rax
    call    printf

    mov     rdi, buffer
    call    gets

    mov     rdi, buffer
    mov     rsi, formatInput
    mov     rdx, tipoDeOrden

    call    checkAlign
    sub     rsp, qword[plusRsp]
    call    sscanf
    add     rsp, qword[plusRsp]

    verificarSiEsInputInvalido:
        cmp     qword[tipoDeOrden], 1
        jl      inputInvalido
        cmp     qword[tipoDeOrden], 2
        jg      inputInvalido

    ret

inputInvalido:
    mov     rdi, msjInputInvalido
    sub     rax, rax
    call    printf

    jmp     determinarOrden

;********************************************************************************************************************************
;*                                                      ORDENAMIENTO                                                            *
;********************************************************************************************************************************
bubbleSort:

    mov     qword[indice], 0
    iteracion_bubbleSort:

        mov     byte[huboCambios], 'N'
        mov     rbx, 0
        iteracionAnidada_bubbleSort:
            call    verificarSwap

            ; RDI -> CONDICIÓN DE CORTE DE LA ITERACIÓN ANIDADA
            mov     rdi, qword[longVector]
            sub     rdi, qword[indice]
            dec     rdi

            inc     rbx
            cmp     rbx, rdi
            jl      iteracionAnidada_bubbleSort

        inc     qword[indice]
        call    imprimirPasosBubbleSort

        cmp     byte[huboCambios], 'S'  ; Si byte[huboCambios] es distinto de 'S' entonces el vector ya esta ordenado
        je      iteracion_bubbleSort

    ret

verificarSwap:
    mov     ch, byte[vector + rbx]       ; CH -> ELEMENTO ACTUAL
    mov     dh, byte[vector + rbx + 1]   ; DH -> ELEMENTO SIGUIENTE, 1 = tamaño del número
    cmp     byte[tipoDeOrden], 2
    je      ordenarDescendente

    ordenarAscendente:
        call    ordenAscendente
        jmp     fin_verificarSwap

    ordenarDescendente:
        call    ordenDescendente

    fin_verificarSwap:
    ret

ordenAscendente:
    cmp     ch, dh
    jl      fin_ordenAscendente
    call    swap

    mov     byte[huboCambios], 'S'

    fin_ordenAscendente:
    ret

ordenDescendente:
    cmp     ch, dh
    jg      fin_ordenDescendente
    call    swap

    mov     byte[huboCambios], 'S'

    fin_ordenDescendente:
    ret

swap:
    mov     byte[vector + rbx], dh
    mov     byte[vector + rbx + 1], ch  ; 1 = tamaño del número

    ret

;********************************************************************************************************************************
;*                                                      IMPRIMIR VECTOR                                                         *
;********************************************************************************************************************************
imprimirVectorOriginal:
    mov     rdi, vecOriginal
    sub     rax, rax
    call    printf
    call    imprimirVector

    ret

imprimirPasosBubbleSort:
    cmp     byte[huboCambios], 'N'
    je      fin_imprimirPasosBubbleSort

    mov     rdi, pasosBubbleSort
    mov     rsi, qword[indice]
    sub     rax, rax
    call    printf
    call    imprimirVector

    fin_imprimirPasosBubbleSort:
    ret

imprimirVector:
    mov     rbx, 0

    iteracion_ImprimirVector:
        mov     rdi, formatInput
        mov     sil, byte[vector + rbx]
        sub     rax, rax
        call    printf

        inc     rbx
        cmp     rbx, qword[longVector]
        jl      iteracion_ImprimirVector

    mov     rdi, vacio
    sub     rax, rax
    call    printf

    ret

;********************************************************************************************************************************
;*                                                          CHECK ALIGN                                                         *
;********************************************************************************************************************************
checkAlign:
	push    rax
	push    rbx
;	push    rcx
	push    rdx
	push    rdi

	mov     qword[plusRsp], 0
	mov		rdx, 0

	mov		rax, rsp		
	add     rax, 8		    ;para sumar lo q restó la CALL 
	add		rax, 32	        ;para sumar lo que restaron las PUSH
	
	mov		rbx, 16
	idiv	rbx			    ;rdx:rax / 16   resto queda en RDX

	cmp     rdx, 0		    ;Resto = 0?
    je		finCheckAlign
;   mov     rdi, msj
;   call    puts
	mov     qword[plusRsp], 8

finCheckAlign:
	pop     rdi
	pop     rdx
;	pop     rcx
	pop     rbx
	pop     rax
	ret
