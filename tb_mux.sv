`timescale 1ns/1ps

module tb_mux
(
logic [31:0] a = 32'd2000;
logic [31:0] b = 32'd1000;
logic [31:0] c = 32'd555;
logic [31:0] d = 32'd234;
logic [2:0] selecao;
logic [31:0] muxOut;
);
   
mux dut(.f(muxOut),.e1(a),.e2(b),.e3(c),.e4(d),.sel(selecao));

initial begin
$monitor($time," a=%d | b=%d | c=%d | d=%d | sel=%b | muxOut=%d",a, b, c, d, selecao, muxOut);
for(selecao = 0; selecao < 4; selecao++) #10;
#10 $stop;

endmodule
