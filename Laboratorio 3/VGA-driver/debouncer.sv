// ===========================================================================
// Módulo: debouncer
// Descripción: Elimina rebotes de botones mecánicos y genera un pulso único
//              Requiere que el botón se mantenga presionado ~250ms para registrar
// ===========================================================================

module debouncer #(
    parameter DELAY_CYCLES = 12_500_000  // ~250ms a 50MHz
) (
    input  logic clk,
    input  logic reset,
    input  logic btn_in,      // Botón sin filtrar
    output logic btn_pulse    // Pulso único de 1 ciclo cuando se detecta presión
);

    logic [23:0] counter;
    logic btn_stable;
    logic btn_stable_prev;
    
    // Detector de flancos
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 24'd0;
            btn_stable <= 1'b0;
            btn_stable_prev <= 1'b0;
        end else begin
            btn_stable_prev <= btn_stable;
            
            if (btn_in) begin
                // Botón presionado: incrementar contador
                if (counter < DELAY_CYCLES) begin
                    counter <= counter + 24'd1;
                end else begin
                    btn_stable <= 1'b1;
                end
            end else begin
                // Botón liberado: resetear
                counter <= 24'd0;
                btn_stable <= 1'b0;
            end
        end
    end
    
    // Generar pulso solo en el flanco de subida de btn_stable
    assign btn_pulse = btn_stable && !btn_stable_prev;

endmodule
