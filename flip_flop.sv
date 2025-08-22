module flip_flop (
    input  logic D,
    input  logic CLK,
    input  logic PRE,   // activo en bajo
    input  logic CLR,   // activo en bajo
    output logic Q,
    output logic nQ
);

    logic nD, CLK_n;
    logic Sm, Rm, Qm, nQm;   // Señales del latch maestro
    logic Ss, Rs;            // Señales del latch esclavo

    assign nD    = ~D;
    assign CLK_n = ~CLK;

    // Latch maestro (activo con CLK = 0)
    nand (Sm, D,    CLK_n);
    nand (Rm, nD,   CLK_n);
    nand (Qm, Sm,   nQm, PRE);  // PRE activa en bajo
    nand (nQm, Rm,  Qm, CLR);   // CLR activa en bajo

    // Latch esclavo (activo con CLK = 1)
    nand (Ss, Qm,   CLK);
    nand (Rs, nQm,  CLK);
    nand (Q,  Ss,   nQ, PRE);   // PRE activa en bajo
    nand (nQ, Rs,   Q,  CLR);   // CLR activa en bajo

endmodule