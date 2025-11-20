extern malloc

extern strcpy

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text


; Completar las definiciones (serán revisadas por ABI enforcer):
TUIT_MENSAJE_OFFSET EQU 0
TUIT_FAVORITOS_OFFSET EQU 140
TUIT_RETUITS_OFFSET EQU 142
TUIT_ID_AUTOR_OFFSET EQU 144
TUIT_SIZE EQU 148

PUBLICACION_NEXT_OFFSET EQU 0
PUBLICACION_VALUE_OFFSET EQU 8
PUBLICACION_SIZE EQU 16

FEED_FIRST_OFFSET EQU 0 
FEED_SIZE EQU 8

USUARIO_FEED_OFFSET EQU 0;
USUARIO_SEGUIDORES_OFFSET EQU 8; 
USUARIO_CANT_SEGUIDORES_OFFSET EQU 16; 
USUARIO_SEGUIDOS_OFFSET EQU 24; 
USUARIO_CANT_SEGUIDOS_OFFSET EQU 32; 
USUARIO_BLOQUEADOS_OFFSET EQU 40; 
USUARIO_CANT_BLOQUEADOS_OFFSET EQU 48; 
USUARIO_ID_OFFSET EQU 52; 
USUARIO_SIZE EQU 56

; tuit_t *publicar(char *mensaje, usuario_t *usuario);
; *mensaje -> rdi   *usuario -> rsi
global publicar
publicar:
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14
    push r15

    mov r12, rdi    ;   r12 = *mensaje
    mov r13, rsi    ;   r13 = *usuario

    ;;  Acá comienza la creación del tuit
    mov rdi, TUIT_SIZE  ;   Genero el espacio para el tuit
    call malloc
    mov r14, rax        ;   r14 = *tuit

    mov rdi, r14
    add rdi, TUIT_MENSAJE_OFFSET
    ;mov rdi, [r14 + TUIT_MENSAJE_OFFSET]
    mov rsi, r12
    call strcpy         ;   Copio el mensaje en el tuit recién creado

    mov word [r14 + TUIT_FAVORITOS_OFFSET], 0   ;   Seteo retuits y favs en 0
    mov word [r14 + TUIT_RETUITS_OFFSET], 0

    mov r8d, [r13 + USUARIO_ID_OFFSET]  ;   r8d = user->id
    mov dword [r14 + TUIT_ID_AUTOR_OFFSET], r8d

    ;;   Hasta acá llega la creación del tuit. Todo lo de arriba pareciera funcionar correctamente
    ;;   A partir de acá arranca la creación de una nueva publicación para el autor

    mov rdi, PUBLICACION_SIZE           ;   Pido memoria para la publicación del autor
    call malloc
    
    mov [rax + PUBLICACION_VALUE_OFFSET], r14   ;   nuevaPublicación->value = tuit
    
    ;   Hasta acá, a la nueva publicación le pude asociar el tuit

    mov r8, r13                                 ;   r8 = *user
    add r8, USUARIO_FEED_OFFSET                 ;   r8 = *user (USUARIO_FEED_OFFSET = 0)

    mov r8, [r8]                                ;   Cargo en r8 aquello a lo que apunte r8 (*feed)

    mov r9, [r8]                                ;   Ahora r9 tiene el puntero *first

    ;mov r9, [r8 + FEED_FIRST_OFFSET]            
    ;mov r9, [r9]                               ;   Accedo a feed (r9 ahora contiene el puntero *first)

    mov [rax + PUBLICACION_NEXT_OFFSET], r9     ;   nuevaPublicación->next = feed->first

    mov [r8], rax                               ;   A donde apunte r8 (*feed) le pongo el valor del rax (nuevaPublicación)

    ;;  Hasta acá es la nueva publicación para el autor

.for


.fin:
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp
    ret
