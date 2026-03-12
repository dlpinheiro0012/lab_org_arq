lw x10, a
lw x11, b
sw x10, m

lw x14, m
blt x11, x14, end
beq x0, x0, end2

end:
	add x14, x10, x11
end2:
	sw x14, m
halt

a: .word 0x6
b: .word 0xf
m: .word 0x0