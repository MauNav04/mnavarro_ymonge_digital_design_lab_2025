module full_adder(
    input  logic A,
    input  logic B,
    input  logic Cin,
    output logic S,
    output logic Cout
);

    logic axb;  // A XOR B

    // XOR intermedio
    assign axb  = A ^ B;
    assign S    = axb ^ Cin;

    // Carry out
    assign Cout = (A & B) | (axb & Cin);

endmodule