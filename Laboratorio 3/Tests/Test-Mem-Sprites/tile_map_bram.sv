// Módulo: Almacena la matriz 4x4 de tiles en BRAM
module tile_map_bram (
    input  logic clk,
    input  logic [3:0] tile_addr,  // 0-15 para matriz 4x4
    output logic [1:0] tile_id     // 0-3: qué sprite usar
);

    // BRAM para almacenar 16 tiles (4x4)
    // Cada tile es un índice de 2 bits (0-3)
    logic [1:0] tile_map [0:15];
    
    // Inicialización de la matriz 4x4
    // Puedes cambiar estos valores o cargarlos dinámicamente
    initial begin
        // Ejemplo de patrón:
        // 0 1 2 3
        // 1 2 3 0
        // 2 3 0 1
        // 3 0 1 2
        tile_map[0]  = 2'd0;  tile_map[1]  = 2'd1;  tile_map[2]  = 2'd2;  tile_map[3]  = 2'd3;
        tile_map[4]  = 2'd1;  tile_map[5]  = 2'd2;  tile_map[6]  = 2'd3;  tile_map[7]  = 2'd0;
        tile_map[8]  = 2'd2;  tile_map[9]  = 2'd3;  tile_map[10] = 2'd0;  tile_map[11] = 2'd1;
        tile_map[12] = 2'd3;  tile_map[13] = 2'd0;  tile_map[14] = 2'd1;  tile_map[15] = 2'd2;
    end
    
    // Lectura síncrona (característica de BRAM)
    always_ff @(posedge clk) begin
        tile_id <= tile_map[tile_addr];
    end

endmodule