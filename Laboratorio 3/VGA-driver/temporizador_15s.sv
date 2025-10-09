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
    //    SOLO se resetea con reset global (NO con clear)
    //    El divisor debe correr libremente para generar ticks regulares
    logic tick_1Hz;
    
    divisor_1hz_50m #(.TARGET(DIV_TARGET)) udiv (
        .clk_50m (clk_50m),
        .reset   (reset),  // ← SOLO reset global, NO clear
        .tick_1Hz(tick_1Hz)
    );
    assign pulso_1hz = tick_1Hz;

    // 2) Contador 0..15 sincrónico - Cuenta cada 1 segundo
    //    NO usa el divisor tick_1Hz (tenía problemas de síntesis)
    //    Implementa su propio divisor de frecuencia
    logic [3:0] count_up;
    logic [25:0] div_counter;
    
    always_ff @(posedge clk_50m or posedge reset) begin
        if (reset) begin
            count_up <= 4'd0;
            div_counter <= 26'd0;
        end else if (clear) begin
            count_up <= 4'd0;
            div_counter <= 26'd0;
        end else begin
            // Contar cada 50 millones de ciclos (1.0 segundo @ 50MHz)
            div_counter <= div_counter + 26'd1;
            if (div_counter >= 26'd49_999_999) begin  // 50M - 1
                div_counter <= 26'd0;
                if (count_up < 4'd15) begin
                    count_up <= count_up + 4'd1;
                end
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
