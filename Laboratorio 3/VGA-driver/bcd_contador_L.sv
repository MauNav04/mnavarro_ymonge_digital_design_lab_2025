

// Ánodo común: 0 = ON, 1 = OFF
module bcd_contador_L (
    input  logic A0, A1, A2, A3,   // A3 = MSB auque el A0 no afecta las decenas
    output logic a, b, c, d, e, f, g
);

    // Para 0..9 (decena=0): a,b,c,d,e,f = 0; g = 1
    // Para 10..15 (decena=1): b,c = 0; a,d,e,f,g = 1
    // Condición (>=10) : (A3 & A2) | (A3 & A1)

    assign a = (A3 & A2) | (A3 & A1);
    assign b = 1'b0;
    assign c = 1'b0;
    assign d = (A3 & A2) | (A3 & A1);
    assign e = (A3 & A2) | (A3 & A1);
    assign f = (A3 & A2) | (A3 & A1);
    assign g = 1'b1;

endmodule

