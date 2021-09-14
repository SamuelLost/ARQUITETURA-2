.global main
.func main

main:
	mov r0, #0 
l:
	cmp r0, #10
	beq ok
	ldr r1, =vet
	lsl r2, r0, #2	
	add r2, r1, r2
	add r0, r0, #1	 	
	str r0, [r2]
	b l
ok:
	mov r0, #0
somaImpares:
	mov r3, #0
	cmp r0, #10
	beq fim
	ldr r1, =vet
	lsl r2, r0, #2
	add r2, r1, r2
	ldr r1, [r2]
	push {r0}
	push {r1}
	push {r2}
	mov r2, r1
	mov r1, r0
	bl _printf
	pop {r2}
	pop {r1}
	pop {r0}
	add r0, r0, #1
	b somaImpares
fim:
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

printf_str:	.asciz 	"a[%d] = %d\n"
exit_str:	.asciz	"Fim do Programa.\n"

