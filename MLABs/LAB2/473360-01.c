#include <stdio.h>
#include <unistd.h>
char hex[100];

int main(){
    unsigned char* ptr = hex; // Ponteiro aponta para a string
    int x=0, SumINT=0;
    unsigned char aux=0;
    
    write(STDOUT_FILENO, "Entre com um número hexadecimal: ", 34);
    read(STDIN_FILENO, ptr, 1); //Lendo o primeiro caractere 
    x++;
    while(*ptr != '\n') { //Condição até apertar enter
        *ptr++; //Avançando na string
        read(STDIN_FILENO, ptr, 1); //Lendo os demais caracteres
        x++; //Contador de caracteres inseridos
    }
    hex[x] = '\0'; //Após quebra o while, colocar o \0 no final da string

    /******** Conversão ********/

    x=0;
    aux = hex[x]; //Usando um char aux para guardar os caracteres e não alterar a string original
    while(aux != '\n') { //Até chegar no enter
        SumINT = SumINT << 4; //Abrindo espaço, multiplicando por 16
        if(aux > '9') aux += 9; //Intervalo em hex
        aux &= 0x0F; //Mascara para ASCII
        SumINT = SumINT + (int)aux; //Inserindo no espaço fazio criado pelo deslocamento

        x++; //Incrementa contador
        aux = hex[x]; //Pega o prox caract
    }

    /******** Conversão ********/

    printf("Número digitado em hexadecimal: %#010x = %d (decimal)\n", SumINT, SumINT);
    //x = 0;
    write(STDOUT_FILENO, "Número hexadecimal digitado: ", 30);
    ptr = hex; //Apontando para o começo 
    write(STDOUT_FILENO, ptr, 1); //Imprimindo o primeiro caract
    while(*ptr != '\n') {
        *ptr++; //Indo para o prox
        write(STDOUT_FILENO, ptr, 1); //Imprimindo o restante
    }

    return 0;
}