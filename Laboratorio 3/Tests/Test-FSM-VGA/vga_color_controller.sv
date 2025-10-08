module vga_color_controller (
    input  logic clk,
    input  logic reset,
    input  logic [9:0] x_pos,      // Posición horizontal del píxel
    input  logic [9:0] y_pos,      // Posición vertical del píxel  
    input  logic color_signal,     // Señal desde la FSM (0=azul, 1=rojo)
    output logic [7:0] vga_red,    // Salida rojo VGA
    output logic [7:0] vga_green,  // Salida verde VGA
    output logic [7:0] vga_blue    // Salida azul VGA
);

    // Parámetros para el cuadrado (ajusta según necesites)
    localparam SQUARE_SIZE = 100;
    localparam SQUARE_X = 270;     // Centrado en 640x480
    localparam SQUARE_Y = 190;
    
    // Señal interna para determinar si estamos en el área del cuadrado
    logic in_square;
    
    // Detectar si las coordenadas actuales están dentro del cuadrado
    assign in_square = (x_pos >= SQUARE_X) && (x_pos < SQUARE_X + SQUARE_SIZE) &&
                       (y_pos >= SQUARE_Y) && (y_pos < SQUARE_Y + SQUARE_SIZE);
    
    // Lógica de color
    always_comb begin
        if (in_square) begin
            // Dentro del cuadrado - color depende de la señal de la FSM
            if (color_signal) begin
                // Rojo
                {vga_red, vga_green, vga_blue} = {8'hFF, 8'h00, 8'h00};
            end else begin
                // Azul  
                {vga_red, vga_green, vga_blue} = {8'h00, 8'h00, 8'hFF};
            end
        end else begin
            // Fuera del cuadrado - fondo negro
            {vga_red, vga_green, vga_blue} = {8'h00, 8'h00, 8'h00};
        end
    end

endmodule