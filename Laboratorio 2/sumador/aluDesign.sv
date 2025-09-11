module aluDesign(
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic Cin,
    output logic [3:0] S,
    output logic Cout
);

    logic c1, c2, c3;

    // FA0
    full_adder FA0(
        .A(A[0]), .B(B[0]), .Cin(Cin),
        .S(S[0]), .Cout(c1)
    );

    // FA1
    full_adder FA1(
        .A(A[1]), .B(B[1]), .Cin(c1),
        .S(S[1]), .Cout(c2)
    );

    // FA2
    full_adder FA2(
        .A(A[2]), .B(B[2]), .Cin(c2),
        .S(S[2]), .Cout(c3)
    );

    // FA3
    full_adder FA3(
        .A(A[3]), .B(B[3]), .Cin(c3),
        .S(S[3]), .Cout(Cout)
    );

endmodule