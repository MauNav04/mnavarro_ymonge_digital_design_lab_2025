module bcd_4b (
    input A0, A1, A2, A3,  // Entradas BCD (A3 = MSB)
    output a, b, c, d, e, f, g  // Salidas para display de ánodo común (0=ON, 1=OFF)
);

// Lógica para cada segmento (ánodo común: 0=encendido, 1=apagado)
// Segmento a (activado para 0,2,3,5,6,7,8,9,A,C,E,F)
assign a = ~(
    (~A3 & ~A2 & ~A1 & ~A0) |  // 0
    (~A3 & ~A2 & A1 & ~A0)  |  // 2
    (~A3 & ~A2 & A1 & A0)   |  // 3
    (~A3 & A2 & ~A1 & A0)    |  // 5
    (~A3 & A2 & A1 & ~A0)    |  // 6
    (~A3 & A2 & A1 & A0)     |  // 7
    (A3 & ~A2 & ~A1 & ~A0)   |  // 8
    (A3 & ~A2 & ~A1 & A0)    |  // 9
    (A3 & ~A2 & A1 & ~A0)    |  // A (10)
    (A3 & A2 & ~A1 & ~A0)    |  // C (12)
    (A3 & A2 & A1 & ~A0)     |  // E (14)
    (A3 & A2 & A1 & A0)        // F (15)
);

// Segmento b (activado para 0,1,2,3,4,7,8,9,A,D)
assign b = ~(
    (~A3 & ~A2 & ~A1 & ~A0) |  // 0
    (~A3 & ~A2 & ~A1 & A0)  |  // 1
    (~A3 & ~A2 & A1 & ~A0)  |  // 2
    (~A3 & ~A2 & A1 & A0)   |  // 3
    (~A3 & A2 & ~A1 & ~A0)  |  // 4
    (~A3 & A2 & A1 & A0)    |  // 7
    (A3 & ~A2 & ~A1 & ~A0)  |  // 8
    (A3 & ~A2 & ~A1 & A0)   |  // 9
    (A3 & ~A2 & A1 & ~A0)   |  // A (10)
    (A3 & A2 & ~A1 & A0)      // D (13)
);

// Segmento c (activado para 0,1,3,4,5,6,7,8,9,A,B,D)
assign c = ~(
    (~A3 & ~A2 & ~A1 & ~A0) |  // 0
    (~A3 & ~A2 & ~A1 & A0)  |  // 1
    (~A3 & ~A2 & A1 & A0)   |  // 3
    (~A3 & A2 & ~A1 & ~A0)  |  // 4
    (~A3 & A2 & ~A1 & A0)   |  // 5
    (~A3 & A2 & A1 & ~A0)   |  // 6
    (~A3 & A2 & A1 & A0)    |  // 7
    (A3 & ~A2 & ~A1 & ~A0)  |  // 8
    (A3 & ~A2 & ~A1 & A0)   |  // 9
    (A3 & ~A2 & A1 & ~A0)   |  // A (10)
    (A3 & ~A2 & A1 & A0)    |  // B (11)
    (A3 & A2 & ~A1 & A0)      // D (13)
);

// Segmento d (activado para 0,2,3,5,6,8,9,B,C,D,E)
assign d = ~(
    (~A3 & ~A2 & ~A1 & ~A0) |  // 0
    (~A3 & ~A2 & A1 & ~A0)  |  // 2
    (~A3 & ~A2 & A1 & A0)   |  // 3
    (~A3 & A2 & ~A1 & A0)   |  // 5
    (~A3 & A2 & A1 & ~A0)   |  // 6
    (A3 & ~A2 & ~A1 & ~A0)  |  // 8
    (A3 & ~A2 & ~A1 & A0)   |  // 9
    (A3 & ~A2 & A1 & A0)    |  // B (11)
    (A3 & A2 & ~A1 & ~A0)   |  // C (12)
    (A3 & A2 & ~A1 & A0)    |  // D (13)
    (A3 & A2 & A1 & ~A0)      // E (14)
);

// Segmento e (activado para 0,2,6,8,A,B,C,D,E,F)
assign e = ~(
    (~A3 & ~A2 & ~A1 & ~A0) |  // 0
	 (~A3 & ~A2 & A1 & ~A0)  |  // 2
    (~A3 & A2 & A1 & ~A0)   |  // 6
    (A3 & ~A2 & ~A1 & ~A0)  |  // 8
    (A3 & ~A2 & A1 & ~A0)   |  // A (10)
    (A3 & ~A2 & A1 & A0)    |  // B (11)
    (A3 & A2 & ~A1 & ~A0)   |  // C (12)
    (A3 & A2 & ~A1 & A0)    |  // D (13)
    (A3 & A2 & A1 & ~A0)    |  // E (14)
    (A3 & A2 & A1 & A0)       // F (15)
);

// Segmento f (activado para 0,4,5,6,8,9,A,B,C,E,F)
assign f = ~(
    (~A3 & ~A2 & ~A1 & ~A0) |  // 0
    (~A3 & A2 & ~A1 & ~A0)  |  // 4
    (~A3 & A2 & ~A1 & A0)   |  // 5
    (~A3 & A2 & A1 & ~A0)   |  // 6
    (A3 & ~A2 & ~A1 & ~A0)  |  // 8
    (A3 & ~A2 & ~A1 & A0)   |  // 9
    (A3 & ~A2 & A1 & ~A0)   |  // A (10)
    (A3 & ~A2 & A1 & A0)    |  // B (11)
    (A3 & A2 & ~A1 & ~A0)   |  // C (12)
    (A3 & A2 & A1 & ~A0)    |  // E (14)
    (A3 & A2 & A1 & A0)       // F (15)
);

// Segmento g (activado para 2,3,4,5,6,8,9,A,B,D,E,F)
assign g = ~(
    (~A3 & ~A2 & A1 & ~A0)  |  // 2
    (~A3 & ~A2 & A1 & A0)   |  // 3
    (~A3 & A2 & ~A1 & ~A0)  |  // 4
    (~A3 & A2 & ~A1 & A0)   |  // 5
    (~A3 & A2 & A1 & ~A0)   |  // 6
    (A3 & ~A2 & ~A1 & ~A0)  |  // 8
    (A3 & ~A2 & ~A1 & A0)   |  // 9
    (A3 & ~A2 & A1 & ~A0)   |  // A (10)
    (A3 & ~A2 & A1 & A0)    |  // B (11)
    (A3 & A2 & ~A1 & A0)    |  // D (13)
    (A3 & A2 & A1 & ~A0)    |  // E (14)
    (A3 & A2 & A1 & A0)       // F (15)
);

endmodule