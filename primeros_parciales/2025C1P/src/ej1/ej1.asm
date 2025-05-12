extern malloc
extern sleep
extern wakeup
extern create_dir_entry

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio
sleep_name: DB "sleep", 0
wakeup_name: DB "wakeup", 0

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - init_fantastruco_dir
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - summon_fantastruco
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32

; void init_fantastruco_dir(fantastruco_t* card);
global init_fantastruco_dir
init_fantastruco_dir:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = fantastruco_t*     card -> rdi

	push rbp
	mov rbp, rsp

	push r12		;	Registro para tener card
	push r13		;	Registro para el directory_t*


	mov r12, rdi	;	En rdi cargo card 

	mov rdi, 16		;	Voy a pedirle 16 bytes a malloc para el directory_t* (Pues solo tendrá 2 habilidades)
	call malloc
	mov r13, rax	;	Me guardo el puntero equivalente a 'habilidades' en mi C

	mov rdi, sleep_name
	mov rsi, sleep

	call create_dir_entry

	mov [r13], rax

	mov rdi, wakeup_name
	mov rsi, wakeup

	call create_dir_entry

	mov [r13 + 8], rax

	mov [r12], r13
	mov [r12 + 8], WORD 2

.fin:
	pop r13
	pop r12

	pop rbp
	ret ;No te olvides el ret!

; fantastruco_t* summon_fantastruco();
global summon_fantastruco
summon_fantastruco:
	push rbp
	mov rbp, rsp

	push r12
	push r13

	mov rdi, 32
	call malloc
	mov r12, rax			;	Ahora en r12 tengo el puntero del fantastruco_t

	xor r8, r8
	mov [r12 + FANTASTRUCO_ARCHETYPE_OFFSET], r8		;	Seteo el __archetype como null (r8 = 0)
	
	inc r8
	mov [r12 + FANTASTRUCO_FACEUP_OFFSET], r8			;	Seteo el faceup como 1 (r8 = 1)

	mov rdi, r12
	call init_fantastruco_dir							;	Paso la carta como parámetro y seteo los otros dos atributos

	mov rax, r12

.fin:
	pop r13
	pop r12

	pop rbp
	ret ;No te olvides el ret!
