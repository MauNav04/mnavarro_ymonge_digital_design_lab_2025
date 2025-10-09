

// Lleva el control del turno actual y de los puntajes para dos jugadores.
module puntaje_jugadores (
    input  logic clk,
    input  logic reset,
    input  logic cambiar_turno,
    input  logic incrementar_punto,
    output logic jugador_actual,     // 0 -> jugador A, 1 -> jugador B
    output logic [3:0] puntaje_j1,
    output logic [3:0] puntaje_j2
);

    logic jugador_r;
    logic [3:0] puntaje1_r, puntaje2_r;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            jugador_r  <= 1'b0;
            puntaje1_r <= 4'd0;
            puntaje2_r <= 4'd0;
        end else begin
            if (cambiar_turno)
                jugador_r <= ~jugador_r;

            if (incrementar_punto) begin
                if (!jugador_r && puntaje1_r != 4'd8)
                    puntaje1_r <= puntaje1_r + 4'd1;
                else if (jugador_r && puntaje2_r != 4'd8)
                    puntaje2_r <= puntaje2_r + 4'd1;
            end
        end
    end

    assign jugador_actual = jugador_r;
    assign puntaje_j1     = puntaje1_r;
    assign puntaje_j2     = puntaje2_r;

endmodule

