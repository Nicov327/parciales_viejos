#include "ejs.h"
#include "str.h"

/*str_array_t* strArrayNew(uint8_t capacity){
    char** data = malloc(sizeof(char*) * capacity);

    str_array_t* res = malloc(16);

    res->size = 0;
    res->capacity = capacity;
    res->data = data;

    return res;
}*/

uint8_t  strArrayGetSize(str_array_t* a){
    return a->size;}

void  strArrayAddLast(str_array_t* a, char* data){
    if (a->size < a->capacity){
        a->data[a->size] = strClone(data);
        a->size++;
    }
}

void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j){
    if (i < a->size && j < a->size){
        char* dummy = a->data[i];
        a->data[i] = a->data[j];
        a->data[j] = dummy;
    }
}

void  strArrayDelete(str_array_t* a){
    for (uint8_t i = 0; i < a->size; i++){      // Hago free a cada puntero de data
        free(a->data[i]);
    }
    free(a->data);                                    // Hago free al puntero 'a'
    free(a);
}



void strArrayPrint(str_array_t* a, FILE* pFile) {
    fprintf(pFile, "[");
    for(int i=0; i<a->size-1; i++) {
        strPrint(a->data[i], pFile);
        fprintf(pFile, ",");
    }
    if(a->size >= 1) {
        strPrint(a->data[a->size-1], pFile);
    }
    fprintf(pFile, "]");
}

char* strArrayRemove(str_array_t* a, uint8_t i) {
    char* ret = 0;
    if(a->size > i) {
        ret = a->data[i];
        for(int k=i+1;k<a->size;k++) {
            a->data[k-1] = a->data[k];
        }
        a->size = a->size - 1;
    }
    return ret;
}

char* strArrayGet(str_array_t* a, uint8_t i) {
    char* ret = 0;
    if(a->size > i)
        ret = a->data[i];
    return ret;
}
