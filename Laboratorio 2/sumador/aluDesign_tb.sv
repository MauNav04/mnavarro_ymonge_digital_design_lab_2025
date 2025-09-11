module aluDesign_tb();

    logic [3:0] A, B;
    logic Cin;
    logic [3:0] S;
    logic Cout;

    // Instancia del DUT (Device Under Test)
    aluDesign UUT (
        .A(A), .B(B), .Cin(Cin),
        .S(S), .Cout(Cout)
    );

    initial begin
        $monitor("Time=%0t | A=%b B=%b Cin=%b -> S=%b Cout=%b",
                  $time, A, B, Cin, S, Cout);

        A = 4'b0000; B = 4'b0000; Cin = 0;
        #10 A = 4'b0011; B = 4'b0101; Cin = 0;
        #10 A = 4'b1111; B = 4'b0001; Cin = 0;
        #10 A = 4'b1010; B = 4'b0101; Cin = 1;
        #10 A = 4'b1111; B = 4'b1111; Cin = 1;
        #10 $finish;
    end

endmodule