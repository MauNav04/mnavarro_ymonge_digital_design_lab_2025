module full_adder_resta(
    input  logic A,      // bit del número A
    input  logic B,      // bit del número B (se niega internamente)
    input  logic C_in,   // bit de entrada de acarreo
    output logic C_out,  // bit de salida de acarreo
    output logic S       // bit de resta
);

    logic B_neg;
    logic AxorB;
    logic and1;
    logic or1;

    // Negar la entrada B
    assign B_neg = ~B;

    // XOR entre A y B_negado
    assign AxorB = A ^ B_neg;

    // Resultado de la resta: (A ⊕ ~B) ⊕ C_in
    assign S = AxorB ^ C_in;

    // (A ⊕ ~B) AND C_in
    assign and1 = AxorB & C_in;

    // (A OR ~B)
    assign or1 = A | B_neg;

    // Carry out: (A OR ~B) OR [(A ⊕ ~B) AND C_in]
    assign C_out = or1 | and1;

endmodule