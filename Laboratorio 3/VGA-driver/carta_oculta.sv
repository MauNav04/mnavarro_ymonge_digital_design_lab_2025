
// Módulo para carta_oculta
// Genera el diseño del reverso de las cartas cuando estan ocultas


module carta_oculta (
    input  logic [9:0] rel_x,         // Coordenada X relativa dentro de la carta
    input  logic [9:0] rel_y,         // Coordenada Y relativa dentro de la carta
    input  logic [9:0] card_width,    // Ancho de la carta
    input  logic [9:0] card_height,   // Alto de la carta
    output logic       is_pattern,    // 1 si este pixel es parte del patrón
    output logic [7:0] back_r,        // Color de fondo
    output logic [7:0] back_g,
    output logic [7:0] back_b
);

    // Patrón de rombos/diamantes pequeños repetidos
    logic [9:0] cx, cy;
    logic [9:0] dx, dy;
    logic in_diamond;
    
    always_comb begin
        // Centros de los rombos cada 20 píxeles
        cx = rel_x % 20;
        cy = rel_y % 20;
        
        // Distancia Manhattan desde el centro del rombo
        dx = (cx > 10) ? (cx - 10) : (10 - cx);
        dy = (cy > 10) ? (cy - 10) : (10 - cy);
        
        // Rombo si la suma de distancias es menor a 7
        in_diamond = (dx + dy) < 7;
        
        // Fondo azul oscuro
        back_r = 8'h10;
        back_g = 8'h30;
        back_b = 8'h60;
        
        // Patrón en azul claro
        if (in_diamond) begin
            back_r = 8'h30;
            back_g = 8'h50;
            back_b = 8'h90;
        end
        
        is_pattern = 1'b1; 
    end

endmodule
