#include "ej2.h"

#include <string.h>

// OPCIONAL: implementar en C
void invocar_habilidad(void* carta_generica, char* habilidad) {
	card_t* carta = carta_generica;
	bool encontrada = false;

	for (int i = 0; i < carta->__dir_entries; i++){
		if(strcmp(carta->__dir[i]->ability_name, habilidad) == 0){
			ability_function_t* ejecutoHabilidad = (carta->__dir[i]->ability_ptr);
			ejecutoHabilidad(carta);
			encontrada = true;
		}
	}

	if (!encontrada && carta->__archetype != NULL){
		invocar_habilidad(carta->__archetype, habilidad);
	}
}
