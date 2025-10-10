module temporizador_15s #(
    parameter [25:0] DIV_TARGET = 26'd49_999_999 // 50 MHz -> 1 Hz real
) (
    input  logic clk_50m,
    input  logic reset,        // activo alto - reset global
    input  logic start,        // NO USADO - mantenido para compatibilidad con juego_memoria
    input  logic clear,        // mantiene el contador en 0 mientras esté en 1 (como el diseño original)
    output logic timeout,      // se alcanzó el límite (count_up == 15, display muestra 0)
    output logic pulso_1hz,    // pulso de 1 Hz disponible para otros módulos
    output logic aL,bL,cL,dL,eL,fL,gL,
    output logic aR,bR,cR,dR,eR,fR,gR
);
    // 1) Divisor de frecuencia 50MHz -> 1Hz (genera pulso de 1 ciclo cada segundo)
    logic tick_1Hz;
    divisor_1hz_50m #(.TARGET(DIV_TARGET)) udiv (
        .clk_50m (clk_50m),
        .reset   (reset),
        .tick_1Hz(tick_1Hz)
    );
    assign pulso_1hz = tick_1Hz;

    // 2) Contador 0..15 (igual que diseño original)
    //    Usa clear como reset continuo: mientras clear=1, el contador se mantiene en 0
    logic [3:0] count_up;
    logic reset_or_clear;
    
    // El contador se resetea con reset global O mientras clear=1
    // Esto replica el comportamiento original donde mantenías el switch presionado
    assign reset_or_clear = reset || clear;
    
    contador_4bit ucnt (
        .btn_clk(tick_1Hz),           // Cuenta con cada pulso de 1Hz
        .reset  (reset_or_clear),     // Reset cuando reset=1 O clear=1
        .count  (count_up)
    );

    // 3) Mostrar 15→0 invertir los 4 bits (igual que diseño original)
    wire A0 = ~count_up[0];
    wire A1 = ~count_up[1];
    wire A2 = ~count_up[2];
    wire A3 = ~count_up[3];
    
    // 4) timeout cuando el contador llega a 15 (display muestra 0)
    assign timeout = (count_up == 4'd15);

    bcd_contador_L uL (
        .A0(A0), .A1(A1), .A2(A2), .A3(A3),
        .a(aL), .b(bL), .c(cL), .d(dL), .e(eL), .f(fL), .g(gL)
    );

    bcd_contador_R uR (
        .A0(A0), .A1(A1), .A2(A2), .A3(A3),
        .a(aR), .b(bR), .c(cR), .d(dR), .e(eR), .f(fR), .g(gR)
    );
endmodule
