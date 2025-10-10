
module fsm_cartas (
    input  logic clk,
    input  logic rst,               // reset global (sincrono)

    // Entradas de control 
    input  logic selec,             // botón OK
    input  logic valido,            // carta es seleccionable
    input  logic posicion_igual,    // misma que la 1ra seleccion
    input  logic match,             // coincidencia de cartas
    input  logic pares_agotados,    // no quedan pares
    input  logic timeout,           // se agotaron 15 s
    input  logic carta_random,      // RNG entrego carta valida

    // Salidas 
    output logic start_15s,
    output logic clear_15s,
    output logic latch1,
    output logic latch2,
    output logic reveal1,
    output logic reveal2,
    output logic esconder_par,
    output logic lock_par,
    output logic incrementar_punto,
    output logic cambiar_turno,
    output logic carta_random_start,

    // se puede usar para debugs
    output logic [3:0] state_dbg
);

    
    // Enumeracion de estados (4 bits)
 
    typedef enum logic [3:0] {
        S0_inicio    = 4'd0,
        S1_espera    = 4'd1,
        S2_guardar1  = 4'd2,
        S3_revela1   = 4'd3,
        S4_guardar2  = 4'd4,
        S5_revela2   = 4'd5,
        S6_check     = 4'd6,
        S7_random1   = 4'd7,
        S8_random2   = 4'd8,
        S9_fin_juego = 4'd9
    } state_t;

    state_t ps, ns;


    // Registro de estado (reset SINCRONO) de cualquier estado nos dirigimos a S0

    always_ff @(posedge clk) begin
        if (rst) ps <= S0_inicio;
        else     ps <= ns;
    end


    // Lógica de próximo estado
    always_comb begin
        ns = ps;

        unique case (ps)
            // 1 ciclo → S1_espera
            S0_inicio:     ns = S1_espera;

            // Prioridad: timeout > selec&valido > quedarse
            S1_espera: begin
                if (timeout)                 ns = S7_random1;
                else if (selec && valido)    ns = S2_guardar1;
                else                          ns = S1_espera;
            end

            // 1 ciclo → S3_revela1
            S2_guardar1:   ns = S3_revela1;

            // Si hay timeout, la 2a sera aleatoria
            S3_revela1:    ns = (timeout) ? S8_random2 : S4_guardar2;

            // Prioridad: timeout > seleccion valida distinta
            S4_guardar2: begin
                if (timeout)                                 ns = S8_random2;
                else if (selec && valido && !posicion_igual) ns = S5_revela2;
                else                                          ns = S4_guardar2;
            end

            // 1 ciclo → S6_check
            S5_revela2:    ns = S6_check;

            // Decidir y volver a S1 o terminar
            S6_check: begin
                if (match && pares_agotados) ns = S9_fin_juego;
                else                          ns = S1_espera; // match (no fin) o no-match
            end

            // Espera carta aleatoria para 1ra
            S7_random1:    ns = (carta_random) ? S2_guardar1 : S7_random1;

            // Espera carta aleatoria para 2da
            S8_random2:    ns = (carta_random) ? S5_revela2  : S8_random2;

            // Fin del juego hasta reset
            S9_fin_juego:  ns = S9_fin_juego;

            default:       ns = S0_inicio;
        endcase
    end

 
    // Salidas (por estado)
   
    always_comb begin
        // default 0
        start_15s          = 1'b0;
        clear_15s          = 1'b0;
        latch1             = 1'b0;
        latch2             = 1'b0;
        reveal1            = 1'b0;
        reveal2            = 1'b0;
        esconder_par       = 1'b0;
        lock_par           = 1'b0;
        incrementar_punto  = 1'b0;
        cambiar_turno      = 1'b0;
        carta_random_start = 1'b0;

        unique case (ps)
            S0_inicio:   clear_15s = 1'b1;

            S1_espera:   start_15s = 1'b1;

            S2_guardar1: begin
                latch1    = 1'b1;
                start_15s = 1'b1;  // ← Mantener temporizador activo
            end

            S3_revela1: begin
                reveal1   = 1'b1;
                start_15s = 1'b1;  // ← Mantener temporizador activo
            end

            S4_guardar2: start_15s = 1'b1;  // ← Mantener temporizador activo

            S5_revela2: begin
                reveal2   = 1'b1;
                latch2    = 1'b1;
                start_15s = 1'b1;  // ← Mantener temporizador activo
            end

            S6_check: begin
                clear_15s = 1'b1;
                if (match) begin
                    lock_par          = 1'b1;
                    incrementar_punto = 1'b1;
                    // si pares_agotados=1, la transicion va a S9; si no, a S1
                end else begin
                    esconder_par = 1'b1;
                    cambiar_turno = 1'b1;
                end
            end

            S7_random1:  carta_random_start = 1'b1;
            S8_random2:  carta_random_start = 1'b1;

            S9_fin_juego: /* mostrar ganador fuera de la FSM */ ;

            default: /* nada */;
        endcase
    end

    assign state_dbg = ps;

endmodule
