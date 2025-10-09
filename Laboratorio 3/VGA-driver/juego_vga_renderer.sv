// ===========================================================================
// Módulo: juego_vga_renderer
// Descripción: Renderiza el juego de memoria completo en VGA 640×480
//              - Grid 4×4 de cartas (16 cartas total)
//              - Muestra cartas ocultas/reveladas/bloqueadas según estado de la FSM
//              - Borde dorado en la carta bajo el cursor
//              - Integración completa con juego_memoria.sv
// ===========================================================================

module juego_vga_renderer (
    input  logic [9:0]  x,                  // Coordenada X del pixel actual
    input  logic [9:0]  y,                  // Coordenada Y del pixel actual
    
    // Entradas desde juego_memoria.sv
    input  logic [1:0]  cursor_fila,        // Fila del cursor (0-3)
    input  logic [1:0]  cursor_columna,     // Columna del cursor (0-3)
    input  logic [15:0] cartas_reveladas,   // Bits de cartas reveladas
    input  logic [15:0] cartas_bloqueadas,  // Bits de cartas bloqueadas (pares encontrados)
    input  logic [3:0]  carta_cursor_id,    // ID de la carta bajo el cursor (0-7)
    
    // Salidas RGB
    output logic [7:0]  r,
    output logic [7:0]  g,
    output logic [7:0]  b
);

    // ========================================================================
    // Parámetros del grid de cartas
    // ========================================================================
    localparam int CARD_WIDTH   = 140;  // Ancho de cada carta
    localparam int CARD_HEIGHT  = 100;  // Alto de cada carta
    localparam int SPACING_H    = 20;   // Espaciado horizontal entre cartas
    localparam int SPACING_V    = 20;   // Espaciado vertical entre cartas
    localparam int START_X      = 20;   // Margen izquierdo
    localparam int START_Y      = 40;   // Margen superior
    
    // ========================================================================
    // Mapeo de índices: cada carta tiene un ID (0-7) que aparece 2 veces
    // Índices 0-1 = ID 0, índices 2-3 = ID 1, etc.
    // ========================================================================
    function automatic logic [2:0] indice_a_carta_id(input logic [3:0] idx);
        case (idx)
            4'd0,  4'd1:  indice_a_carta_id = 3'd0;
            4'd2,  4'd3:  indice_a_carta_id = 3'd1;
            4'd4,  4'd5:  indice_a_carta_id = 3'd2;
            4'd6,  4'd7:  indice_a_carta_id = 3'd3;
            4'd8,  4'd9:  indice_a_carta_id = 3'd4;
            4'd10, 4'd11: indice_a_carta_id = 3'd5;
            4'd12, 4'd13: indice_a_carta_id = 3'd6;
            4'd14, 4'd15: indice_a_carta_id = 3'd7;
            default:      indice_a_carta_id = 3'd0;
        endcase
    endfunction
    
    // ========================================================================
    // Detección de carta actual y cálculo de coordenadas relativas
    // ========================================================================
    logic [15:0] in_card;           // Bit vector: cuál carta contiene este pixel
    logic [3:0]  current_card_idx;  // Índice de la carta actual (0-15)
    logic [2:0]  current_card_id;   // ID de diseño de la carta actual (0-7)
    logic [9:0]  card_rel_x;        // Coordenada X relativa dentro de la carta
    logic [9:0]  card_rel_y;        // Coordenada Y relativa dentro de la carta
    logic        is_in_any_card;
    
    // Coordenadas de inicio de cada carta (precalculadas)
    logic [9:0] card_x_starts [0:3];
    logic [9:0] card_y_starts [0:3];
    
    assign card_x_starts[0] = START_X;
    assign card_x_starts[1] = START_X + (CARD_WIDTH + SPACING_H);
    assign card_x_starts[2] = START_X + 2*(CARD_WIDTH + SPACING_H);
    assign card_x_starts[3] = START_X + 3*(CARD_WIDTH + SPACING_H);
    
    assign card_y_starts[0] = START_Y;
    assign card_y_starts[1] = START_Y + (CARD_HEIGHT + SPACING_V);
    assign card_y_starts[2] = START_Y + 2*(CARD_HEIGHT + SPACING_V);
    assign card_y_starts[3] = START_Y + 3*(CARD_HEIGHT + SPACING_V);
    
    // Detección de cada una de las 16 cartas (grid 4×4)
    genvar row, col;
    generate
        for (row = 0; row < 4; row++) begin : gen_row
            for (col = 0; col < 4; col++) begin : gen_col
                localparam int idx = row * 4 + col;
                
                assign in_card[idx] = (x >= card_x_starts[col]) && 
                                      (x < card_x_starts[col] + CARD_WIDTH) &&
                                      (y >= card_y_starts[row]) && 
                                      (y < card_y_starts[row] + CARD_HEIGHT);
            end
        end
    endgenerate
    
    // Determinar cuál carta es y calcular coordenadas relativas
    always_comb begin
        current_card_idx = 4'd0;
        card_rel_x = 10'd0;
        card_rel_y = 10'd0;
        is_in_any_card = 1'b0;
        
        // Prioridad encodificada: la primera carta que coincida
        if (in_card[0]) begin
            current_card_idx = 4'd0;
            card_rel_x = x - card_x_starts[0];
            card_rel_y = y - card_y_starts[0];
            is_in_any_card = 1'b1;
        end else if (in_card[1]) begin
            current_card_idx = 4'd1;
            card_rel_x = x - card_x_starts[1];
            card_rel_y = y - card_y_starts[0];
            is_in_any_card = 1'b1;
        end else if (in_card[2]) begin
            current_card_idx = 4'd2;
            card_rel_x = x - card_x_starts[2];
            card_rel_y = y - card_y_starts[0];
            is_in_any_card = 1'b1;
        end else if (in_card[3]) begin
            current_card_idx = 4'd3;
            card_rel_x = x - card_x_starts[3];
            card_rel_y = y - card_y_starts[0];
            is_in_any_card = 1'b1;
        end else if (in_card[4]) begin
            current_card_idx = 4'd4;
            card_rel_x = x - card_x_starts[0];
            card_rel_y = y - card_y_starts[1];
            is_in_any_card = 1'b1;
        end else if (in_card[5]) begin
            current_card_idx = 4'd5;
            card_rel_x = x - card_x_starts[1];
            card_rel_y = y - card_y_starts[1];
            is_in_any_card = 1'b1;
        end else if (in_card[6]) begin
            current_card_idx = 4'd6;
            card_rel_x = x - card_x_starts[2];
            card_rel_y = y - card_y_starts[1];
            is_in_any_card = 1'b1;
        end else if (in_card[7]) begin
            current_card_idx = 4'd7;
            card_rel_x = x - card_x_starts[3];
            card_rel_y = y - card_y_starts[1];
            is_in_any_card = 1'b1;
        end else if (in_card[8]) begin
            current_card_idx = 4'd8;
            card_rel_x = x - card_x_starts[0];
            card_rel_y = y - card_y_starts[2];
            is_in_any_card = 1'b1;
        end else if (in_card[9]) begin
            current_card_idx = 4'd9;
            card_rel_x = x - card_x_starts[1];
            card_rel_y = y - card_y_starts[2];
            is_in_any_card = 1'b1;
        end else if (in_card[10]) begin
            current_card_idx = 4'd10;
            card_rel_x = x - card_x_starts[2];
            card_rel_y = y - card_y_starts[2];
            is_in_any_card = 1'b1;
        end else if (in_card[11]) begin
            current_card_idx = 4'd11;
            card_rel_x = x - card_x_starts[3];
            card_rel_y = y - card_y_starts[2];
            is_in_any_card = 1'b1;
        end else if (in_card[12]) begin
            current_card_idx = 4'd12;
            card_rel_x = x - card_x_starts[0];
            card_rel_y = y - card_y_starts[3];
            is_in_any_card = 1'b1;
        end else if (in_card[13]) begin
            current_card_idx = 4'd13;
            card_rel_x = x - card_x_starts[1];
            card_rel_y = y - card_y_starts[3];
            is_in_any_card = 1'b1;
        end else if (in_card[14]) begin
            current_card_idx = 4'd14;
            card_rel_x = x - card_x_starts[2];
            card_rel_y = y - card_y_starts[3];
            is_in_any_card = 1'b1;
        end else if (in_card[15]) begin
            current_card_idx = 4'd15;
            card_rel_x = x - card_x_starts[3];
            card_rel_y = y - card_y_starts[3];
            is_in_any_card = 1'b1;
        end
    end
    
    assign current_card_id = indice_a_carta_id(current_card_idx);
    
    // ========================================================================
    // Estado de la carta actual
    // ========================================================================
    logic is_revelada;
    logic is_bloqueada;
    logic is_oculta;
    logic is_cursor_here;
    
    assign is_revelada   = cartas_reveladas[current_card_idx];
    assign is_bloqueada  = cartas_bloqueadas[current_card_idx];
    assign is_oculta     = ~is_revelada && ~is_bloqueada;
    
    // El cursor está aquí si la fila y columna coinciden
    assign is_cursor_here = (current_card_idx[3:2] == cursor_fila) && 
                            (current_card_idx[1:0] == cursor_columna);
    
    // ========================================================================
    // Generación de patrones
    // ========================================================================
    
    // Carta revelada (diseño frontal)
    logic       pattern_active;
    logic [7:0] pattern_r, pattern_g, pattern_b;
    
    generador_cartas gen_carta (
        .carta_id    (current_card_id),
        .rel_x       (card_rel_x),
        .rel_y       (card_rel_y),
        .card_width  (CARD_WIDTH),
        .card_height (CARD_HEIGHT),
        .is_pattern  (pattern_active),
        .pattern_r   (pattern_r),
        .pattern_g   (pattern_g),
        .pattern_b   (pattern_b)
    );
    
    // Carta oculta (reverso)
    logic       back_active;
    logic [7:0] back_r, back_g, back_b;
    
    carta_oculta gen_reverso (
        .rel_x       (card_rel_x),
        .rel_y       (card_rel_y),
        .card_width  (CARD_WIDTH),
        .card_height (CARD_HEIGHT),
        .is_pattern  (back_active),
        .back_r      (back_r),
        .back_g      (back_g),
        .back_b      (back_b)
    );
    
    // Borde del cursor (dorado)
    logic is_cursor_border;
    
    cursor_overlay gen_cursor (
        .rel_x            (card_rel_x),
        .rel_y            (card_rel_y),
        .card_width       (CARD_WIDTH),
        .card_height      (CARD_HEIGHT),
        .is_cursor_border (is_cursor_border)
    );
    
    // Borde de carta (negro, 3px)
    logic is_card_border;
    assign is_card_border = (card_rel_x < 3) || (card_rel_x >= CARD_WIDTH - 3) ||
                            (card_rel_y < 3) || (card_rel_y >= CARD_HEIGHT - 3);
    
    // Esquinas de color
    logic is_corner;
    assign is_corner = ((card_rel_x < 10 && card_rel_y < 10) ||
                        (card_rel_x >= CARD_WIDTH - 10 && card_rel_y < 10) ||
                        (card_rel_x < 10 && card_rel_y >= CARD_HEIGHT - 10) ||
                        (card_rel_x >= CARD_WIDTH - 10 && card_rel_y >= CARD_HEIGHT - 10));
    
    // Color de esquinas según ID de carta
    logic [7:0] corner_r, corner_g, corner_b;
    always_comb begin
        case (current_card_id[1:0])
            2'd0: begin corner_r = 8'hFF; corner_g = 8'h00; corner_b = 8'h00; end // Rojo
            2'd1: begin corner_r = 8'h00; corner_g = 8'hFF; corner_b = 8'h00; end // Verde
            2'd2: begin corner_r = 8'h00; corner_g = 8'h00; corner_b = 8'hFF; end // Azul
            2'd3: begin corner_r = 8'hFF; corner_g = 8'hFF; corner_b = 8'h00; end // Amarillo
        endcase
    end
    
    // ========================================================================
    // Lógica de renderizado final
    // ========================================================================
    always_comb begin
        if (is_in_any_card) begin
            // Prioridad 1: Borde dorado del cursor (si está aquí)
            if (is_cursor_here && is_cursor_border) begin
                r = 8'hFF;  // Dorado brillante
                g = 8'hD7;
                b = 8'h00;
            end
            // Prioridad 2: Borde negro de la carta
            else if (is_card_border) begin
                r = 8'h00;
                g = 8'h00;
                b = 8'h00;
            end
            // Prioridad 3: Carta bloqueada (par encontrado) - Fondo verde claro
            else if (is_bloqueada) begin
                r = 8'h90;
                g = 8'hFF;
                b = 8'h90;
                // Mantener esquinas de color
                if (is_corner) begin
                    r = corner_r;
                    g = corner_g;
                    b = corner_b;
                end
            end
            // Prioridad 4: Carta revelada - Mostrar diseño
            else if (is_revelada) begin
                // Fondo blanco
                r = 8'hF0;
                g = 8'hF0;
                b = 8'hF0;
                
                // Esquinas de color
                if (is_corner) begin
                    r = corner_r;
                    g = corner_g;
                    b = corner_b;
                end
                // Patrón de la carta
                else if (pattern_active) begin
                    r = pattern_r;
                    g = pattern_g;
                    b = pattern_b;
                end
            end
            // Prioridad 5: Carta oculta - Mostrar reverso
            else begin
                r = back_r;
                g = back_g;
                b = back_b;
            end
        end
        else begin
            // Fondo fuera de las cartas (gris oscuro)
            r = 8'h20;
            g = 8'h20;
            b = 8'h30;
        end
    end

endmodule
