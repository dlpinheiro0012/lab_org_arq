# Este código foi testado em outro PC e funcionou, mas no meu pessoal não funcionou; eu reiniciei o compsim 7 vezes
# mas ainda assim não deu a resposta desejada. 

addi x11, x0, 1
addi x12, x0, 32 
addi x13, x0, 1
sb x11, 1029(x0)

loop:
	beq x11, x12, loop
	lb x10, 1026(x0)
	andi x10, x10, 1
	beq x10, x13, on
	jal x0, loop

on:
	slli x11, x11, 1
	sb x11, 1029(x0)
	jal x0, loop

off:
	lb x10, 65(x0)
	sb x0, 1029(x0)
	jal x0, loop

halt 

HIGH: .byte 1
LOW:  .byte 0
