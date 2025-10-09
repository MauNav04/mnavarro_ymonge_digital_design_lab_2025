

// Genera índices pseudoaleatorios de cartas disponibles.
// Respeta el handshake start/listo: cuando start=1 se inicia la búsqueda
// de una carta válida (no revelada ni bloqueada). Cuando se obtiene un
// índice válido, listo se activa durante un ciclo junto con el valor.
module generador_carta_random (
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic [15:0] cartas_reveladas,
    input  logic [15:0] cartas_bloqueadas,
    output logic listo,
    output logic [3:0] indice
);

    // LFSR simple de 8 bits para variar el punto de partida
    logic [7:0] lfsr;
    logic busy;
    logic [3:0] candidato;
    logic [4:0] intentos;

    logic [15:0] mascara_validos;
    assign mascara_validos = ~(cartas_reveladas | cartas_bloqueadas);

    function automatic logic [7:0] lfsr_next(input logic [7:0] current);
        logic feedback;
        feedback = current[7] ^ current[5] ^ current[4] ^ current[3];
        lfsr_next = (current == 8'd0) ? 8'h1 : {current[6:0], feedback};
    endfunction

    function automatic logic [3:0] primer_valido(input logic [15:0] mask);
        for (int i = 0; i < 16; i++) begin
            if (mask[i]) return i[3:0];
        end
        return 4'd0;
    endfunction

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr      <= 8'h5A;
            busy      <= 1'b0;
            candidato <= 4'd0;
            intentos  <= 5'd0;
            listo     <= 1'b0;
            indice    <= 4'd0;
        end else begin
            listo <= 1'b0;

            // Iniciar búsqueda con el valor del LFSR cuando start pasa a 1
            if (start && !busy) begin
                busy      <= 1'b1;
                candidato <= lfsr[3:0];
                intentos  <= 5'd0;
            end

            if (busy) begin
                if (mascara_validos != 16'd0) begin
                    if (mascara_validos[candidato]) begin
                        indice <= candidato;
                        listo  <= 1'b1;
                        busy   <= 1'b0;
                    end else begin
                        candidato <= candidato + 4'd1;
                        intentos  <= intentos + 5'd1;
                        if (intentos == 5'd15) begin
                            indice <= primer_valido(mascara_validos);
                            listo  <= 1'b1;
                            busy   <= 1'b0;
                        end
                    end
                end else begin
                    indice <= 4'd0;
                    listo  <= 1'b1;
                    busy   <= 1'b0;
                end
            end

            lfsr <= lfsr_next(lfsr);
        end
    end

endmodule

