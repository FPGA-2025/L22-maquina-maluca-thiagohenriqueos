`timescale 1ns/1ps

module tb_maquina_maluca;

    reg clk;
    reg reset;
    reg start;
    reg agua_enchida;  
    wire [3:0] state;

    // Instanciando o DUT (Device Under Test)
    maquina_maluca dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .agua_enchida(agua_enchida),
        .state(state)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 0;
        start = 0;
        agua_enchida = 0;

        // Aplica reset
        #20;
        reset = 1;

        // Espera alguns ciclos em IDLE
        #20;
        reset = 0;

        // Inicia a máquina
        start = 1;
        #10;
        start = 0;

        // Simula enchendo o reservatório com atraso
        #70;
        agua_enchida = 1;
        #10;
        agua_enchida = 0; // volta a zero depois (apenas um pulso)

        // Deixa rodar o fluxo completo
        #150;

        // Termina simulação
        $finish;
    end

    // Monitor para ver as transições
    initial begin
        $display("Time\tclk\trst_n\tstart\tagua_ok\tstate");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%0d", $time, clk, reset, start, agua_enchida, state);
    end

endmodule

