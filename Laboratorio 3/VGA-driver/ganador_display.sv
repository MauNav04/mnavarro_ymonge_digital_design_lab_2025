// ===========================================================================
// Módulo: ganador_display
// Descripción: Muestra pantalla de victoria cuando el juego termina (S9_fin_juego)
//              - "J1" en AZUL si jugador 1 ganó (más puntaje)
//              - "J2" en ROJO si jugador 2 ganó (más puntaje)
//              - "EMPATE" en AMARILLO si ambos tienen mismo puntaje
//              
// Usa bitmaps simples de 5×7 pixeles escalados 8× para verse grandes
// ===========================================================================

module ganador_display (
    input  logic [9:0]  x,              // Coordenada X del pixel actual
    input  logic [9:0]  y,              // Coordenada Y del pixel actual
    input  logic [3:0]  state_fsm,      // Estado actual de la FSM
    input  logic [3:0]  puntaje_j1,     // Puntaje del jugador 1
    input  logic [3:0]  puntaje_j2,     // Puntaje del jugador 2
    
    output logic        mostrar,        // 1 = mostrar pantalla de ganador, sobrescribe todo
    output logic [7:0]  r,
    output logic [7:0]  g,
    output logic [7:0]  b
);

    // ========================================================================
    // Detección de estado de fin de juego
    // ========================================================================
    localparam logic [3:0] S9_FIN_JUEGO = 4'd9;
    logic en_fin_juego;
    assign en_fin_juego = (state_fsm == S9_FIN_JUEGO);
    
    // ========================================================================
    // Determinación del ganador por comparación de puntajes
    // ========================================================================
    typedef enum logic [1:0] {
        GANADOR_J1     = 2'd0,
        GANADOR_J2     = 2'd1,
        GANADOR_EMPATE = 2'd2
    } ganador_t;
    
    ganador_t ganador;
    
    always_comb begin
        if (puntaje_j1 > puntaje_j2)
            ganador = GANADOR_J1;
        else if (puntaje_j2 > puntaje_j1)
            ganador = GANADOR_J2;
        else
            ganador = GANADOR_EMPATE;
    end
    
    // ========================================================================
    // Posicionamiento del texto en pantalla (centrado)
    // ========================================================================
    // Pantalla: 640×480
    // Cada letra: 5×7 bitmap, escalado 8× = 40×56 pixeles reales
    // "J1" o "J2": 2 caracteres + espacio = 40+8+40 = 88 pixeles de ancho
    
    localparam int TEXT_START_X = 276;  // (640-88)/2 ≈ 276
    localparam int TEXT_START_Y = 212;  // (480-56)/2 ≈ 212
    localparam int SCALE = 8;           // Factor de escalado (cada pixel del bitmap = 8×8 reales)
    localparam int CHAR_WIDTH = 5;      // Ancho del bitmap en pixeles lógicos
    localparam int CHAR_HEIGHT = 7;     // Alto del bitmap en pixeles lógicos
    localparam int CHAR_SPACING = 8;    // Espacio entre caracteres (en pixeles reales)
    
    // ========================================================================
    // Bitmaps de caracteres (5×7 pixeles)
    // Cada fila es 5 bits, 1=pixel encendido
    // ========================================================================
    
    // Letra "J" (mayúscula)
    logic [4:0] bitmap_J [0:6];
    assign bitmap_J[0] = 5'b01111;  //  ████
    assign bitmap_J[1] = 5'b00010;  //     █
    assign bitmap_J[2] = 5'b00010;  //     █
    assign bitmap_J[3] = 5'b00010;  //     █
    assign bitmap_J[4] = 5'b10010;  // █   █
    assign bitmap_J[5] = 5'b10010;  // █   █
    assign bitmap_J[6] = 5'b01100;  //  ██

    // Número "1"
    logic [4:0] bitmap_1 [0:6];
    assign bitmap_1[0] = 5'b00100;  //   █
    assign bitmap_1[1] = 5'b01100;  //  ██
    assign bitmap_1[2] = 5'b00100;  //   █
    assign bitmap_1[3] = 5'b00100;  //   █
    assign bitmap_1[4] = 5'b00100;  //   █
    assign bitmap_1[5] = 5'b00100;  //   █
    assign bitmap_1[6] = 5'b01110;  //  ███

    // Número "2"
    logic [4:0] bitmap_2 [0:6];
    assign bitmap_2[0] = 5'b01110;  //  ███
    assign bitmap_2[1] = 5'b10001;  // █   █
    assign bitmap_2[2] = 5'b00001;  //     █
    assign bitmap_2[3] = 5'b00110;  //   ██
    assign bitmap_2[4] = 5'b01000;  //  █
    assign bitmap_2[5] = 5'b10000;  // █
    assign bitmap_2[6] = 5'b11111;  // █████

    // ========================================================================
    // Lógica de detección de pixel en caracteres
    // ========================================================================
    logic in_text_area;
    logic [9:0] text_rel_x, text_rel_y;
    logic [2:0] bitmap_row;   // Fila del bitmap (0-6)
    logic [2:0] bitmap_col;   // Columna del bitmap (0-4)
    logic [2:0] char_index;   // Qué caracter: 0='J', 1='1' o '2'
    logic pixel_on;           // El pixel del bitmap está encendido
    
    // Área total del texto: 2 caracteres de 40px + espacio de 8px = 88px de ancho
    localparam int TEXT_WIDTH = 2*CHAR_WIDTH*SCALE + CHAR_SPACING;
    localparam int TEXT_HEIGHT = CHAR_HEIGHT*SCALE;
    
    assign in_text_area = (x >= TEXT_START_X) && (x < TEXT_START_X + TEXT_WIDTH) &&
                          (y >= TEXT_START_Y) && (y < TEXT_START_Y + TEXT_HEIGHT);
    
    assign text_rel_x = x - TEXT_START_X;
    assign text_rel_y = y - TEXT_START_Y;
    
    // Dividir por SCALE para obtener coordenadas lógicas del bitmap
    assign bitmap_row = text_rel_y[9:3];  // / 8
    assign bitmap_col = text_rel_x[2:0];  // Depende del caracter
    
    // Determinar qué caracter estamos renderizando
    always_comb begin
        if (text_rel_x < CHAR_WIDTH*SCALE) begin
            // Primera letra: "J"
            char_index = 3'd0;
        end else if (text_rel_x < CHAR_WIDTH*SCALE + CHAR_SPACING) begin
            // Espacio entre letras
            char_index = 3'd7;  // Valor especial = espacio vacío
        end else begin
            // Segunda letra: "1" o "2"
            if (ganador == GANADOR_J1)
                char_index = 3'd1;  // "1"
            else
                char_index = 3'd2;  // "2"
        end
    end
    
    // Calcular columna del bitmap correcta según el caracter
    logic [2:0] local_col;
    always_comb begin
        if (char_index == 3'd0) begin
            // Primer caracter: columna directa
            local_col = text_rel_x[5:3];  // / 8
        end else if (char_index == 3'd7) begin
            // Espacio: siempre off
            local_col = 3'd0;
        end else begin
            // Segundo caracter: restar offset
            local_col = (text_rel_x - (CHAR_WIDTH*SCALE + CHAR_SPACING)) >> 3;
        end
    end
    
    // Lookup en el bitmap correspondiente
    always_comb begin
        pixel_on = 1'b0;
        
        if (char_index == 3'd0) begin
            // Letra "J"
            if (bitmap_row < 7 && local_col < 5)
                pixel_on = bitmap_J[bitmap_row][4 - local_col];  // Invertir columna (MSB a LSB)
        end else if (char_index == 3'd1) begin
            // Número "1"
            if (bitmap_row < 7 && local_col < 5)
                pixel_on = bitmap_1[bitmap_row][4 - local_col];
        end else if (char_index == 3'd2) begin
            // Número "2"
            if (bitmap_row < 7 && local_col < 5)
                pixel_on = bitmap_2[bitmap_row][4 - local_col];
        end
        // char_index == 7 (espacio) → pixel_on queda en 0
    end
    
    // ========================================================================
    // Colores según el ganador
    // ========================================================================
    logic [7:0] text_r, text_g, text_b;
    logic [7:0] bg_r, bg_g, bg_b;
    
    always_comb begin
        case (ganador)
            GANADOR_J1: begin
                // Azul brillante para J1
                text_r = 8'h00;
                text_g = 8'h80;
                text_b = 8'hFF;
                // Fondo azul muy oscuro
                bg_r = 8'h00;
                bg_g = 8'h10;
                bg_b = 8'h40;
            end
            GANADOR_J2: begin
                // Rojo brillante para J2
                text_r = 8'hFF;
                text_g = 8'h20;
                text_b = 8'h20;
                // Fondo rojo muy oscuro
                bg_r = 8'h40;
                bg_g = 8'h10;
                bg_b = 8'h10;
            end
            GANADOR_EMPATE: begin
                // Amarillo para empate (no debería pasar si el juego tiene 8 pares)
                text_r = 8'hFF;
                text_g = 8'hFF;
                text_b = 8'h00;
                // Fondo gris
                bg_r = 8'h30;
                bg_g = 8'h30;
                bg_b = 8'h30;
            end
            default: begin
                text_r = 8'hFF;
                text_g = 8'hFF;
                text_b = 8'hFF;
                bg_r = 8'h00;
                bg_g = 8'h00;
                bg_b = 8'h00;
            end
        endcase
    end
    
    // ========================================================================
    // Salida final
    // ========================================================================
    always_comb begin
        if (en_fin_juego) begin
            mostrar = 1'b1;
            
            if (in_text_area && pixel_on) begin
                // Mostrar letra en color del ganador
                r = text_r;
                g = text_g;
                b = text_b;
            end else begin
                // Fondo de pantalla de victoria
                r = bg_r;
                g = bg_g;
                b = bg_b;
            end
        end else begin
            // No estamos en fin de juego, no mostrar nada
            mostrar = 1'b0;
            r = 8'h00;
            g = 8'h00;
            b = 8'h00;
        end
    end

endmodule
