`timescale 1ns / 1ps

module tb_contador_top;

    // Señales del testbench
    logic clk;
    logic btn_increment;
    logic switch_reset;
    logic [5:0] count;
    
    // Señales internas para debugging
    logic btn_clean;
    
    // Instanciar el módulo bajo prueba
    contador_top dut (
        .clk(clk),
        .btn_increment(btn_increment),
        .switch_reset(switch_reset),
        .count(count)
    );
    
    // Acceso a señales internas para debugging
    assign btn_clean = dut.btn_clean;
    
    // Generación del reloj (100MHz -> periodo de 10ns)
    always #5 clk = ~clk;
    
    // Monitor de cambios
    always @(posedge clk) begin
        $display("Tiempo: %0t | clk: %b | btn_raw: %b | btn_clean: %b | reset: %b | count: %d (%b)", 
                 $time, clk, btn_increment, btn_clean, switch_reset, count, count);
    end
    
    // Secuencia de prueba simplificada
    initial begin
        // Configurar archivos de salida
        $dumpfile("contador_debug.vcd");
        $dumpvars(0, tb_contador_top);
        
        $display("=== INICIO DEL DEBUGGING ===");
        
        // Inicializar
        clk = 0;
        btn_increment = 0;
        switch_reset = 1;
        
        // Reset inicial
        #50;
        $display("\n--- LIBERANDO RESET ---");
        switch_reset = 0;
        #100;
        
        $display("\n--- PRIMERA PULSACIÓN ---");
        btn_increment = 1;
        #100;  // Mantener presionado más tiempo
        btn_increment = 0;
        #200;  // Esperar más entre pulsaciones
        
        $display("\n--- SEGUNDA PULSACIÓN ---");
        btn_increment = 1;
        #100;
        btn_increment = 0;
        #200;
        
        $display("\n--- TERCERA PULSACIÓN ---");
        btn_increment = 1;
        #100;
        btn_increment = 0;
        #200;
        
        $display("\n--- CUARTA PULSACIÓN ---");
        btn_increment = 1;
        #100;
        btn_increment = 0;
        #200;
        
        $display("\n--- QUINTA PULSACIÓN ---");
        btn_increment = 1;
        #100;
        btn_increment = 0;
        #200;
        
        $display("\n=== FIN DEL DEBUG ===");
        $finish;
    end

endmodule