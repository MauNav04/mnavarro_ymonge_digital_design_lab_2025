// ===========================================================================
// Módulo: cursor_overlay
// Descripción: Genera un borde dorado brillante alrededor de la carta seleccionada
//              Indica visualmente dónde está el cursor del jugador
// ===========================================================================

module cursor_overlay (
    input  logic [9:0] rel_x,         // Coordenada X relativa dentro de la carta
    input  logic [9:0] rel_y,         // Coordenada Y relativa dentro de la carta
    input  logic [9:0] card_width,    // Ancho de la carta
    input  logic [9:0] card_height,   // Alto de la carta
    output logic       is_cursor_border // 1 si este pixel es parte del borde del cursor
);

    // Borde dorado de 5 píxeles de grosor
    logic outer_border, inner_border;
    
    always_comb begin
        // Borde exterior (5px desde el borde)
        outer_border = (rel_x < 5) || (rel_x >= card_width - 5) ||
                       (rel_y < 5) || (rel_y >= card_height - 5);
        
        // Borde interior (para hacer un marco de 2px de grosor)
        inner_border = (rel_x < 2) || (rel_x >= card_width - 2) ||
                       (rel_y < 2) || (rel_y >= card_height - 2);
        
        // Solo el área entre ambos bordes
        is_cursor_border = outer_border && !inner_border;
    end

endmodule
