`timescale 1ns/1ps

module tb_mux;
logic [31:0] e1 = 32'd2000;
logic [31:0] e2 = 32'd1000;
logic [31:0] e3 = 32'd555;
logic [31:0] e4 = 32'd234;
logic [2:0] selecao;
logic [31:0] muxOut;

   mux dut(.saida(muxOut), .a(e1), .b(e2), .c(e3), .d(e4), sel.(selecao));

   initial begin
     $monitor($time,"a = %b | b = %b | c = %b | d = %d | sel = %b | muxOut = %b", e1, e2, e3, e4, selecao, muxOut);
     for(sel = 0; sel != 3'b111; sel++) #10;     
     #10 $stop;

   end
