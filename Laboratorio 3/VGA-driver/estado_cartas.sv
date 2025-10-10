
// Mantiene el estado visible/bloqueado de cada carta del tablero y
// provee las señales que necesita la FSM del juego.
module estado_cartas (
    input  logic clk,
    input  logic reset,

    input  logic reveal1,
    input  logic reveal2,
    input  logic esconder_par,
    input  logic lock_par,

    input  logic [3:0] indice_cursor,
    input  logic [3:0] indice_sel1,
    input  logic [3:0] indice_sel2,
    input  logic [3:0] indice_reveal2,

    output logic valido,           // carta del cursor disponible para seleccionar
    output logic posicion_igual,   // cursor apunta a la misma carta que sel1
    output logic match,            // cartas seleccionadas tienen la misma figura
    output logic pares_agotados,   // no quedan pares por descubrir

    output logic [15:0] cartas_reveladas,
    output logic [15:0] cartas_bloqueadas,
    output logic [3:0] carta_cursor_id,
    output logic [3:0] carta_sel1_id,
    output logic [3:0] carta_sel2_id
);

    logic [15:0] revelada_r, bloqueada_r;
    logic [3:0]  pares_restantes_r;

    logic [15:0] revelada_next, bloqueada_next;
    logic [3:0]  pares_restantes_next;

    logic lock_par_d, esconder_par_d;
    logic [15:0] mask_sel1, mask_sel2, mask_ambas;
    logic [15:0] mask_reveal2;

    // Mapea un índice de 0..15 al identificador de carta (dos cartas por valor)
    function automatic logic [3:0] carta_id(input logic [3:0] idx);
        case (idx)
            4'd0,  4'd1 : carta_id = 4'd0;
            4'd2,  4'd3 : carta_id = 4'd1;
            4'd4,  4'd5 : carta_id = 4'd2;
            4'd6,  4'd7 : carta_id = 4'd3;
            4'd8,  4'd9 : carta_id = 4'd4;
            4'd10, 4'd11: carta_id = 4'd5;
            4'd12, 4'd13: carta_id = 4'd6;
            4'd14, 4'd15: carta_id = 4'd7;
            default:       carta_id = 4'd0;
        endcase
    endfunction

    // Enmascara el bit correspondiente a un índice
    function automatic logic [15:0] mask_idx(input logic [3:0] idx);
        mask_idx = 16'h0001 << idx;
    endfunction

    // Lógica combinacional para los siguientes estados
    always_comb begin
        revelada_next        = revelada_r;
        bloqueada_next       = bloqueada_r;
        pares_restantes_next = pares_restantes_r;

        mask_sel1  = 16'd0;
        mask_sel2  = 16'd0;
        mask_ambas = 16'd0;

        mask_sel1    = mask_idx(indice_sel1);
        mask_sel2    = mask_idx(indice_sel2);
        mask_ambas   = mask_sel1 | mask_sel2;
        mask_reveal2 = mask_idx(indice_reveal2);

        if (reveal1) revelada_next = revelada_next | mask_sel1;
        if (reveal2) revelada_next = revelada_next | mask_reveal2;

        if (esconder_par && !esconder_par_d)
            revelada_next = revelada_next & ~mask_ambas;

        if (lock_par && !lock_par_d) begin
            revelada_next  = revelada_next  | mask_ambas;
            bloqueada_next = bloqueada_next | mask_ambas;
            if (pares_restantes_r != 4'd0)
                pares_restantes_next = pares_restantes_r - 4'd1;
        end
    end

    // Registros principales
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            revelada_r        <= 16'd0;
            bloqueada_r       <= 16'd0;
            pares_restantes_r <= 4'd8;
            lock_par_d        <= 1'b0;
            esconder_par_d    <= 1'b0;
        end else begin
            revelada_r        <= revelada_next;
            bloqueada_r       <= bloqueada_next;
            pares_restantes_r <= pares_restantes_next;
            lock_par_d        <= lock_par;
            esconder_par_d    <= esconder_par;
        end
    end

    // Señales combinacionales de salida
    assign cartas_reveladas  = revelada_r;
    assign cartas_bloqueadas = bloqueada_r;

    assign carta_cursor_id = carta_id(indice_cursor);
    assign carta_sel1_id   = carta_id(indice_sel1);
    assign carta_sel2_id   = carta_id(indice_sel2);

    assign posicion_igual = (indice_cursor == indice_sel1);

    assign valido = ~(bloqueada_r[indice_cursor] | revelada_r[indice_cursor]);

    assign match = (indice_sel1 != indice_sel2) &&
                   revelada_r[indice_sel1]      &&
                   revelada_r[indice_sel2]      &&
                   (carta_sel1_id == carta_sel2_id);

    assign pares_agotados = (pares_restantes_r == 4'd0);

endmodule

