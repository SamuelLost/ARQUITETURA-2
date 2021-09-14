/*
    ESSE PROGRAMA TRATA A ENTRADA COMO 1234 ATÉ ENCONTRAR UM \n.
    UM PONTEIRO É USADO PARA PERCORRER BYTE POR BYTE.
*/
#include <stdio.h>
#include <unistd.h>
int main(){
    char string[100];
    char* ptr = string;

    read(STDIN_FILENO, ptr, 1);
    while(*ptr != '\n'){
        *ptr++;
        read(STDIN_FILENO, ptr, 1);
    }
    printf("Você entrou com: %s", string);
    return 0;
}