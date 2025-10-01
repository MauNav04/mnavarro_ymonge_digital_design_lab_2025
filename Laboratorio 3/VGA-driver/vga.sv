`timescale 1ns/1ps
`default_nettype none

// Top-level
module vga (
    input  logic        clk,      // 50 MHz board clock
    input  logic        reset,    // async active-high
    output logic        vgaclk,   // 25 MHz VGA pixel clock
    output logic        hsync,
    output logic        vsync,
    output logic        sync_b,   // keep 0 for modern monitors
    output logic        blank_b,  // high during active video in this design
    output logic [7:0]  r, g, b
);

    // divide 50 MHz by 2 -> ~25 MHz pixel clock
    always_ff @(posedge clk or posedge reset) begin
        if (reset) vgaclk <= 1'b0;
        else       vgaclk <= ~vgaclk;
    end

    logic [9:0] x, y;

    vgaController vgaCont (
        .vgaclk (vgaclk),
        .reset  (reset),
        .hsync  (hsync),
        .vsync  (vsync),
        .sync_b (sync_b),
        .blank_b(blank_b),
        .hcnt   (x),
        .vcnt   (y)
    );

    videoGen videoGen_i (
        .x(x), .y(y), .r(r), .g(g), .b(b)
    );

endmodule


// 640x480@60 timing (25.175 MHz nominal; works with 25.000 on most monitors)
module vgaController #(
    parameter int unsigned HBP     = 10'd48,   // back porch
    parameter int unsigned HACTIVE = 10'd640,  // visible
    parameter int unsigned HFP     = 10'd16,   // front porch
    parameter int unsigned HSYN    = 10'd96,   // hsync
    parameter int unsigned HMAX    = HBP + HACTIVE + HFP + HSYN, // 800 total

    parameter int unsigned VBP     = 10'd33,   // back porch (33 works well)
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

    // horizontal/vertical counters
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

    // syncs are active low in VGA
    assign hsync  = ~((hcnt >= (HACTIVE + HFP))  && (hcnt < (HACTIVE + HFP + HSYN)));
    assign vsync  = ~((vcnt >= (VACTIVE + VFP)) && (vcnt < (VACTIVE + VFP + VSYN)));
    assign sync_b = 1'b0; // keep low for modern monitors

    // active video region
    logic visible;
    assign visible = (hcnt < HACTIVE) && (vcnt < VACTIVE);

    assign blank_b = visible;

endmodule


module videoGen (
    input  logic [9:0] x,
    input  logic [9:0] y,
    output logic [7:0] r,
    output logic [7:0] g,
    output logic [7:0] b
);
    // Parámetros de las cartas: 70x100 píxeles cada una
    parameter int CARD_WIDTH  = 70;
    parameter int CARD_HEIGHT = 100;
    parameter int SPACING     = 10;
    parameter int START_X     = 40;
    parameter int START_Y_TOP = 50;
    parameter int START_Y_BOT = 280;

    // Señales para detectar en qué carta estamos
    logic [7:0] in_card;
    logic [9:0] card_x, card_y;  // coordenadas relativas dentro de la carta
    logic [2:0] card_num;
    
    // Señales de diseño
    logic is_border;
    logic is_corner;
    logic is_pattern;
    
    // Detectar cartas manualmente (fila superior: 0-3)
    assign in_card[0] = (x >= START_X) && (x < START_X + CARD_WIDTH) && 
                        (y >= START_Y_TOP) && (y < START_Y_TOP + CARD_HEIGHT);
    assign in_card[1] = (x >= START_X + (CARD_WIDTH + SPACING)) && (x < START_X + 2*(CARD_WIDTH + SPACING) - SPACING) && 
                        (y >= START_Y_TOP) && (y < START_Y_TOP + CARD_HEIGHT);
    assign in_card[2] = (x >= START_X + 2*(CARD_WIDTH + SPACING)) && (x < START_X + 3*(CARD_WIDTH + SPACING) - SPACING) && 
                        (y >= START_Y_TOP) && (y < START_Y_TOP + CARD_HEIGHT);
    assign in_card[3] = (x >= START_X + 3*(CARD_WIDTH + SPACING)) && (x < START_X + 4*(CARD_WIDTH + SPACING) - SPACING) && 
                        (y >= START_Y_TOP) && (y < START_Y_TOP + CARD_HEIGHT);
    
    // Fila inferior (cartas 4-7)
    assign in_card[4] = (x >= START_X) && (x < START_X + CARD_WIDTH) && 
                        (y >= START_Y_BOT) && (y < START_Y_BOT + CARD_HEIGHT);
    assign in_card[5] = (x >= START_X + (CARD_WIDTH + SPACING)) && (x < START_X + 2*(CARD_WIDTH + SPACING) - SPACING) && 
                        (y >= START_Y_BOT) && (y < START_Y_BOT + CARD_HEIGHT);
    assign in_card[6] = (x >= START_X + 2*(CARD_WIDTH + SPACING)) && (x < START_X + 3*(CARD_WIDTH + SPACING) - SPACING) && 
                        (y >= START_Y_BOT) && (y < START_Y_BOT + CARD_HEIGHT);
    assign in_card[7] = (x >= START_X + 3*(CARD_WIDTH + SPACING)) && (x < START_X + 4*(CARD_WIDTH + SPACING) - SPACING) && 
                        (y >= START_Y_BOT) && (y < START_Y_BOT + CARD_HEIGHT);
    
    // Determinar número de carta y coordenadas relativas
    always_comb begin
        card_num = 3'd0;
        card_x = 10'd0;
        card_y = 10'd0;
        
        for (int i = 0; i < 8; i++) begin
            if (in_card[i]) begin
                card_num = i[2:0];
                if (i < 4) begin
                    card_x = x - (START_X + i * (CARD_WIDTH + SPACING));
                    card_y = y - START_Y_TOP;
                end else begin
                    card_x = x - (START_X + (i-4) * (CARD_WIDTH + SPACING));
                    card_y = y - START_Y_BOT;
                end
            end
        end
    end
    
    // Detector de borde (marco de 3 píxeles)
    assign is_border = (card_x < 3) || (card_x >= CARD_WIDTH-3) || 
                       (card_y < 3) || (card_y >= CARD_HEIGHT-3);
    
    // Detector de esquinas (10x10 píxeles en las esquinas)
    assign is_corner = ((card_x < 10 && card_y < 10) ||                          // superior izq
                        (card_x >= CARD_WIDTH-10 && card_y < 10) ||              // superior der
                        (card_x < 10 && card_y >= CARD_HEIGHT-10) ||             // inferior izq
                        (card_x >= CARD_WIDTH-10 && card_y >= CARD_HEIGHT-10));  // inferior der
    
    // Generador de patrones según el número de carta
    always_comb begin
        is_pattern = 1'b0;
        
        case (card_num)
            3'd0: begin // Líneas horizontales
                is_pattern = (card_y[3:0] < 4'd2);
            end
            
            3'd1: begin // Líneas verticales
                is_pattern = (card_x[3:0] < 4'd2);
            end
            
            3'd2: begin // Tablero de ajedrez
                is_pattern = (card_x[3] ^ card_y[3]);
            end
            
            3'd3: begin // Diagonal principal
                is_pattern = (card_x >= card_y - 2) && (card_x <= card_y + 2);
            end
            
            3'd4: begin // Cruz central
                is_pattern = ((card_x >= CARD_WIDTH/2 - 3) && (card_x <= CARD_WIDTH/2 + 3)) ||
                            ((card_y >= CARD_HEIGHT/2 - 3) && (card_y <= CARD_HEIGHT/2 + 3));
            end
            
            3'd5: begin // Círculo (aproximado)
                logic [9:0] dx, dy;
                dx = (card_x > CARD_WIDTH/2) ? (card_x - CARD_WIDTH/2) : (CARD_WIDTH/2 - card_x);
                dy = (card_y > CARD_HEIGHT/2) ? (card_y - CARD_HEIGHT/2) : (CARD_HEIGHT/2 - card_y);
                is_pattern = ((dx*dx + dy*dy) > 10'd400) && ((dx*dx + dy*dy) < 10'd625);
            end
            
            3'd6: begin // Diagonales cruzadas
                is_pattern = ((card_x >= card_y - 2) && (card_x <= card_y + 2)) ||
                            ((card_x >= (CARD_HEIGHT - card_y) - 2) && (card_x <= (CARD_HEIGHT - card_y) + 2));
            end
            
            3'd7: begin // Puntos en patrón
                is_pattern = ((card_x[4:0] < 5'd3) && (card_y[4:0] < 5'd3));
            end
        endcase
    end
    
    // Asignación de colores
    always_comb begin
        if (|in_card) begin
            // Fondo blanco de la carta
            r = 8'hF0;
            g = 8'hF0;
            b = 8'hF0;
            
            // Borde negro
            if (is_border) begin
                r = 8'h00;
                g = 8'h00;
                b = 8'h00;
            end
            // Esquinas de color según la carta
            else if (is_corner) begin
                case (card_num[1:0])
                    2'd0: begin r = 8'hFF; g = 8'h00; b = 8'h00; end // Rojo
                    2'd1: begin r = 8'h00; g = 8'hFF; b = 8'h00; end // Verde
                    2'd2: begin r = 8'h00; g = 8'h00; b = 8'hFF; end // Azul
                    2'd3: begin r = 8'hFF; g = 8'hFF; b = 8'h00; end // Amarillo
                endcase
            end
            // Patrón de la carta
            else if (is_pattern) begin
                case (card_num[2:1])
                    2'd0: begin r = 8'h80; g = 8'h00; b = 8'h80; end // Púrpura
                    2'd1: begin r = 8'h00; g = 8'h80; b = 8'h80; end // Cian
                    2'd2: begin r = 8'hFF; g = 8'h80; b = 8'h00; end // Naranja
                    2'd3: begin r = 8'hFF; g = 8'h00; b = 8'h80; end // Rosa
                endcase
            end
        end else begin
            // Fondo gris oscuro
            r = 8'h20;
            g = 8'h20;
            b = 8'h30;
        end
    end

endmodule

`default_nettype wire