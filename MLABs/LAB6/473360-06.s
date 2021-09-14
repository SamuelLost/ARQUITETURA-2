@DERIVAÇÃO DO LAB 5 SÓ QUE COM (, [, {
.global main
.func main

main:
	ldr r1, =str
	mov r8, sp @Movendo o topo da pilha para r8
	mov r4, #0
l:
	bl _getchar
	ldrb r0, [r1]
	add r1, r1, #1
	cmp r0, #0x30 @COMPARA COM '0' PARA TERMINAR A LEITURA
	beq loop_vet
	b l
loop_vet:
	ldr r1, =str
processo:
	ldrb r0, [r1]
	add r1, r1, #1
	cmp r0, #0x30
	beq olhaPilha

	cmp r0, #0x28 @(
	beq empilhaCaract

	cmp r0, #0x5b @[
	beq empilhaCaract

	cmp r0, #0x7b @{
	beq empilhaCaract

	cmp r0, #0x29 @)
	beq desempilhaParentese

	cmp r0, #0x5d @]
	beq desempilhaColchete

	cmp r0, #0x7d @}
	beq desempilhaChave

	cmp r0, #0
	beq zeraR0
	b processo

olhaPilha:
	cmp r8, sp
	bne zeraR0
	b p

empilhaCaract:
	push {r0}
	b processo

desempilhaParentese: @DESEMPIPLHA O PARENTESE
	pop {r4}
	cmp r4, #0x28 @(
	bne zeraR0

	b processo

desempilhaColchete: @DESEMPIPLHA O COLCHETE
	pop {r4}
	cmp r4, #0x5b @[
	bne zeraR0

	b processo

desempilhaChave: @DESEMPIPLHA A CHAVE
	pop {r4}
	cmp r4, #0x7b @{
	bne zeraR0

	b processo

zeraR0:
	mov r0, #0
p:
	@Se r0 = 0 a parentização não está correta, caso contrário a parentização está correta
	cmp r0, #0
	bne ok
	mov r7, #4
	mov r0, #1
	mov r2, #29
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
str:	.skip 400

exit_str:	.asciz "\nFim do Progama.\n"
out_ok:		.asciz "\nParentização Correta.\n"
out_nok:	.asciz "\nParentização não Correta.\n"
