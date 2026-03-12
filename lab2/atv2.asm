lw x19, a
lw x20, b
lw x21, m

blt x20, x21, end
sub x21, x19, x20
beq x0, x0, else

end:
	add x21, x19, x20
else:
	sw x21, m
halt

a: .word 0xf
b: .word 0x6
m: .word 0x0
