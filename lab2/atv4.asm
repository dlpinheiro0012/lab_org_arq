addi x10, x0, 28
addi x12, x0, 40

loop:
	lb x11, 0(x10)
	sb x11, 1024(x0)
	addi x10, x10, 1
	bne x10, x12, loop

halt

str1: .string "Hello World"
