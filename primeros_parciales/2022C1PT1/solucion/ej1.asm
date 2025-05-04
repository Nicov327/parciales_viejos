extern malloc
extern free
extern strClone
extern strLen
global strArrayNew                 ;   DESCOMENTAR PARA IMPLEMENTAR LA SOLUCIÓN EN ASM
;global strArrayGetSize
;global strArrayAddLast
;global strArraySwap
;global strArrayDelete

; Algunos offsets:
strArray_SIZE EQU 0
strArray_CAPACITY EQU 1
strArray_DATA EQU 8



;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;str_array_t* strArrayNew(uint8_t capacity)         ; capacity -> dil
strArrayNew:
    push rbp
    push r12                ; Para guardar capacity
    push r13                ; Para guardar el puntero del struct
    push r14                ; Para guardar el puntero del array de punteros data
    mov rbp, rsp

    xor r12, r12
    mov r12b, dil          ; r12 (r12b) contiene a capacity

.creoElPunteroDelStruct:
    mov rdi, 16
    call malloc
    mov r13, rax            ; Recibí el puntero del malloc, lo guardo en r13

.creoElPunteroDeData:
    xor rax, rax
    mov al, 8
    mul r12                 ; Dado que un puntero mide 64 bits y el valor que debe ser entregado al malloc es en bytes, multiplico los que necesito (capacity) por 8
    mov rdi, rax
    call malloc
    mov r14, rax

.creoElPropioStruct:
    xor r8, r8
    mov rax, r13

    mov BYTE [rax + strArray_SIZE], r8b         ; Cargo el size, que inicialmente es 0

    mov BYTE [rax + strArray_CAPACITY], r12b    ; Me muevo un byte para poder escribir la capacidad
       
    mov [rax + strArray_DATA], r14              ; Me muevo 8 bytes (2 por size y capacity, 6 por el padding) para escribir el puntero data

.fin:
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; uint8_t  strArrayGetSize(str_array_t* a)        ; a -> dil
strArrayGetSize:
    push rbp
    mov rbp, rsp

    mov al, BYTE [rdi]      ;   Cargo nada más que el primer byte del struct, dado que ahí se encuentra el size

.fin:
    pop rbp
    ret

; void  strArrayAddLast(str_array_t* a, char* data)     a -> rdi  data -> rsi
strArrayAddLast:
    push rbp
    push r12
    push r13
    push r14
    push r15
    mov rbp, rsp
    ;sub rbp, 8      ;   Alineo la pila (hice una cantidad impar de pushes, por eso tengo que alinear nuevamente a 16 bytes)

    mov r12, rdi    ;   r12 contiene 'a'
    mov r13, rsi    ;   r13 contiene 'data'

    xor r8, r8
    mov r8w, WORD [r12]  ;   En la parte baja del r8, tengo tanto el size (0-7) como el capacity (8-15)
    xor r9, r9
    mov r9b, r8b    ;   Cargo el size en el byte de abajo de r9
    shr r8, 4       ;   Muevo 4 lugares a la derecha el r8 (Para que capacity quede en el byte de abajo)

    cmp r8b, r9b    ;   Seteo flags acorde a la operación r8 - r9
    jle .fin

.hayEspacio:
    mov rdi, rsi    ;   Necesito saber cuánto mide el string a ser copiado, por lo que muevo su puntero para ser dado al strLen
    call strLen
    mov rdi, rax    ;   Obtenida la longitud, pido esa cantidad de bytes por malloc
    mov r15, rax    ;   r15 contiene ahora la longitud del string a copiar
    call malloc
    mov r14, rax    ;   Me guardo en r14 el puntero para el nuevo string
    
    mov r9, r12     ;   Voy a usar r9 para buscar el puntero de 'data' del strArray
    add r9, 4       ;   Me muevo 4 bytes para encontrar el lugar del 'data' (1B por size, otro por capacity, y 2 por padding)
    mov r8, [r9]    ;   Cargo en r8 el puntero de 'data' del strArray

    xor r9, r9
    mov r9b, r12b   ;   Cargo el size en r9b para moverme la cantidad de lugares en la tabla que haga falta
    add r8, r9      ;   Se lo agrego

    mov [r8], r14   ;   EScribo en el array data del strArray la dirección del puntero al nuevo string

.clonoString:
    cmp r15, 0      ;   Si ya no quedan caracteres por copiar, me voy al fin
    je .fin

    mov r8b, [r12]  ;   Cargo en r8b el caracter del string a ser clonado
    mov [r14], r8b  ;   Lo guardo en el puntero que fue escrito en la tabla 'data'

    sub r15, 1      ;   Descuento un caracter a ser procesado
    inc r12         ;   Me muevo un byte tanto en ambos punteros
    inc r14

    jmp .clonoString

.fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp


; void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j)
;strArraySwap:


; void  strArrayDelete(str_array_t* a)
;strArrayDelete:


