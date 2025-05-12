#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej1.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - init_fantastruco_dir
 */
bool EJERCICIO_1A_HECHO = true;

// OPCIONAL: implementar en C
void init_fantastruco_dir(fantastruco_t* card) {
    void (*sleep_ptr) (void*);
    sleep_ptr = &sleep;
    void (*wakeup_ptr) (void*);
    wakeup_ptr = &wakeup;

    directory_entry_t* dormir = create_dir_entry("sleep", sleep_ptr);
    directory_entry_t* despertar = create_dir_entry("wakeup", wakeup_ptr);

    directory_t* habilidades = malloc(sizeof(directory_t*) * 2);
    habilidades[0] = dormir;
    habilidades[1] = despertar;

    card->__dir = habilidades;
    card->__dir_entries = 2;
}

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - summon_fantastruco
 */
bool EJERCICIO_1B_HECHO = true;

// OPCIONAL: implementar en C
fantastruco_t* summon_fantastruco() {
    fantastruco_t* carta = malloc(sizeof(fantastruco_t));
    carta->face_up = 1;
    carta->__archetype = NULL;
    init_fantastruco_dir(carta);

    return carta;
}
