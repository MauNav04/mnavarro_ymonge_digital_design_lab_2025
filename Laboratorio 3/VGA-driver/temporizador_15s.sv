module temporizador_15s #(
    parameter [25:0] DIV_TARGET = 26'd49_999_999 // 50 MHz -> 1 Hz real
) (
    input  logic clk_50m,
    input  logic reset,        // activo alto - reset global
    input  logic start,        // habilita el conteo
    input  logic clear,        // reinicia el conteo a 15 s
    output logic timeout,      // se alcanzó el límite inferior
    output logic pulso_1hz,    // pulso de 1 Hz disponible para otros módulos
    output logic aL,bL,cL,dL,eL,fL,gL,
    output logic aR,bR,cR,dR,eR,fR,gR
);
    // Divisor de frecuencia (solo se resetea con reset global)
    logic tick_1Hz;
    divisor_1hz_50m #(.TARGET(DIV_TARGET)) udiv (
        .clk_50m (clk_50m),
        .reset   (reset),
        .tick_1Hz(tick_1Hz)
    );
    assign pulso_1hz = tick_1Hz;

    // Contador sincrónico (0-15) controlado por el reloj principal
    logic [3:0] count_up;
    
    always_ff @(posedge clk_50m or posedge reset) begin
        if (reset) begin
            count_up <= 4'd0;
        end else if (clear) begin
            count_up <= 4'd0;  // Reiniciar contador
        end else if (start && tick_1Hz) begin
            // Solo incrementar cuando start=1 Y hay un tick de 1Hz
            if (count_up < 4'd15) begin
                count_up <= count_up + 4'd1;
            end
        end
    end
    assign timeout = (count_up == 4'd15);

    wire A0 = ~count_up[0];
    wire A1 = ~count_up[1];
    wire A2 = ~count_up[2];
    wire A3 = ~count_up[3];

    bcd_contador_L uL (
        .A0(A0), .A1(A1), .A2(A2), .A3(A3),
        .a(aL), .b(bL), .c(cL), .d(dL), .e(eL), .f(fL), .g(gL)
    );

    bcd_contador_R uR (
        .A0(A0), .A1(A1), .A2(A2), .A3(A3),
        .a(aR), .b(bR), .c(cR), .d(dR), .e(eR), .f(fR), .g(gR)
    );
endmodule
