module Restador4b(
    input  logic [3:0] A,     // Minuendo (4 bits)
    input  logic [3:0] B,     // Sustraendo (4 bits)
    output logic [3:0] S,     // Resultado de la resta (4 bits)
    output logic       C_out  // Carry de salida final
);

    logic [3:0] carry;

    // Instancia de los 4 full_adder_resta en cascada
    full_adder_resta FA0 (
        .A(A[0]),
        .B(B[0]),
        .C_in(1'b1),      // Primer Cin = 1 para complemento a dos
        .S(S[0]),
        .C_out(carry[0])
    );
    full_adder_resta FA1 (
        .A(A[1]),
        .B(B[1]),
        .C_in(carry[0]),
        .S(S[1]),
        .C_out(carry[1])
    );
    full_adder_resta FA2 (
        .A(A[2]),
        .B(B[2]),
        .C_in(carry[1]),
        .S(S[2]),
        .C_out(carry[2])
    );
    full_adder_resta FA3 (
        .A(A[3]),
        .B(B[3]),
        .C_in(carry[2]),
        .S(S[3]),
        .C_out(C_out)
    );

endmodule