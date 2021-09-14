@=====================================================================================================
@			PROVA PRÁTICA: Samuel Henrique - 473360
@ O ARQUIVO DE ENTRADA DEVE TER DOIS NUMEROS a E b SEPARADOS POR UMA VIRGULA E UM ESPAÇO, EX: a, b
@ a E b PRECISAM SER HEXADECIMAIS E MAIUSCULOS.
@ TODOS OS REGISTRADORES SÃO SALVOS EM MEMÓRIA ASSIM Q O PROGRAMA É INICIADO. SEGUNDO PASSO É ABRIR OS
@ ARQUIVOS. LER OS VALORES REFERENTES A a E b DO ARQUIVO. FAZER A COMPARAÇÃO DOS DOIS, PARA SABER QUAL
@ É MAIOR Q O OUTRO. APÓS ISSO, É FEITO A IMPRESSÃO DOS VALORES DOS REGISTRADORES, PARA ISSO É 
@ É NECESSÁRIO CALCULAR UM DESLOCAMENTO PARA IMPRIMIR NO INTERVALOR DE a-b OU b-a. 
@ CASO: a>b: A LISTAGEM DOS REGISTRADORES COMEÇA DE b QUE É O VALOR MENOR, POR ISSO, USO SEU VALOR
@ COMO DESLOCAMENTO, DE 4 EM 4 BYTES, VISTO QUE OS REGISTRADORES POSSUEM 32bits. 
@ CASO a<b: A LISTAGEM DOS REGISTRADORES COMEÇA DE a QUE É O VALOR MENOR, POR ISSO, USO SEU VALOR COMO
@ DESLOCAMENTO, DE 4 EM 4 BYTES. PARA VER OS VALORES DOS REGISTRADORES NA MEMORIA, BASTA EXECUTAR COM 
@ GDB E DAR O SEGUINTE COMANDO x/16x 0x2105b, IRÁ APARECER OS VALORES DE R0-R15. 
@=====================================================================================================
.global main
.func main

main:

				@SALVANDO TODOS OS REGISTRADORES NA MEMORIA	
	ldr r1, =R0
	str r0, [r1], #4
	
	mov r0, r1
	stmia r0!, {r1-r15}

@Open InputFile
        mov r7, #5      	@open
        mov r2, #0      	@mode
        mov r1, #0      	@flag
        ldr r0, =nomeArquivoInput
        swi #0

        mov r8, r0      	@fd de origem

@Open OutputFile
        mov r7, #5
        ldr r2, =0x1FF  	@mode - como se fosse chmod 777
        ldr r1, =0x241  	@flag
        ldr r0, =nomeArquivoOutput
        swi #0

        mov r9, r0      	@fd de destino

lendoA:			@READ entrada.in

	ldr r1, =a
	mov r2, #1		@LENDO UM BYTE
        mov r7, #3      	@read
        mov r0, r8      	@fd de origem
        swi #0

        cmp r0, #0      	@É o fim do arquivo ?
        ble fim

	ldr r0, =a		@caractere lido
	ldrb r5, [r0]		@R5 = a

lendoB:				@LENDO O VALOR b
	ldr r1, =b
	mov r2, #1		@LENDO UM BYTE
	mov r7, #3
	mov r0, r8		@FD DA ENTRADA
	swi #0

	ldr r0, =b
	ldrb r6, [r0]		@R6 = b

	cmp r6, #0x20		@compara com um espaço
	beq lendoB		@SE FOR IGUAL, LE O PROX CARACTERE

	cmp r6, #','		@COMPARA COM A VIRGULA
	beq lendoB		@SE FOR IGUAL, LE O PROX CARACTERE

	sub r5, r5, #'0'	@TRANSFORMANDO a E b EM INTEIROS 1,2,3,4...
	sub r6, r6, #'0'

	cmp r5, #0x9
	subgt r5, r5, #0x7	@DEIXANDO NO INTERVALOR [A-F]

	cmp r6, #0x9
	subgt r6, r6, #0x7	@DEIXANDO NO INTERVALOR [A-F]
	
	cmp r5, r6		@FAZENDO A COMPARAÇÃO
	bge amaior		@SE R5(a) > R6(b) ---> PULA PARA LABEL amaior:
	ble bmaior		@SE R5(a) < R6(b) ---> PULA PARA LABEL bmaior:

amaior:
	ldr r1, =R0		@FAÇO r1 APONTAR PARA O VALOR DE R0 NA MEMORIA
	push {r6}
	lsl r6, r6, #2		@MULTIPLICO O b POR 4
	add r1, r1, r6		@FAÇO O DESLOCAMENTO DE R1 ATÉ O NUMERO DO REGISTRADOR DADO POR b
	pop {r6}
	
	mov r8, #28		@INDEX DE BUFFER, VAI SALVANDO DE TRÁS PARA FRENTE EM CONJUNTOS DE 4 BYTES
	ldr r4, =buffer		
	ldr r2, [r1]
_hexA:				@HEXA PARA ASCII
	mov r0, r2
	and r10, r0, #0xF	@DEIXANDO SÓ O 4 BITS MENOS SIGNIFICATIVOS
	cmp r10, #0x09		
	bhi greatA
	add r10, r10, #0x30	@TRANSFORMANDO EM ASCII

	b nextA
greatA:
	add r10, r10, #0x37	@SOMANDO COM 7 CASO SEJA > 9

nextA:
	strb r10, [r4, r8]	@SALVANDO O ASCII EM BUFFER COM O DESLOCAMENTO DE R8
	cmp r8, #0
	beq _endhexA		@QND CHEGAR EM 0, ACABA
	sub r8, r8, #4		@AJUSTA O OFFSET 4 BYTES PARA TRÁS
	lsr r2, r2, #4		@PEGA OS PROXIMOS 4 BITS
	b _hexA
_endhexA:

	mov r12, #8		@PARA IMPRIMIR AS STRING sRx:, SÃO 8 CARACTERES
	mul r11, r12, r6	@MULTIPLICA PELO VALOR DE b QUE É O MENOR
	ldr r1, =sR0
	add r1, r11, r1		@FAZ O DESLOCAMENTO E CHEGA ATÉ A STRING sRb:
				@IMPRIME "Rb: 0x"

	mov r2, #8		@IMPRIME 8 CARACTERES
	mov r0, r9
	mov r7, #4		@IMPRIME NO ARQUIVO
	swi #0

	ldr r1, =buffer		@IMPRIME TODO O BUFFER COM O HEXADECIMAL EM ASCII
	mov r2, #32
	mov r0, r9
	mov r7, #4		@IMPRIME NO ARQUIVO
	swi #0

	ldr r1, =newline	@IMPRIME UM \n
	mov r2, #1
	mov r0, r9
	mov r7, #4		@IMPRIME NO ARQUIVO
	swi #0

	cmp r6, r5		@COMPARA b COM a
	beq fim			@ b = a ?

	add r6, r6, #1		@COMO b É MENOR Q a, FAÇO b CHEGAR ATÉ O a
	b amaior		@VOLTA PRO LOOP PARA IMPRIMIR O PROXIMO REGISTER

bmaior:
	ldr r1, =R0		@FAÇO r1 APONTAR PARA O VALOR DE R0 NA MEMORIA
	push {r5}
	lsl r5, r5, #2		@MULTIPLICO O a POR 4
	add r1, r1, r5		@FAÇO O DESLOCAMENTO DE R1 ATÉ O NUMERO DO REGISTRADOR DADO POR a
	pop {r5}
	
	mov r8, #28		@INDEX DE BUFFER, VAI SALVANDO DE TRÁS PARA FRENTE EM CONJUNTOS DE 4 BYTES
	ldr r4, =buffer
	ldr r2, [r1]

_hex:				@HEX PARA ASCII	
	mov r0, r2
	and r10, r0, #0xF	@DEIXANDO OS 4 BITS MENOS SIGN	
	cmp r10, #0x09
	bhi great
	add r10, r10, #0x30	@SOMA COM '0' PARA TRANSFORMAR EM ASCII

	b next
great:
	add r10, r10, #0x37	@SOMA COM '7'

next:
	strb r10, [r4, r8]	@SALVA EM BUFFER COM OFFSET DE R8
	cmp r8, #0
	beq _endhex
	sub r8, r8, #4		@VOLTO 4 BYTES EM BUFFER
	lsr r2, r2, #4		@PEGO OS PROXIMOS 4BITS
	b _hex
_endhex:

	mov r12, #8		@PARA IMPRIMIR AS STRING sRx:, SÃO 8 CARACTERES
	mul r11, r12, r5	@MULTIPLICA PELO VALOR DE a
	ldr r1, =sR0
	add r1, r11, r1		@FAZ O DESLOCAMENTO ATÉ sRa:.
				@IMPRIME "Ra: 0x"

	mov r2, #8		@IMPRIME 8BYTES
	mov r0, r9
	mov r7, #4		@IMPRIME NO ARQUIVO
	swi #0

	ldr r1, =buffer		@IMPRIME BUFFER
	mov r2, #32
	mov r0, r9
	mov r7, #4		@IMPRIME NO ARQUIVO
	swi #0

	ldr r1, =newline	@IMPRIME \n
	mov r2, #1
	mov r0, r9
	mov r7, #4		@IMPRIME NO ARQUIVO
	swi #0
	
	cmp r5, r6		@COMPARA a COM b
	beq fim			@ a = b ?
	add r5, r5, #1		@COMO a É MENOR Q b, FAÇO a CHEGAR ATÉ O b

	b bmaior		@VOLTA PRO LOOP PARA IMPRIMIR O PROXIMO REGISTER



fim:

@CLOSE INPUTFILE
	mov r7, #6
	mov r0, r8
	swi #0

@CLOSE OUTPUTFILE
	mov r7, #6
	mov r0, r9
	swi #0

        mov r7, #1      	@exit
        mov r0, #0      	@Return 0
        swi #0


.data
.balign 4
newline:		.asciz	"\n"
a:			.byte	1
b:			.byte 	1
buffer:			.skip	32
nomeArquivoInput:       .asciz "entrada.in"
nomeArquivoOutput:      .asciz "saida.out"
R0:			.skip	4
R1:			.skip	4
R2:			.skip	4
R3:			.skip	4
R4:			.skip	4
R5:			.skip	4
R6:			.skip	4
R7:			.skip	4
R8:			.skip	4
R9:			.skip	4
R10:			.skip	4
R11:			.skip	4
R12:			.skip	4
R13:			.skip	4
R14:			.skip	4
R15:			.skip	4
sR0:			.asciz "R00: 0x"
sR1:			.asciz "R01: 0x"
sR2:			.asciz "R02: 0x"
sR3:			.asciz "R03: 0x"
sR4:			.asciz "R04: 0x"
sR5:			.asciz "R05: 0x"
sR6:			.asciz "R06: 0x"
sR7:			.asciz "R07: 0x"
sR8:			.asciz "R08: 0x"
sR9:			.asciz "R09: 0x"
sR10:			.asciz "R10: 0x"
sR11:			.asciz "R11: 0x"
sR12:			.asciz "R12: 0x"
sR13:			.asciz "R13: 0x"
sR14:			.asciz "R14: 0x"
sR15:			.asciz "R15: 0x"
