// Módulo: Renderiza la matriz de tiles usando los sprites de BRAM
module tile_renderer (
    input  logic clk,
    input  logic reset,
    input  logic [9:0] x_pos,         // Posición del píxel actual
    input  logic [9:0] y_pos,
    output logic [7:0] vga_red,
    output logic [7:0] vga_green,
    output logic [7:0] vga_blue
);

    // Parámetros configurables
    localparam TILE_SIZE = 16;        // Cada sprite es 16x16
    localparam GRID_SIZE = 4;         // Matriz 4x4
    localparam START_X = 240;         // Posición inicial X (centrado en 640)
    localparam START_Y = 176;         // Posición inicial Y (centrado en 480)
    
    // Señales de pipeline (BRAM tiene 1 ciclo de latencia)
    logic [9:0] x_delay, y_delay;
    logic in_grid_area, in_grid_area_d1;
    
    // Calcular posición relativa en el grid
    logic [9:0] rel_x, rel_y;
    assign rel_x = x_pos - START_X;
    assign rel_y = y_pos - START_Y;
    
    // Determinar si estamos en el área del grid (4x4 tiles de 16x16 = 64x64 total)
    assign in_grid_area = (x_pos >= START_X) && (x_pos < START_X + (GRID_SIZE * TILE_SIZE)) &&
                          (y_pos >= START_Y) && (y_pos < START_Y + (GRID_SIZE * TILE_SIZE));
    
    // Calcular índice del tile (0-15)
    logic [1:0] tile_x, tile_y;   // Coordenadas del tile en el grid
    logic [3:0] tile_index;
    assign tile_x = rel_x[5:4];   // div 16
    assign tile_y = rel_y[5:4];   // div 16
    assign tile_index = {tile_y, tile_x};  // índice lineal
    
    // Calcular posición dentro del sprite (0-15 en X y Y)
    logic [3:0] sprite_x, sprite_y;
    logic [7:0] sprite_pixel_addr;
    assign sprite_x = rel_x[3:0]; // mod 16
    assign sprite_y = rel_y[3:0]; // mod 16
    assign sprite_pixel_addr = {sprite_y, sprite_x};  // índice lineal en sprite
    
    // Instancia de BRAM de mapa de tiles
    logic [1:0] tile_id;
    tile_map_bram tile_map (
        .clk(clk),
        .tile_addr(tile_index),
        .tile_id(tile_id)
    );
    
    // Instancia de BRAM de sprites
    logic [23:0] pixel_color;
    sprite_bram sprites (
        .clk(clk),
        .sprite_id(tile_id),
        .pixel_addr(sprite_pixel_addr),
        .pixel_color(pixel_color)
    );
    
    // Pipeline de delays para compensar latencia de BRAM (2 ciclos)
    always_ff @(posedge clk) begin
        if (reset) begin
            x_delay <= '0;
            y_delay <= '0;
            in_grid_area_d1 <= 1'b0;
        end else begin
            // Delay 1
            x_delay <= x_pos;
            y_delay <= y_pos;
            in_grid_area_d1 <= in_grid_area;
        end
    end
    
    // Salida de color
    always_ff @(posedge clk) begin
        if (reset) begin
            {vga_red, vga_green, vga_blue} <= 24'h000000;
        end else begin
            if (in_grid_area_d1) begin
                // Mostrar el píxel del sprite
                {vga_red, vga_green, vga_blue} <= pixel_color;
            end else begin
                // Fondo negro fuera del grid
                {vga_red, vga_green, vga_blue} <= 24'h000000;
            end
        end
    end

endmodule