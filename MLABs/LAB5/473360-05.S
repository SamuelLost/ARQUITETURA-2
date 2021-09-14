.global main
.func main

main:
	ldr  r1, =str
	mov r8, sp		@MOVE O TOPO DA PILHA PARA r8
	mov r4, #0
l:
	bl _getchar
	ldrb r0, [r1]		@CARREGANDO 1 BYTE OU 1 CARACTERE
	add r1, r1, #1		@PERCORRENDO DE BYTE EM BYTE
	cmp r0, #0x30		@COMPARA COM '0'
	beq loop_vet		@SE FOR IGUAL A ENTRADA DE CARACTERES É ENCERRADA
	b l

loop_vet:
	ldr r1, =str		@PEGA O ENDEREÇO

processo:
	ldrb r0, [r1]		@CARREGANDO 1 BYTE OU 1 CARACTERE
	add r1, r1, #1		
	cmp r0, #0x30		
	beq olhaPilha		@VERIFICA O TOPO DA PILHA
	cmp r0, #0x28		@COMPARA COM '('
	beq empilhaCaract	@SE FOR IGUAL EMPILHA
	cmp r0, #0x29		@COMPARA COM ')'
	beq desempilhaCaract	@SE FOR IGUAL DESEMPILHA O '(' QUE ESTEJA NA PILHA
	cmp r0, #0		@COMPARA r0 COM O
	beq zeraR0		@SE FOR IGUAL PULA PARA A LABEL
	b processo

olhaPilha:
	cmp r8, sp		@COMPARA O TOPO ANTERIOR COM O ATUAL
	bne zeraR0		@SE FOR DIFERENTE, PULA PARA A LABEL
	b p

empilhaCaract:
	push {r0}		@EMPILHA r0 QUE TÁ RECEBENDO OS CARACTERES
	b processo		

desempilhaCaract:
	pop {r4}		@DESEMPILHA O CARACTERE EM r4
	cmp r4, #0x28		@COMPARA r4 COM '('
	bne zeraR0		@SE NÃO FOR IGUAL ZERA r0 E A PARAMETRIZAÇÃO ESTÁ INCORRETA
	b processo

zeraR0:
	mov r0, #0

p:
	@Se r0 = 0 a parentização não está correta, caso contrário a parentização está correta 
	cmp r0, #0
	bne ok
	mov r7, #4
	mov r0, #1
	mov r2, #27
	ldr r1, =out_nok
	swi 0
	b fim
ok: 
	mov r7, #4
	mov r0, #1
	mov r2, #23
	ldr r1, =out_ok
	swi 0
fim:
	b _exit

_getchar:
	push {lr}
	mov r7, #3
	mov r0, #0
	mov r2, #1
	swi 0
	pop {pc}

_print:
	push {lr}
	mov r7, #4
	mov r0, #1
	mov r2, #1
	mov r1, r1
	swi #0
	pop {pc}
_exit:
	mov r7, #4
	mov r0, #1
	mov r2, #18
	ldr r1, =exit_str
	swi 0
	mov r7, #1
	swi 0


.data

.balign 4
str:	.skip	400

exit_str:	.asciz	"\nFim do Programa.\n"
out_ok:		.asciz	"\nParentizacao Correta.\n"
out_nok:	.asciz	"\nParentizacao nao Correta.\n"
