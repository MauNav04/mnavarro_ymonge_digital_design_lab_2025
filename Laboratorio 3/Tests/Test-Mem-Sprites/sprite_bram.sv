// Módulo: Almacena 4 sprites de 16x16 en BRAM
module sprite_bram (
    input  logic clk,
    input  logic [1:0]  sprite_id,    // 0-3: qué sprite
    input  logic [7:0]  pixel_addr,   // 0-255: posición dentro del sprite (16x16)
    output logic [23:0] pixel_color   // RGB color del píxel
);

    // BRAM para 4 sprites de 16x16 = 1024 píxeles total
    // Dirección: {sprite_id[1:0], pixel_addr[7:0]} = 10 bits
    logic [23:0] sprite_mem [0:1023];
    
    // Inicialización de sprites (colores planos para empezar)
    initial begin
        integer i;
        
        // Sprite 0: Rojo (0-255)
        for (i = 0; i < 256; i = i + 1) begin
            sprite_mem[i] = 24'hFF0000;
        end
        
        // Sprite 1: Verde (256-511)
        for (i = 256; i < 512; i = i + 1) begin
            sprite_mem[i] = 24'h00FF00;
        end
        
        // Sprite 2: Azul (512-767)
        for (i = 512; i < 768; i = i + 1) begin
            sprite_mem[i] = 24'h0000FF;
        end
        
        // Sprite 3: Amarillo (768-1023)
        for (i = 768; i < 1024; i = i + 1) begin
            sprite_mem[i] = 24'hFFFF00;
        end
    end
    
    // Lectura síncrona
    logic [9:0] full_addr;
    assign full_addr = {sprite_id, pixel_addr};
    
    always_ff @(posedge clk) begin
        pixel_color <= sprite_mem[full_addr];
    end

endmodule