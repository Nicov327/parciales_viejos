extern strcmp
global invocar_habilidad

; Completar las definiciones o borrarlas (en este ejercicio NO serán revisadas por el ABI enforcer)
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32
CARD_DIR_OFFSET EQU 0
CARD_DIRENTRIES_OFFSET EQU 8
CARD_ARCHETYPE_OFFSET EQU 16
CARD_SIZE EQU 24
section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text

; void invocar_habilidad(void* carta, char* habilidad);
invocar_habilidad:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = void*    card ; Vale asumir que card siempre es al menos un card_t*	RDI
	; r/m64 = char*    habilidad													RSI

	push rbp
	mov rbp, rsp

	push r12		;	Para guardar card
	push r13		;	Para guardar habilidad
	push r14		;	Es la flag "encontrada" de mi código C. Se inicializa en False (0)
	push rbx		;	Equivalente a la variable 'i' de mi código C

	mov r12, rdi
	mov r13, rsi
	xor r14, r14
	xor rbx, rbx
	dec rbx

.for:
	inc rbx
	cmp WORD [r12 + CARD_DIRENTRIES_OFFSET], bx
	je .ultimoIf						;	Si ya recorrí todos los entries del _dir, miro el último if

.primerIf:
	mov rdi, [r12 + CARD_DIR_OFFSET]	;	Cargo en rdi el _dir la carta del parámetro
	mov rax, 8
	mul rbx
	add rdi, rax						;	Me muevo al entry correspondiente del _dir
	mov rdi, [rdi]
	
	mov rsi, r13						;	Cargo en rsi el puntero de la habilidad pasada por parámetro

	call strcmp							;	Me fijo si la guarda se cumple

	cmp rax, 0
	jne .for							;	Si el strcmp me dice que los nombres son distintos, paso al siguiente estado del for

	mov rsi, [r12 + CARD_DIR_OFFSET]	;	Cargo en rsi el mismo dir_entry_t
	mov rax, 8
	mul rbx
	add rsi, rax
	mov rsi, [rsi]

	mov rdi, r12			;	Cargo en rdi el puntero a la carta para pasarla como parámetro (Como linea 13 en el C)

	call [rsi + 16]
	mov r14, 1				;	Seteo la flag 'encontrada' como TRUE

	jmp .fin

.ultimoIf:
	cmp r14, 1	;	Si 'encontrada' == true salgo del programa
	je .fin

	mov r8, [r12 + CARD_ARCHETYPE_OFFSET]	;	Si la carta no tiene arquetipo, salgo
	cmp r8, 0
	je .fin

	mov rdi, [r12 + CARD_ARCHETYPE_OFFSET]	;	Cargo como parámetro el arquetipo
	mov rsi, r13							;	Cargo como parámetro la habilidad que se busca
	call invocar_habilidad

.fin:
	pop rbx
	pop r14
	pop r13
	pop r12

	pop rbp
	ret ;No te olvides el ret!
