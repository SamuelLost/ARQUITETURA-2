.global main
.func main

main:
@Open FileOrige
        mov r7, #5      @open
        mov r2, #0      @mode
        mov r1, #0      @flag
        ldr r0, =nomeArquivoInput
        swi #0

        mov r8, r0      @fd de origem

@Open fileDest
        mov r7, #5
        ldr r2, =0x1FF  @mode - como se fosse chmod 777
        ldr r1, =0x241  @flag
        ldr r0, =nomeArquivoOutput
        swi #0

        mov r9, r0      @fd de destino

        mov r2, #1
        ldr r1, =varTemp

	mov r5, #0
readByteFromFileOrigem:
        mov r7, #3      @read
        mov r0, r8      @fd de origem
        swi #0
        cmp r0, #0      @É o fim do arquivo ?
        ble fim
	mov r1, #0
	mov r5, #0
@ALTEREI AQUI
	mov r3, #31	@count
	ldr r0, =varTemp	@=ok
	ldrb r5, [r0]	@tmp
	mov r1, r5	@num
	lsr r1, r1, #1
@FLIP BITS
while:				@AQUI OCORRE A INVERSÃO
	mov r4, r1
	cmp r4, #0
	beq end_while
	lsl r5, r5, #1
	and r4, r4, #1
	orr r5, r5, r4
	lsr r1, r1, #1
	sub r3, r3, #1

	b while
	
end_while:
	lsl r5, r5, r3
	lsr r5, r5, #24
	ldr r1, =varTemp
	str r5, [r1]
@ALTEREI AQUI

writeByteToFileDesti:
        mov r7, #4      @write
        mov r0, r9      @fd de destino
	ldr r1, =varTemp @ALTEREI AQUI
        swi #0
        b readByteFromFileOrigem
fim:
        mov r7, #1      @exit
        mov r0, #0      @Return 0
        swi #0

.data
.balign 4
varTemp:                .byte 1
nomeArquivoInput:       .asciz "fileInput.txt"
nomeArquivoOutput:      .asciz "fileOutput.txt"
