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
    //    Se resetea con reset O clear para sincronización perfecta
    logic tick_1Hz;
    logic reset_or_clear;
    assign reset_or_clear = reset || clear;
    
    divisor_1hz_50m #(.TARGET(DIV_TARGET)) udiv (
        .clk_50m (clk_50m),
        .reset   (reset_or_clear),  // ← Resetear divisor con reset O clear
        .tick_1Hz(tick_1Hz)
    );
    assign pulso_1hz = tick_1Hz;

    // 2) Contador 0..15 sincrónico (SIMPLIFICADO PARA DEBUG)
    //    Ignora clear temporalmente para ver si tick_1Hz funciona
    logic [3:0] count_up;
    
    always_ff @(posedge clk_50m or posedge reset) begin
        if (reset) begin
            count_up <= 4'd0;
        end else if (tick_1Hz) begin
            // Incrementar SIEMPRE que haya tick (ignora clear)
            if (count_up < 4'd15) begin
                count_up <= count_up + 4'd1;
            end else begin
                count_up <= 4'd0;  // Vuelve a 0 cuando llega a 15
            end
        end
    end

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
