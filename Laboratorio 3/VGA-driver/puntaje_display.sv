

// Decodifica los puntajes de cada jugador hacia displays de 7 segmentos.
// Reutiliza el módulo bcd_contador_R (ánodo común, 0 = encendido).
module puntaje_display (
    input  logic [3:0] puntaje_j1,
    input  logic [3:0] puntaje_j2,
    output logic aJ1, bJ1, cJ1, dJ1, eJ1, fJ1, gJ1,
    output logic aJ2, bJ2, cJ2, dJ2, eJ2, fJ2, gJ2
);

    // Jugador 1
    bcd_contador_R disp_j1 (
        .A0(puntaje_j1[0]),
        .A1(puntaje_j1[1]),
        .A2(puntaje_j1[2]),
        .A3(puntaje_j1[3]),
        .a (aJ1), .b (bJ1), .c (cJ1),
        .d (dJ1), .e (eJ1), .f (fJ1), .g (gJ1)
    );

    // Jugador 2
    bcd_contador_R disp_j2 (
        .A0(puntaje_j2[0]),
        .A1(puntaje_j2[1]),
        .A2(puntaje_j2[2]),
        .A3(puntaje_j2[3]),
        .a (aJ2), .b (bJ2), .c (cJ2),
        .d (dJ2), .e (eJ2), .f (fJ2), .g (gJ2)
    );

endmodule


