extern malloc
global strArrayNew                 ;   DESCOMENTAR PARA IMPLEMENTAR LA SOLUCIÓN EN ASM
;global strArrayGetSize
;global strArrayAddLast
;global strArraySwap
;global strArrayDelete

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
    mov r12b, r12b          ; r12 (r12b) contiene a capacity

.creoElPunteroDelStruct:
    mov rdi, 16
    call malloc
    mov r13, rax            ; Recibí el puntero del malloc, lo guardo en r13

.creoElPunteroDeData:
    xor rax, rax
    mov al, 8
    mul rdi                 ; Dado que un puntero mide 64 bits y el valor que debe ser entregado al malloc es en bytes, multiplico los que necesito (capacity) por 8
    call malloc
    mov r14, rax

.creoElPropioStruct:
    xor r8, r8
    mov rdi, r13
    mov [rdi], r8           ; Cargo el size, que inicialmente es 0

    inc rdi                 ; Me muevo un byte para poder escribir la capacidad
    mov [rdi], r12b

    inc rdi
    mov [rdi], r14

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

    mov al, [rdi]

.fin:
    pop rbp
    ret

; void  strArrayAddLast(str_array_t* a, char* data)     a -> rdi  data -> rsi
;strArrayAddLast:


; void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j)
;strArraySwap:


; void  strArrayDelete(str_array_t* a)
;strArrayDelete:


