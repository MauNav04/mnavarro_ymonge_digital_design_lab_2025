
// Integración completa: FSM + Control + Display VGA


module vga_integrado (
    // Entradas del sistema
    input  logic        clk,           // 50 MHz board clock
    input  logic        reset_n,       // Botón de reset (activo en bajo)
    
    // Controles del juego
    input  logic        mover_adelante,
    input  logic        mover_atras,
    input  logic        modo_vertical,
    input  logic        seleccionar,
    
    // Salidas VGA
    output logic        vgaclk,        // 25 MHz VGA pixel clock
    output logic        hsync,
    output logic        vsync,
    output logic        sync_b,
    output logic        blank_b,
    output logic [7:0]  r, g, b,
    
    // Salidas de 7 segmentos (timer y puntajes)
    output logic        aL, bL, cL, dL, eL, fL, gL,  // Timer izquierdo
    output logic        aR, bR, cR, dR, eR, fR, gR,  // Timer derecho
    output logic        aJ1, bJ1, cJ1, dJ1, eJ1, fJ1, gJ1,  // Puntaje J1
    output logic        aJ2, bJ2, cJ2, dJ2, eJ2, fJ2, gJ2   // Puntaje J2
);

    // Invertir el reset (botón activo en bajo → señal activa en alto)
    logic reset_raw;
    assign reset_raw = ~reset_n;
    
    // Sincronizar y extender el reset (mínimo 10 ciclos)
    logic [3:0] reset_counter;
    logic reset;
    
    always_ff @(posedge clk) begin
        if (reset_raw) begin
            reset_counter <= 4'd10;
            reset <= 1'b1;
        end else if (reset_counter != 4'd0) begin
            reset_counter <= reset_counter - 4'd1;
            reset <= 1'b1;
        end else begin
            reset <= 1'b0;
        end
    end

    // ----------------------------------------------------------
    // Debounce de botones (elimina rebotes mecánicos)
    logic mover_adelante_db, mover_atras_db, seleccionar_db;
    
    debouncer #(.DELAY_CYCLES(12_500_000)) db_adelante (  // 250ms
        .clk       (clk),
        .reset     (reset),
        .btn_in    (mover_adelante),
        .btn_pulse (mover_adelante_db)
    );
    
    debouncer #(.DELAY_CYCLES(12_500_000)) db_atras (
        .clk       (clk),
        .reset     (reset),
        .btn_in    (mover_atras),
        .btn_pulse (mover_atras_db)
    );
    
    debouncer #(.DELAY_CYCLES(12_500_000)) db_seleccionar (
        .clk       (clk),
        .reset     (reset),
        .btn_in    (seleccionar),
        .btn_pulse (seleccionar_db)
    );

    // ---------------------------------------------------------------------------
    // Generación del reloj VGA (25 MHz)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) vgaclk <= 1'b0;
        else       vgaclk <= ~vgaclk;
    end

    // ---------------------------------------------------------------------------
    // Controlador VGA (genera señales de sincronización)
    logic [9:0] x, y;

    vgaController vgaCont (
        .vgaclk  (vgaclk),
        .reset   (reset),
        .hsync   (hsync),
        .vsync   (vsync),
        .sync_b  (sync_b),
        .blank_b (blank_b),
        .hcnt    (x),
        .vcnt    (y)
    );

    // ---------------------------------------------------------------------------
    // Módulo del juego de memoria (FSM + lógica de control)
    logic [1:0]  cursor_fila, cursor_columna;
    logic [3:0]  cursor_indice;
    logic [15:0] cartas_reveladas, cartas_bloqueadas;
    logic [3:0]  carta_cursor_id, carta_sel1_id, carta_sel2_id;
    logic        jugador_actual;
    logic [3:0]  puntaje_j1, puntaje_j2;
    logic [3:0]  state_fsm;  // Estado de la FSM para pantalla de ganador
    logic        timeout, carta_random_start;
    
    juego_memoria u_juego (
        .clk_50m            (clk),
        .reset              (reset),
        .mover_adelante     (mover_adelante_db),    // Con debounce
        .mover_atras        (mover_atras_db),       // Con debounce
        .modo_vertical      (modo_vertical),
        .seleccionar        (seleccionar_db),       // Con debounce
        
        // Salidas de 7 segmentos
        .aL(aL), .bL(bL), .cL(cL), .dL(dL), .eL(eL), .fL(fL), .gL(gL),
        .aR(aR), .bR(bR), .cR(cR), .dR(dR), .eR(eR), .fR(fR), .gR(gR),
        .aJ1(aJ1), .bJ1(bJ1), .cJ1(cJ1), .dJ1(dJ1), .eJ1(eJ1), .fJ1(fJ1), .gJ1(gJ1),
        .aJ2(aJ2), .bJ2(bJ2), .cJ2(cJ2), .dJ2(dJ2), .eJ2(eJ2), .fJ2(fJ2), .gJ2(gJ2),
        
        // Información de estado para VGA
        .cursor_fila        (cursor_fila),
        .cursor_columna     (cursor_columna),
        .cursor_indice      (cursor_indice),
        .cartas_reveladas   (cartas_reveladas),
        .cartas_bloqueadas  (cartas_bloqueadas),
        .carta_cursor_id    (carta_cursor_id),
        .carta_sel1_id      (carta_sel1_id),
        .carta_sel2_id      (carta_sel2_id),
        .jugador_actual     (jugador_actual),
        .puntaje_j1         (puntaje_j1),
        .puntaje_j2         (puntaje_j2),
        .state_fsm          (state_fsm),      
        .timeout            (timeout),
        .carta_random_start (carta_random_start)
    );

    // ---------------------------------------------------------------------------
    // Renderizador VGA del juego
    juego_vga_renderer renderer (
        .x                 (x),
        .y                 (y),
        .cursor_fila       (cursor_fila),
        .cursor_columna    (cursor_columna),
        .cartas_reveladas  (cartas_reveladas),
        .cartas_bloqueadas (cartas_bloqueadas),
        .carta_cursor_id   (carta_cursor_id),
        .state_fsm         (state_fsm),       
        .puntaje_j1        (puntaje_j1),       
        .puntaje_j2        (puntaje_j2),       
        .r                 (r),
        .g                 (g),
        .b                 (b)
    );

endmodule


    // ---------------------------------------------------------------------------
// Controlador VGA 640×480
module vgaController #(
    parameter int unsigned HBP     = 10'd48,   // back porch
    parameter int unsigned HACTIVE = 10'd640,  // visible
    parameter int unsigned HFP     = 10'd16,   // front porch
    parameter int unsigned HSYN    = 10'd96,   // hsync
    parameter int unsigned HMAX    = HBP + HACTIVE + HFP + HSYN, // 800 total

    parameter int unsigned VBP     = 10'd33,   // back porch
    parameter int unsigned VACTIVE = 10'd480,  // visible
    parameter int unsigned VFP     = 10'd10,   // front porch
    parameter int unsigned VSYN    = 10'd2,    // vsync
    parameter int unsigned VMAX    = VBP + VACTIVE + VFP + VSYN  // 525 total
) (
    input  logic       vgaclk,
    input  logic       reset,
    output logic       hsync,
    output logic       vsync,
    output logic       sync_b,
    output logic       blank_b,
    output logic [9:0] hcnt,
    output logic [9:0] vcnt
);

    // Contadores horizontal/vertical
    always_ff @(posedge vgaclk or posedge reset) begin
        if (reset) begin
            hcnt <= '0;
            vcnt <= '0;
        end else begin
            if (hcnt == HMAX-1) begin
                hcnt <= '0;
                if (vcnt == VMAX-1) vcnt <= '0;
                else                vcnt <= vcnt + 10'd1;
            end else begin
                hcnt <= hcnt + 10'd1;
            end
        end
    end

    // Señales de sincronización (activas en bajo)
    assign hsync  = ~((hcnt >= (HACTIVE + HFP))  && (hcnt < (HACTIVE + HFP + HSYN)));
    assign vsync  = ~((vcnt >= (VACTIVE + VFP)) && (vcnt < (VACTIVE + VFP + VSYN)));
    assign sync_b = 1'b0;

    // Región visible
    logic visible;
    assign visible = (hcnt < HACTIVE) && (vcnt < VACTIVE);
    assign blank_b = visible;

endmodule
