extern malloc
extern free
extern strClone
extern strLen
global strArrayNew                 ;   DESCOMENTAR PARA IMPLEMENTAR LA SOLUCIÓN EN ASM
global strArrayGetSize
global strArrayAddLast
;global strArraySwap
;global strArrayDelete

; Algunos offsets:
strArray_SIZE EQU 0
strArray_CAPACITY EQU 1
strArray_DATA EQU 8

ARRAY_OFFSET_SIZE EQU 0
ARRAY_OFFSET_CAPACITY EQU 1
ARRAY_OFFSET_DATA EQU 8


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

; uint8_t  strArrayGetSize(str_array_t* a)        ; a -> rdi
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
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8

    mov r12, rdi                        ;   Muevo a r12 el puntero del struct ('a')
    mov r13, rsi                        ;   Muevo a r13 el puntero del string a copiar ('data')

    xor r8, r8
    xor r9, r9
    mov r8b, BYTE [r12 + strArray_SIZE]
    mov r9b, BYTE [r12 + strArray_CAPACITY]
    cmp r9b, r8b
    jle .fin                            ;   Si capacity <= size entonces no tengo nada por hacer y me voy a .fin


    mov rdi, r13                        ;   Muevo el puntero de 'data' al rsi para darselo al strClone
    call strClone
    mov r14, rax

    xor r9, r9
    mov r9b, BYTE [r12 + strArray_SIZE] ;   Cargo el size en byte bajo de r9
    xor rax, rax
    mov al, 8
    mul r9b                             ;   rax = 8. Multiplico por el size para obtener el offset que necesito hacer en a->data

    mov r8, [r12 + strArray_DATA]
    add r8, rax
    mov [r8], r14

    inc BYTE [r12 + strArray_SIZE]

.fin:
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j)
;strArraySwap:


; void  strArrayDelete(str_array_t* a)
;strArrayDelete:


