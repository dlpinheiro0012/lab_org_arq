# Executando um codigo de loop em C
# int k = 1; int j = 0;
# While (j <= 2) {
#  k *= 2; j++}
lb x9, 36(x0)
lb x10, 40(x0) # arm. o valor de j no x10
addi x11, x0, 3 # arm. valor de parada em x11

Loop: 
	beq x10, x11, END #verifico cond. permanencia
	slli x9, x9, 1 #multiply k by 2
	addi x10, x10, 1 # incremento
	beq x0, x0, Loop # volta o loop
END: 
	sb x9, 64(x0)
	
k: .byte 0x01 
j: .byte 0x00
