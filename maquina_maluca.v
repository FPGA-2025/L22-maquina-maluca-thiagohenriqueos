module maquina_maluca (
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire agua_enchida,
    output wire [3:0] state
);

    localparam IDLE                = 4'd1;
    localparam LIGAR_MAQUINA       = 4'd2;
    localparam VERIFICAR_AGUA      = 4'd3;
    localparam ENCHER_RESERVATORIO = 4'd4;
    localparam MOER_CAFE           = 4'd5;
    localparam COLOCAR_NO_FILTRO   = 4'd6;
    localparam PASSAR_AGITADOR     = 4'd7;
    localparam TAMPEAR             = 4'd8;
    localparam REALIZAR_EXTRACAO   = 4'd9;

    reg [3:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 4'd1;
        end else begin
            current_state <= next_state;
        end
    end

    // Lógica de próxima transição com erros
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start)
                    next_state = LIGAR_MAQUINA;
                else
                    next_state = IDLE;
            end

            LIGAR_MAQUINA: 
                next_state = VERIFICAR_AGUA;

            VERIFICAR_AGUA: begin
                if (agua_enchida)
                    next_state = MOER_CAFE;
                else
                    next_state = ENCHER_RESERVATORIO;
            end

            ENCHER_RESERVATORIO: 
                next_state = VERIFICAR_AGUA;

            MOER_CAFE:         
                next_state = COLOCAR_NO_FILTRO;

            COLOCAR_NO_FILTRO: 
                next_state = PASSAR_AGITADOR;

            PASSAR_AGITADOR:   
                next_state = TAMPEAR;

            TAMPEAR:           
                next_state = REALIZAR_EXTRACAO;

            REALIZAR_EXTRACAO: 
                next_state = IDLE;

            default: 
                next_state = IDLE;
        endcase
    end

    assign state = current_state;

endmodule
