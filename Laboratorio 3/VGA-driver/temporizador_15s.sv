
module temporizador_15s #(
    parameter [25:0] DIV_TARGET = 26'd49_999_999 // 50 MHz -> 1 Hz real
) (
    input  logic clk_50m,
    input  logic reset,        // activo alto
    output logic aL,bL,cL,dL,eL,fL,gL,  // decenas (ánodo común)
    output logic aR,bR,cR,dR,eR,fR,gR   // unidades (ánodo común)
);
    // 1) divisor 50MHz -> tick_1Hz (pulso 1 ciclo)
    logic tick_1Hz;
    divisor_1hz_50m #(.TARGET(DIV_TARGET)) udiv (
        .clk_50m (clk_50m),
        .reset   (reset),
        .tick_1Hz(tick_1Hz)
    );

    // 2) contador 0..15 (sube con cada tick)
    logic [3:0] count_up;
    contador_4bit ucnt (
        .btn_clk(tick_1Hz),
        .reset  (reset),
        .count  (count_up)
    );

    // 3) mostrar 15..0 -> invertir los 4 bits
    wire A0 = ~count_up[0];
    wire A1 = ~count_up[1];
    wire A2 = ~count_up[2];
    wire A3 = ~count_up[3];

    // 4) decenas/unidades (ánodo común, 0=ON)
    bcd_contador_L uL (
        .A0(A0), .A1(A1), .A2(A2), .A3(A3),
        .a(aL), .b(bL), .c(cL), .d(dL), .e(eL), .f(fL), .g(gL)
    );

    bcd_contador_R uR (
        .A0(A0), .A1(A1), .A2(A2), .A3(A3),
        .a(aR), .b(bR), .c(cR), .d(dR), .e(eR), .f(fR), .g(gR)
    );
endmodule

