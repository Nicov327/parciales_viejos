#pragma once
#include <stdbool.h>
#include <stdint.h>

/**
 * Un ítem en nuestro videojuego.
 *
 * Campos:
 *   - nombre:      El nombre el ítem.
 *   - fuerza:      La cantidad de fuerza que provee usarlo.
 *   - durabilidad: El nivel de desgaste del ítem. Los ítems se rompen cuando
 *                  la durabilidad llega a 0.
 */
typedef struct {
	char nombre[18]; 		//asmdef_offset:ITEM_NOMBRE
	uint32_t fuerza;		//asmdef_offset:ITEM_FUERZA
	uint16_t durabilidad;	//asmdef_offset:ITEM_DURABILIDAD
} item_t; //asmdef_size:ITEM_SIZE

/*	El siguiente bloque de texto lo escribí yo, no vino por defecto en el parcial
[0-63]  	: [N O M B R E]
[64-127]	: [N O M B R E]
[128-191]	: [NOMBRE][Padding 2Bytes][FUERZA]
[192-255]	: [DURABILIDAD][Padding 6Bytes]

*/

/**
 * El tipo de las funciones que se utilizan para comparar ítems.
 *
 * Devolver `true` significa los parámetros están en el orden correcto.
 */
typedef bool (*comparador_t)(item_t*, item_t*);

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
extern bool EJERCICIO_1A_HECHO;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - indice_a_inventario
 */
extern bool EJERCICIO_1B_HECHO;

/**
 * OPCIONAL: implementar en C
 */
bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

/**
 * OPCIONAL: implementar en C
 */
item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);
