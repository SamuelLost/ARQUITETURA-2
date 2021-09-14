@Samuel Henrique - 473360
.global main
.func main

main:
	mov r0, #0     @ OFFSET
l:
	cmp r0, #10
	beq ok
	ldr r1, =vet   @ CARREGANDO PARA R1 O END DO VET
	lsl r2, r0, #2	
	add r2, r1, r2 @ R2 = END_BASE + OFFSET
	add r0, r0, #1 @ ATT O R0
	str r0, [r2]   @ SALVANDO VALOR DE R0 NO ENDEREÇO DE R2
	b l
ok:
	mov r0, #0
	mov r4, #0
somaImpares:
	mov r3, #0
	cmp r0, #10
	beq fim
	ldr r1, =vet   @ PEGANDO O ENDEREÇO
	lsl r2, r0, #2
	add r2, r1, r2
	ldr r1, [r2]
	ldr r3, [r2]   @ GUARDANDO OS VALORES DO VETOR EM r3
	add r0, r0, #1 @ AVANÇANDO NO INDICE
	tst r3, #1     @ TESNTANDO O ULTIMO BIT COM O NUMERO 1
	bne soma       @ SE N FOR 0, ENTÃO O NÚMERO É ÍMPAR E PULA PARA SOMA
	b somaImpares

soma:
	add r4, r3, r4 @ REALIZA A SOMA: r4 = r3 (NUM IMPAR) + r4
	b somaImpares

fim:
	mov r1, r4     @ MOV O RESULTADO EM r4 PARA r1 COMO PARAMETRO PRO PRINTF
	bl _printf     @ CHAMA O PRINTF
	b _exit

_exit:
	mov r7, #4
	mov r0, #1
	mov r2, #17
	ldr r1, =exit_str
	swi 0
	mov r7, #1
	swi 0
	
_printf:
	push {lr}
	ldr r0, =printf_str
	bl printf
	pop {pc}

.data

.balign 4
vet:	.skip	40

printf_str:	.asciz 	"Soma = %d\n"
exit_str:	.asciz	"Fim do Programa.\n"
