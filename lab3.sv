module lab3 (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] entradas, //entradas logicas para a sequencia correta
    output logic [3:0] leds
);

typedef enum logic [3:0] {
    S0 = 4'b0000,   // Estado inicial
    S1 = 4'b0001,   // Estado 1        -- LEDR[0] aceso
    S2 = 4'b0010,   // Estado 2        -- LEDR[1] aceso
    S3 = 4'b0100,    // Estado 3        -- LEDR[2] aceso
    S4 = 4'b1000     // Estado 4        -- LEDR[3] aceso / Cofre Aberto
} state_t;

state_t state, next_state;

logic [3:0] btn_active;  // Botao em logica positiva (1 = pressionado)
logic [3:0] btn_prev;    // Valor do botao no ciclo anterior
logic [3:0] btn_rise;    // Pulso de 1 ciclo na borda de subida

assign btn_active = ~entradas;
assign btn_rise   = btn_active & ~btn_prev;  // Borda de subida

// Registra o estado anterior do botao (FF simples)
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) btn_prev <= 4'd0;
    else        btn_prev <= btn_active;
end

//faz as trocas com base sequencial
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S0;
    else state <= next_state;
 
end

always_comb begin
    next_state = state;
    unique case (state)
        S0: begin if (btn_rise == 4'd1) next_state = S1; else if (btn_rise != 4'd0) next_state = S0; end
        S1: begin if (btn_rise == 4'd2) next_state = S2; else if (btn_rise != 4'd0) next_state = S0; end
        S2: begin if (btn_rise == 4'd4) next_state = S3; else if (btn_rise != 4'd0) next_state = S0; end
        S3: begin if (btn_rise == 4'd8) next_state = S4; else if (btn_rise != 4'd0) next_state = S0; end
    S4: next_state = S4;
        default:          next_state = S0;
    endcase
end

assign leds = (state == S4) ? 4'b0001 : 4'b0000; //recebe o valor de ligação somente se o estado for S4

endmodule
