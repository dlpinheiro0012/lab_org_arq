`timescale 1ns/1ps

module button_fsm_tb;

    // -------------------------------------------------------------------------
    // Sinais de estimulo e observacao
    // -------------------------------------------------------------------------
    logic       clk;
    logic       rst_n;
    logic [3:0] btn;
    logic [3:0] LED;

    // -------------------------------------------------------------------------
    // Instancia do DUT (Device Under Test)
    // -------------------------------------------------------------------------
    lab3 dut (
        .clk   (clk),
        .rst_n (rst_n),
        .entradas (btn),
        .leds   (LED)
    );

    // -------------------------------------------------------------------------
    // Geracao de clock: periodo de 20ns -> 50 MHz
    // -------------------------------------------------------------------------
    initial clk = 0;
    always #10 clk = ~clk;

    // -------------------------------------------------------------------------
    // Task: pressiona o botao por alguns ciclos e solta
    //   - press_val: valor do botao a ser pressionado
    //   - btn e ativo baixo na placa, simulado aqui como:
    //     btn = ~press_val quando pressionado, btn = 4'b1111 quando solto
    // -------------------------------------------------------------------------
    task press_button(input logic [3:0] press_val, input int hold_cycles);
        @(negedge clk);
        btn = ~press_val;                // Pressiona (ativo baixo)
        $display("INPUT: BTN = 4'b%04b (Press %04b)", btn, press_val);
        repeat (hold_cycles) @(posedge clk);
        @(negedge clk);
        btn = 4'b1111;                   // Solta (tudo 1)
        $display("INPUT: BTN = 4'b%04b (Release)", btn);
        repeat (3) @(posedge clk);       // Aguarda estabilizar
    endtask

    // -------------------------------------------------------------------------
    // Task: verifica o estado dos LEDs e imprime resultado
    // -------------------------------------------------------------------------
    task check_state(input logic [3:0] expected, input string msg);
        @(negedge clk);
        if (LED[0] === expected[0]) // Compara o bit de status
            $display("[PASS] %s | LED = %b", msg, LED[0]);
        else
            $display("[FAIL] %s | ESPERADO = %b, OBTIDO = %b", 
                     msg, expected[0], LED[0]);
    endtask

    // -------------------------------------------------------------------------
    // Sequencia de testes
    // -------------------------------------------------------------------------
    initial begin
        // Dump de formas de onda para visualizacao no GTKWave
        $dumpfile("button_fsm.vcd");
        $dumpvars(0, button_fsm_tb);

        // Condicao inicial
        rst_n = 1'b1;
        btn   = 4'b1111;  // Botao solto em ativo baixo é 1111
        $display("INPUT: RST_N = 1'b%01b, BTN = 4'b%04b", rst_n, btn);

        // ------------------------------------------------------------------
        // Teste 1: Reset
        // ------------------------------------------------------------------
        $display("\n=== TESTE 1: RESET ===");
        rst_n = 1'b0;
        $display("INPUT: RST_N = 1'b%01b", rst_n);
        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        $display("INPUT: RST_N = 1'b%01b", rst_n);
        @(posedge clk);
        check_state(1'b0, "APOS RESET -> S0 (TRANCADO)");

        // ------------------------------------------------------------------
        // Teste 2: Sequencia Correta [Azul, Amarelo, Verde, Vermelho]
        // ------------------------------------------------------------------
        $display("\n=== TESTE 2: SEQUENCIA CORRETA ===");
        press_button(4'b0001, 2); // Azul
        press_button(4'b0100, 2); // Amarelo
        press_button(4'b0100, 2); // Verde
        press_button(4'b1000, 2); // Vermelho
        check_state(1'b1, "SEQUENCIA DIGITADA -> DESBLOQUEADO");

        // ------------------------------------------------------------------
        // Teste 3: Reset apos desbloqueio
        // ------------------------------------------------------------------
        $display("\n=== TESTE 3: RESET APOS DESBLOQUEIO ===");
        rst_n = 1'b0;
        $display("INPUT: RST_N = 1'b%01b", rst_n);
        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        $display("INPUT: RST_N = 1'b%01b", rst_n);
        @(posedge clk);
        check_state(1'b0, "RESET ACIONADO -> TRANCADO");

        // ------------------------------------------------------------------
        // Teste 4: Entrada Invalida (Botao Errado)
        // ------------------------------------------------------------------
        $display("\n=== TESTE 4: ENTRADA INVALIDA (BOTAO ERRADO) ===");
        press_button(4'b0001, 2); // Azul
        press_button(4'b0100, 2); // Verde (Errado na 2ª posicao)
        press_button(4'b0010, 2); // Amarelo
        press_button(4'b1000, 2); // Vermelho
        check_state(1'b0, "SEQUENCIA ERRADA -> PERMANECE TRANCADO");

        // ------------------------------------------------------------------
        // Teste 5: Entrada Invalida (Mais de um botao / Nao one-hot)
        // ------------------------------------------------------------------
        $display("\n=== TESTE 5: ENTRADA INVALIDA (NAO ONE-HOT) ===");
        rst_n = 1'b0; @(posedge clk); rst_n = 1'b1; // Garante inicio limpo
        $display("INPUT: RST_N = 1'b0 -> 1'b1");
        
        press_button(4'b0001, 2); // Azul
        press_button(4'b0011, 2); // Azul + Amarelo (Invalido)
        press_button(4'b0100, 2); // Verde
        press_button(4'b1000, 2); // Vermelho
        check_state(1'b0, "BOTOES SIMULTANEOS -> PERMANECE TRANCADO");

        // ------------------------------------------------------------------
        // Teste 6: Deteccao de borda (Segurar o botao)
        // ------------------------------------------------------------------
        $display("\n=== TESTE 6: DETECCAO DE BORDA (SEGURAR O BOTAO) ===");
        rst_n = 1'b0; @(posedge clk); rst_n = 1'b1; // Garante inicio limpo
        $display("INPUT: RST_N = 1'b0 -> 1'b1");
        
        press_button(4'b0001, 20); // Segura Azul por 20 ciclos
        press_button(4'b0100, 2);  // Amarelo
        press_button(4'b0100, 2);  // Verde
        press_button(4'b1000, 2);  // Vermelho
        check_state(1'b1, "BOTAO SEGURADO 20 CICLOS -> DESBLOQUEADO");

        $display("\n=== SIMULACAO CONCLUIDA ===\n");
        $finish;
    end

endmodule
