#include "../ejs.h"
#include <string.h>

void nuevaPublicacion(tuit_t* tuit, feed_t* feed){
  publicacion_t* nuevaPublicacion = (publicacion_t*)malloc(sizeof(publicacion_t));  //  Pido el espacio para la nueva publicación

  nuevaPublicacion->value = tuit;           //  El valor de la nueva publicación es el tuit pasado por parámetro
  nuevaPublicacion->next = feed->first;     //  La siguiente publicación de la reciés creada es la primera del feed

  feed->first = nuevaPublicacion;           //  Reemplazo la primera publicación del feed con la recién creada
}

// Función principal: publicar un tuit
tuit_t *publicar(char *mensaje, usuario_t *user) {
  tuit_t* nuevoTuit = (tuit_t*)malloc(sizeof(tuit_t));      //  tuit_t* que será la respuesta

  strcpy(nuevoTuit->mensaje, mensaje);          //  Copio el mensaje pasado por parámetro en el tuit recién creado
  nuevoTuit->favoritos = 0;                     //  Seteo los valores de favoritos y retuits en 0s
  nuevoTuit->retuits = 0;
  nuevoTuit->id_autor = user->id;               //  El usuario pasado por parámetro es el autor del tuit

  nuevaPublicacion(nuevoTuit, user->feed);      //  Corrijo el feed del autor

  uint32_t cantSeguidores = user->cantSeguidores;

  for (uint32_t i = 0; i < cantSeguidores; i++){    //  Corrijo el feed de todos los seguidores del autor
    usuario_t* seguidor = user->seguidores[i];
    nuevaPublicacion(nuevoTuit, seguidor->feed);
  }
  

  return nuevoTuit;
}
