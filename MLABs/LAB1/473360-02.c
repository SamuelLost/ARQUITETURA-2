/*
    ESSE PROGRAMA TRATA A ENTRADA COMO 1234 ATÉ ENCONTRAR UM \n.
    QUANDO ENCONTRAR O \n VAI SER CONVERTIDO EM INTEIRO COM A SUBTRAÇÃO DO CARACTERE '0' E GUARDANDO O VALOR EM UM VARIAVEL (sumint).
    APÓS ISSO O NÚMERO É CONVERTIDO EM CHAR NOVAMENTE E IMPRESSO POR write.
    UM PONTEIRO É USADO PARA PERCORRER BYTE POR BYTE.
*/
#include <unistd.h>
#include <stdio.h>
int main(){
    char vetor[100];
    char* ptr = vetor;
    char aux=0;
    int i=0, sumint=0;
      
    read(STDIN_FILENO, ptr, 1);
    while(*ptr != '\n'){
        *ptr++;
        read(STDIN_FILENO, ptr, 1);
    }

    //char* ptr2 = vetor;
    ptr = vetor;
    while(*ptr != '\n'){
        aux = vetor[i];
        aux = aux - '0';
        sumint+=aux;
        *ptr++;
        i++;
    }
    char n = '\n';
    aux = 0;
    aux = sumint + '0';
    write(STDOUT_FILENO, &aux, 1);
    write(STDOUT_FILENO, &n, 1);
    //printf("%c", aux);
    //printf("\n%d", sumint);
    return 0;
}