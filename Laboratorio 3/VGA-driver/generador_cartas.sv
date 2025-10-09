// ===========================================================================
// Módulo: generador_cartas
// Descripción: Genera los 8 diseños diferentes de cartas para el juego
//              Cada carta tiene un patrón único identificable
// Entrada: carta_id (0-7), coordenadas relativas dentro de la carta
// Salida: is_pattern (1 si el pixel pertenece al patrón de la carta)
// ===========================================================================

module generador_cartas (
    input  logic [2:0] carta_id,      // ID de la carta (0-7)
    input  logic [9:0] rel_x,         // Coordenada X relativa dentro de la carta
    input  logic [9:0] rel_y,         // Coordenada Y relativa dentro de la carta
    input  logic [9:0] card_width,    // Ancho de la carta
    input  logic [9:0] card_height,   // Alto de la carta
    output logic       is_pattern,    // 1 si este pixel es parte del patrón
    output logic [7:0] pattern_r,     // Color del patrón (RGB)
    output logic [7:0] pattern_g,
    output logic [7:0] pattern_b
);

    logic pattern_active;
    
    always_comb begin
        pattern_active = 1'b0;
        pattern_r = 8'h00;
        pattern_g = 8'h00;
        pattern_b = 8'h00;
        
        case (carta_id)
            // Carta 0: Líneas horizontales (púrpura)
            3'd0: begin
                pattern_active = (rel_y[3:0] < 4'd2);
                pattern_r = 8'h80;
                pattern_g = 8'h00;
                pattern_b = 8'h80;
            end
            
            // Carta 1: Líneas verticales (púrpura)
            3'd1: begin
                pattern_active = (rel_x[3:0] < 4'd2);
                pattern_r = 8'h80;
                pattern_g = 8'h00;
                pattern_b = 8'h80;
            end
            
            // Carta 2: Patrón de ajedrez (cian)
            3'd2: begin
                pattern_active = (rel_x[3] ^ rel_y[3]);
                pattern_r = 8'h00;
                pattern_g = 8'h80;
                pattern_b = 8'h80;
            end
            
            // Carta 3: Línea diagonal (cian)
            3'd3: begin
                pattern_active = (rel_x >= rel_y - 2) && (rel_x <= rel_y + 2);
                pattern_r = 8'h00;
                pattern_g = 8'h80;
                pattern_b = 8'h80;
            end
            
            // Carta 4: Cruz (naranja)
            3'd4: begin
                pattern_active = ((rel_x >= card_width/2 - 3) && (rel_x <= card_width/2 + 3)) ||
                                 ((rel_y >= card_height/2 - 3) && (rel_y <= card_height/2 + 3));
                pattern_r = 8'hFF;
                pattern_g = 8'h80;
                pattern_b = 8'h00;
            end
            
            // Carta 5: Círculo (naranja)
            3'd5: begin
                logic [9:0] dx, dy;
                logic [19:0] dist_sq;
                
                dx = (rel_x > card_width/2) ? (rel_x - card_width/2) : (card_width/2 - rel_x);
                dy = (rel_y > card_height/2) ? (rel_y - card_height/2) : (card_height/2 - rel_y);
                dist_sq = dx*dx + dy*dy;
                
                pattern_active = (dist_sq > 20'd400) && (dist_sq < 20'd625);
                pattern_r = 8'hFF;
                pattern_g = 8'h80;
                pattern_b = 8'h00;
            end
            
            // Carta 6: X (dos diagonales) (rosa)
            3'd6: begin
                pattern_active = ((rel_x >= rel_y - 2) && (rel_x <= rel_y + 2)) ||
                                 ((rel_x >= (card_height - rel_y) - 2) && (rel_x <= (card_height - rel_y) + 2));
                pattern_r = 8'hFF;
                pattern_g = 8'h00;
                pattern_b = 8'h80;
            end
            
            // Carta 7: Puntos (rosa)
            3'd7: begin
                pattern_active = ((rel_x[4:0] < 5'd3) && (rel_y[4:0] < 5'd3));
                pattern_r = 8'hFF;
                pattern_g = 8'h00;
                pattern_b = 8'h80;
            end
            
            default: begin
                pattern_active = 1'b0;
            end
        endcase
    end
    
    assign is_pattern = pattern_active;

endmodule
