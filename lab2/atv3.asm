# pseudocodigo
#input i,j,g,h
#output f
#if i == j then 
#f = g + h
#else then
#f = g - h
#return f

lw x19, f
lw x20, g
lw x21, h
lw x22, i
lw x23, j

beq x22, x23, end1
sub x19, x20, x21
beq x0, x0, end2

end1:
	add x19, x20, x21
end2:
	sw x19, f
halt 

i: .word x02
j: .word x02
g: .word x04
h: .word x06
f: .word x00
