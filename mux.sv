module mux
(
    input  logic [31:0] e1, e2, e3, e4,
    input  logic [2:0]  sel,
    output logic [31:0] f
);
always_comb begin
    case (sel)
        3'b000  : f = e1;
        3'b001  : f = e2;
        3'b010  : f = e3;
        3'b011  : f = e4;
        default : f = 32'd0;
    endcase
end
endmodule
