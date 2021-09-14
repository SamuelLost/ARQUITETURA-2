.global main
.func main

main:
	ldr  r1, =str
l:
	bl _getchar
	ldrb r0, [r1]
	add r1, r1, #1
	cmp r0, #0x30
	beq p
	b l
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
out_ok:	.asciz	"\nParentizacao Correta.\n"
out_nok:	.asciz	"\nParentizacao nao Correta.\n"
