#include "../ejs.h"

uint32_t cantidad_de_tuits_sobresalientes(usuario_t *user, uint8_t (*esTuitSobresaliente)(tuit_t *)){
    uint32_t id_user = user->id;
    publicacion_t* publicacionActual = user->feed->first;
    uint32_t res = 0;

    while(publicacionActual != NULL){
        tuit_t* tuitActual = publicacionActual->value;

        if(tuitActual->id_autor == id_user){
            if(esTuitSobresaliente(tuitActual)){
                res++;
            }
        }

        publicacionActual = publicacionActual->next;
    }

    return res;
}

tuit_t **trendingTopic(usuario_t *user, uint8_t (*esTuitSobresaliente)(tuit_t *)) {
    uint32_t memoAPedir = cantidad_de_tuits_sobresalientes(user, esTuitSobresaliente);
    if(memoAPedir == 0){
        return NULL;
    }

    //  Incremento el memo en 1 porque el último valor del array tiene que ser nulo
    tuit_t** tuitsSobresalientes = (tuit_t**)malloc(sizeof(tuit_t*) * (memoAPedir + 1));
    tuitsSobresalientes[memoAPedir] = NULL;     //  Seteo el último valor en nulo

    uint32_t id_user = user->id;
    publicacion_t* publicacionActual = user->feed->first;

    uint32_t c = 0;
    while (publicacionActual != NULL){
        tuit_t* tuitActual = publicacionActual->value;

        if(tuitActual->id_autor == id_user){
            if(esTuitSobresaliente(tuitActual)){
                tuitsSobresalientes[c] = tuitActual;
                c++;
            }
        }

        publicacionActual = publicacionActual->next;
    }

    return tuitsSobresalientes;
}
