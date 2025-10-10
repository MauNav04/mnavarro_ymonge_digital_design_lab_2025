
// Top de integración para el juego de memoria.
// Conecta la FSM principal, el temporizador, el control del cursor y
// los módulos de estado/puntaje. Los botones de entrada se asumen ya
// sincronizados y filtrados a pulsos de un ciclo.
module juego_memoria #(
    parameter [25:0] TIMER_DIV_TARGET = 26'd49_999_999  // No usado, el temporizador tiene su propio divisor
) (
    input  logic clk_50m,
    input  logic reset,             // reset global del sistema

    input  logic mover_adelante,    // botón para avanzar (derecha o abajo)
    input  logic mover_atras,       // botón para retroceder (izquierda o arriba)
    input  logic modo_vertical,     // switch: 0 horizontal, 1 vertical
    input  logic seleccionar,       // botón OK para la FSM

    // 7 segmentos del temporizador (ánodo común)
    output logic aL,bL,cL,dL,eL,fL,gL,
    output logic aR,bR,cR,dR,eR,fR,gR,

    // 7 segmentos para los puntajes de cada jugador
    output logic aJ1,bJ1,cJ1,dJ1,eJ1,fJ1,gJ1,
    output logic aJ2,bJ2,cJ2,dJ2,eJ2,fJ2,gJ2,

    // Estado del tablero hacia la lógica de video
    output logic [1:0] cursor_fila,
    output logic [1:0] cursor_columna,
    output logic [3:0] cursor_indice,
    output logic [15:0] cartas_reveladas,
    output logic [15:0] cartas_bloqueadas,
    output logic [3:0] carta_cursor_id,
    output logic [3:0] carta_sel1_id,
    output logic [3:0] carta_sel2_id,

    // Información de puntaje/turno
    output logic jugador_actual,
    output logic [3:0] puntaje_j1,
    output logic [3:0] puntaje_j2,

    // Estado de la FSM para detección de fin de juego
    output logic [3:0] state_fsm,

    // Señales útiles para otros módulos
    output logic timeout,
    output logic carta_random_start
);

    // ---------------------------------------------------------------------
    // FSM principal del juego
    // ---------------------------------------------------------------------
    logic start_15s, clear_15s;
    logic latch1, latch2;
    logic reveal1, reveal2;
    logic esconder_par, lock_par;
    logic incrementar_punto, cambiar_turno;
    logic valido, posicion_igual, match, pares_agotados;
    logic rng_listo;
    logic [3:0] rng_indice;
    logic [3:0] state_dbg_interno;
    logic usar_random_reg;
    logic usar_random_comb;
    logic [3:0] indice_random_reg;
    logic [3:0] indice_random_comb;
    logic [3:0] indice_para_latch;
    logic cursor_cargar;

    // ---------------------------------------------------------------------
    // Cursor de selección (apoya carga directa desde RNG)
    // ---------------------------------------------------------------------
    control_cursor u_cursor (
        .clk           (clk_50m),
        .reset         (reset),
        .mover_adelante(mover_adelante),
        .mover_atras   (mover_atras),
        .modo_vertical (modo_vertical),
        .cargar        (cursor_cargar),
        .indice_cargar (rng_indice),
        .fila          (cursor_fila),
        .columna       (cursor_columna),
        .indice        (cursor_indice)
    );

    fsm_cartas u_fsm (
        .clk               (clk_50m),
        .rst               (reset),
        .selec             (seleccionar),
        .valido            (valido),
        .posicion_igual    (posicion_igual),
        .match             (match),
        .pares_agotados    (pares_agotados),
        .timeout           (timeout),
        .carta_random      (rng_listo),
        .start_15s         (start_15s),
        .clear_15s         (clear_15s),
        .latch1            (latch1),
        .latch2            (latch2),
        .reveal1           (reveal1),
        .reveal2           (reveal2),
        .esconder_par      (esconder_par),
        .lock_par          (lock_par),
        .incrementar_punto (incrementar_punto),
        .cambiar_turno     (cambiar_turno),
        .carta_random_start(carta_random_start),
        .state_dbg         (state_dbg_interno)
    );

    // Exportar estado de la FSM
    assign state_fsm = state_dbg_interno;

    // ---------------------------------------------------------------------
    // Temporizador 15 segundos
    // ---------------------------------------------------------------------
    logic pulso_1hz;
    temporizador_15s #(.DIV_TARGET(TIMER_DIV_TARGET)) u_timer (
        .clk_50m (clk_50m),
        .reset   (reset),
        .start   (start_15s),
        .clear   (clear_15s),
        .timeout (timeout),
        .pulso_1hz(pulso_1hz),
        .aL(aL), .bL(bL), .cL(cL), .dL(dL), .eL(eL), .fL(fL), .gL(gL),
        .aR(aR), .bR(bR), .cR(cR), .dR(dR), .eR(eR), .fR(fR), .gR(gR)
    );

    // ---------------------------------------------------------------------
    // Registros para almacenar las cartas seleccionadas
    // ---------------------------------------------------------------------
    logic [3:0] indice_sel1, indice_sel2;
    logic limpiar_indices, clear_indices_d;

    // Limpiar los índices un ciclo después del clear_15s para permitir que
    // la lógica de estado procese lock/esconder con los valores vigentes.
    always_ff @(posedge clk_50m or posedge reset) begin
        if (reset) clear_indices_d <= 1'b0;
        else       clear_indices_d <= clear_15s;
    end

    assign limpiar_indices = reset | clear_indices_d;

    assign cursor_cargar     = rng_listo;
    assign indice_para_latch = usar_random_comb ? indice_random_comb : cursor_indice;

    always_comb begin
        usar_random_comb   = usar_random_reg;
        indice_random_comb = indice_random_reg;

        if (rng_listo) begin
            usar_random_comb   = 1'b1;
            indice_random_comb = rng_indice;
        end else if (usar_random_reg && (latch1 || latch2)) begin
            usar_random_comb   = 1'b0;
        end else if (start_15s) begin
            usar_random_comb   = 1'b0;
        end
    end

    always_ff @(posedge clk_50m or posedge reset) begin
        if (reset) begin
            usar_random_reg   <= 1'b0;
            indice_random_reg <= 4'd0;
        end else begin
            usar_random_reg   <= usar_random_comb;
            indice_random_reg <= indice_random_comb;
        end
    end

    registro_seleccion u_latch1 (
        .clk       (clk_50m),
        .reset     (reset),
        .limpiar   (limpiar_indices),
        .captura   (latch1),
        .indice_in (indice_para_latch),
        .indice_out(indice_sel1)
    );

    registro_seleccion u_latch2 (
        .clk       (clk_50m),
        .reset     (reset),
        .limpiar   (limpiar_indices),
        .captura   (latch2),
        .indice_in (indice_para_latch),
        .indice_out(indice_sel2)
    );

    // ---------------------------------------------------------------------
    // Estado de cartas (reveladas/bloqueadas) y señales auxiliares
    // ---------------------------------------------------------------------
    estado_cartas u_estado (
        .clk             (clk_50m),
        .reset           (reset),
        .reveal1         (reveal1),
        .reveal2         (reveal2),
        .esconder_par    (esconder_par),
        .lock_par        (lock_par),
        .indice_cursor   (cursor_indice),
        .indice_sel1     (indice_sel1),
        .indice_sel2     (indice_sel2),
        .indice_reveal2  (indice_para_latch),  // ← ROLLBACK: volver a indice_para_latch
        .valido          (valido),
        .posicion_igual  (posicion_igual),
        .match           (match),
        .pares_agotados  (pares_agotados),
        .cartas_reveladas(cartas_reveladas),
        .cartas_bloqueadas(cartas_bloqueadas),
        .carta_cursor_id (carta_cursor_id),
        .carta_sel1_id   (carta_sel1_id),
        .carta_sel2_id   (carta_sel2_id)
    );

    generador_carta_random u_rng (
        .clk             (clk_50m),
        .reset           (reset),
        .start           (carta_random_start),
        .cartas_reveladas(cartas_reveladas),
        .cartas_bloqueadas(cartas_bloqueadas),
        .listo           (rng_listo),
        .indice          (rng_indice)
    );

    // ---------------------------------------------------------------------
    // Puntajes y turno actual
    // ---------------------------------------------------------------------
    puntaje_jugadores u_puntaje (
        .clk             (clk_50m),
        .reset           (reset),
        .cambiar_turno   (cambiar_turno),
        .incrementar_punto(incrementar_punto),
        .jugador_actual  (jugador_actual),
        .puntaje_j1      (puntaje_j1),
        .puntaje_j2      (puntaje_j2)
    );

    // ---------------------------------------------------------------------
    // Displays de puntaje (7 segmentos)
    // ---------------------------------------------------------------------
    puntaje_display u_puntajes_seg (
        .puntaje_j1(puntaje_j1),
        .puntaje_j2(puntaje_j2),
        .aJ1(aJ1), .bJ1(bJ1), .cJ1(cJ1), .dJ1(dJ1), .eJ1(eJ1), .fJ1(fJ1), .gJ1(gJ1),
        .aJ2(aJ2), .bJ2(bJ2), .cJ2(cJ2), .dJ2(dJ2), .eJ2(eJ2), .fJ2(fJ2), .gJ2(gJ2)
    );

endmodule





