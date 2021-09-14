@====================================================================
@				LAB7
@ O PROGRAMA COPIA DADOS DE UM ARQUIVO DE ENTRADA PARA UM DE SAIDA
@ O ARQUIVO DE ENTRADA DEVE ESTÁ NA PASTA E DEVE SE CHAMAR inFile.txt
@ O ARQUIVO DE SAIDA NAO PRECISA EXISTIR, SE EXISTIR SERÁ SOBRESCRITO
@====================================================================
.data

.balign	4
in_handle: 	.skip	4
out_handle: 	.skip	4
out_buffer:	.skip	200
in_buffer: 	.skip	200
in_size: 	.skip	4

oi:		.asciz "oi\n"
out_file:	.asciz "outfile.txt"
in_file:	.asciz "inFile.txt"
str_exit:	.asciz "Fim do Programa\n"

.text

.global main
.func main

main:
	mov r7, #5		@open
	ldr r0, =in_file	@file input
	ldr r1, =0x0		@only read
	ldr r2, =0x0		@mode
	swi 0			@open the file; r0 = file descriptor

	ldr r1, =in_handle	@input fd
	str r0, [r1]		@store in [r1]; [r1] = input fd

	mov r7, #5		@open
	ldr r0, =out_file	@file output
	mov r1, #0101		@if file not exists, file is created, read and write
	ldr r2, =0x180		@permissions
	swi 0			@open the file; r0 = file descriptor

	ldr r1, =out_handle	@input fd
	str r0, [r1]		@store in [r1]; [r1] = input fd

read:
	ldr r1, =in_handle	@r1 = file input
	ldr r0, [r1]		@fd input
	ldr r1, =in_buffer	@input buffer
	mov r2, #100		@number of bytes
	mov r7, #3		@read
	swi 0			@read the file in in_buffer

	ldr r1, =in_size	@number of bytes readed
	str r0, [r1]		@[r1] = number of bytes


out:

@Impressão
	ldr r0, =out_handle	@output fd to r0
	ldr r0, [r0]		@output fd
	ldr r1, =in_buffer	@buffer input
	ldr r2, =in_size	@number of bytes
	ldr r2, [r2]
	mov r7, #4		@write
	swi 0			@write to file

close:
	ldr r0, =in_handle	@load input file to r0
	ldr r0, [r0]
	mov r7, #6		@close
	swi 0			@close file

	ldr r0, =out_handle	@load output file to r0
	ldr r0, [r0]
	mov r7, #6		@close
	swi 0			@close file

_exit:
	mov r7, #4		@write
	mov r0, #1		@write in screen
	mov r2, #17		@number of bytes
	ldr r1, =str_exit	@string
	swi 0			@print in screen

	mov r7, #1		@exit
	swi 0			@ends the program
