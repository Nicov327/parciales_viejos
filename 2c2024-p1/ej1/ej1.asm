extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0			;	El nombre es el primer atributo del struct
ITEM_FUERZA EQU 20			;	Fuerza arranca en el 20 porque tengo 2B de padding después de los 18 del nombre
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 32
SIZE_OF_ITEM_PTR EQU 8
;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado
es_indice_ordenado:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = item_t**     inventario		RDI
	; r/m64 = uint16_t*    indice			RSI
	; r/m16 = uint16_t     tamanio			DX
	; r/m64 = comparador_t comparador		RCX
	push rbp
	mov rbp, rsp

	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8

	mov r12, rdi			;	Cargo en r12 el inventario
	mov r13, rsi			;	Cargo en r13 el indice
	movzx r14, dx			;	Cargo en r14w el tamanio (zero extended)
	mov r15, rcx			;	Cargo en r15 el puntero de la función comparador

	xor rax, rax
	inc rax					;	La respuesta por defecto es TRUE

	xor rbx, rbx			;	rbx -> i = 0
	dec r14					;	r14 = tamanio-1

.for:
	cmp r14, rbx
	je .fin

	mov rdi, r13			;	Cargo en los registros a ser pasados como parámetros a comparador, el puntero de indice
	mov rsi, r13

	xor r8, r8
	mov r8, rbx				;	Dado que cada elemento del array mide 2B, uso i para elegir el elemento y luego shifteo para agarrarlo correctamente
	shl r8, 1

	add rdi, r8				;	Agrego este offset al puntero de índice (i)

	xor rdx, rdx
	mov dx, WORD [rdi]		;	En dx, cargo indice[i]

	mov rdi, [r12 + rdx * 8];	En rdi, cargo inventario[indice[i]]

	inc rbx
	xor r8, r8
	mov r8, rbx
	shl r8, 1

	add rsi, r8				;	Agrego este offset al puntero de índice (i+1)

	xor rdx, rdx
	mov dx, WORD [rsi]		;	En si cargo indice[i+1]

	mov rsi, [r12 + rdx * 8];	En rsi, cargo inventario[indice[i+1]]

	call r15				;	Llamo a comparador
	cmp rax, 0				;	Si me devolvió FALSE, me voy a .fin
	je .fin					

	jmp .for				;	Caso contrario, sigo ejecutando

.fin:
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

;; Dado un inventario y una vista, crear un nuevo inventario que mantenga el
;; orden descrito por la misma.

;; La memoria a solicitar para el nuevo inventario debe poder ser liberada
;; utilizando `free(ptr)`.

;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

;; Donde:
;; - `inventario` un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice` es el arreglo de índices en el inventario que representa la vista
;;   que vamos a usar para reorganizar el inventario.
;; - `tamanio` es el tamaño del inventario.
;; 
;; Tenga en consideración:
;; - Tanto los elementos de `inventario` como los del resultado son punteros a
;;   `ítems`. Se pide *copiar* estos punteros, **no se deben crear ni clonar
;;   ítems**

global indice_a_inventario
indice_a_inventario:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = item_t**  inventario		;	RDI
	; r/m64 = uint16_t* indice			;	RSI
	; r/m16 = uint16_t  tamanio			;	RDX
	push rbp
	mov rbp, rsp

	push r12
	push r13
	push r14
	push rbx

	mov r12, rdi		;	Cargo inventario en r12
	mov r13, rsi		;	Cargo indice en r13
	movzx r14, dx		;	Cargo tamanio en r14

	mov rdi, 8
	movzx rax, dx
	mul rdi				;	Calculo en rax la cantidad de bytes que tengo que pedir al malloc
	mov rdi, rax
	call malloc			;	En el rax me queda el puntero a ser devuelto

	xor rbx, rbx		;	rbx -> i = 0
	mov r10, r12		;	Cargo en r10 el puntero del inventario original
	mov r11, rax		;	Cargo en r11 el puntero del nuevo inventario

.for:
	cmp r14, rbx
	je .fin

	xor r8, r8
	mov r8w, [r13 + rbx * 2]	;	Cargo en r8w indice[i] (Ya es el número)
	
	mov rax, 8
	mul r8w
	mov r11, [r10 + rax]

	add r11, 8
	inc rbx

	jmp .for

.fin:
	pop rbx
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
