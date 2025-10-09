`timescale 1ns / 1ps

// ===========================================================================
// Testbench Visual para juego_vga_renderer
// Genera un archivo PPM (imagen) para visualizar el renderizado
// ===========================================================================

module tb_juego_vga_visual;

    logic [9:0] x, y;
    logic [1:0] cursor_fila, cursor_columna;
    logic [15:0] cartas_reveladas, cartas_bloqueadas;
    logic [3:0] carta_cursor_id;
    logic [7:0] r, g, b;
    
    // Instancia del renderer
    juego_vga_renderer dut (
        .x                (x),
        .y                (y),
        .cursor_fila      (cursor_fila),
        .cursor_columna   (cursor_columna),
        .cartas_reveladas (cartas_reveladas),
        .cartas_bloqueadas(cartas_bloqueadas),
        .carta_cursor_id  (carta_cursor_id),
        .r                (r),
        .g                (g),
        .b                (b)
    );
    
    // Archivo de salida PPM
    integer file;
    
    initial begin
        // Abrir archivo PPM (formato de imagen)
        file = $fopen("output_vga.ppm", "w");
        $fwrite(file, "P3\n");           // Formato PPM ASCII
        $fwrite(file, "640 480\n");      // Resolución
        $fwrite(file, "255\n");          // Valor máximo de color
        
        // ====================================================================
        // Escenario 1: Todas las cartas ocultas, cursor en (0,0)
        // ====================================================================
        $display("\n=== Generando imagen: Todas las cartas ocultas ===");
        cursor_fila = 2'd0;
        cursor_columna = 2'd0;
        cartas_reveladas = 16'h0000;
        cartas_bloqueadas = 16'h0000;
        carta_cursor_id = 4'd0;
        
        // Generar frame completo (640x480 píxeles)
        for (int row = 0; row < 480; row++) begin
            for (int col = 0; col < 640; col++) begin
                x = col;
                y = row;
                #1; // Esperar 1ns para que se estabilice
                $fwrite(file, "%0d %0d %0d ", r, g, b);
            end
            $fwrite(file, "\n");
        end
        
        $fclose(file);
        $display("✓ Imagen generada: output_vga.ppm");
        $display("  Ábrela con GIMP, Photoshop, o cualquier visor de imágenes");
        
        // ====================================================================
        // Escenario 2: Algunas cartas reveladas
        // ====================================================================
        file = $fopen("output_vga_reveladas.ppm", "w");
        $fwrite(file, "P3\n640 480\n255\n");
        
        $display("\n=== Generando imagen: Algunas cartas reveladas ===");
        cursor_fila = 2'd1;
        cursor_columna = 2'd2;
        cartas_reveladas = 16'b0000_0011_1100_0011;  // Cartas 0,1,2,3,8,9 reveladas
        cartas_bloqueadas = 16'h0000;
        
        for (int row = 0; row < 480; row++) begin
            for (int col = 0; col < 640; col++) begin
                x = col;
                y = row;
                #1;
                $fwrite(file, "%0d %0d %0d ", r, g, b);
            end
            $fwrite(file, "\n");
        end
        
        $fclose(file);
        $display("✓ Imagen generada: output_vga_reveladas.ppm");
        
        // ====================================================================
        // Escenario 3: Algunos pares encontrados (bloqueados)
        // ====================================================================
        file = $fopen("output_vga_bloqueadas.ppm", "w");
        $fwrite(file, "P3\n640 480\n255\n");
        
        $display("\n=== Generando imagen: Pares encontrados ===");
        cursor_fila = 2'd3;
        cursor_columna = 2'd3;
        cartas_reveladas = 16'b1111_1111_1111_1111;  // Todas reveladas
        cartas_bloqueadas = 16'b0000_0011_0000_0011; // Pares 0 y 8-9 bloqueados
        
        for (int row = 0; row < 480; row++) begin
            for (int col = 0; col < 640; col++) begin
                x = col;
                y = row;
                #1;
                $fwrite(file, "%0d %0d %0d ", r, g, b);
            end
            $fwrite(file, "\n");
        end
        
        $fclose(file);
        $display("✓ Imagen generada: output_vga_bloqueadas.ppm");
        
        // ====================================================================
        // Escenario 4: Juego completo (todas bloqueadas)
        // ====================================================================
        file = $fopen("output_vga_completo.ppm", "w");
        $fwrite(file, "P3\n640 480\n255\n");
        
        $display("\n=== Generando imagen: Juego completo ===");
        cursor_fila = 2'd2;
        cursor_columna = 2'd1;
        cartas_reveladas = 16'hFFFF;
        cartas_bloqueadas = 16'hFFFF;  // Todas bloqueadas (verde)
        
        for (int row = 0; row < 480; row++) begin
            for (int col = 0; col < 640; col++) begin
                x = col;
                y = row;
                #1;
                $fwrite(file, "%0d %0d %0d ", r, g, b);
            end
            $fwrite(file, "\n");
        end
        
        $fclose(file);
        $display("✓ Imagen generada: output_vga_completo.ppm");
        
        $display("\n╔════════════════════════════════════════════════════════╗");
        $display("║ TESTBENCH COMPLETADO                                   ║");
        $display("║ Se generaron 4 imágenes PPM:                           ║");
        $display("║   1. output_vga.ppm          - Todas ocultas           ║");
        $display("║   2. output_vga_reveladas.ppm - Algunas reveladas      ║");
        $display("║   3. output_vga_bloqueadas.ppm - Pares encontrados     ║");
        $display("║   4. output_vga_completo.ppm  - Juego terminado        ║");
        $display("╚════════════════════════════════════════════════════════╝");
        
        $finish;
    end

endmodule
