module tb_Restador4b;
    logic [3:0] A, B;
    logic [3:0] S;
    logic       C_out;

    // Instanciación del módulo bajo prueba
    Restador4b UUT (
        .A(A),
        .B(B),
        .S(S),
        .C_out(C_out)
    );

    initial begin
        $display("A     B     | S     C_out");
        $display("-----------------------------");
        
        // Prueba 1: 5 - 3 = 2
        A = 4'b0101; B = 4'b0011;
        #1 $display("%b %b | %b %b", A, B, S, C_out);

        // Prueba 2: 8 - 7 = 1
        A = 4'b1000; B = 4'b0111;
        #1 $display("%b %b | %b %b", A, B, S, C_out);

        // Prueba 3: 7 - 8 = -1 (complemento a dos)
        A = 4'b0111; B = 4'b1000;
        #1 $display("%b %b | %b %b", A, B, S, C_out);

        // Prueba 4: 15 - 15 = 0
        A = 4'b1111; B = 4'b1111;
        #1 $display("%b %b | %b %b", A, B, S, C_out);

        // Prueba 5: 0 - 1 = -1
        A = 4'b0000; B = 4'b0001;
        #1 $display("%b %b | %b %b", A, B, S, C_out);

        // Prueba 6: 0 - 0 = 0
        A = 4'b0000; B = 4'b0000;
        #1 $display("%b %b | %b %b", A, B, S, C_out);

        $finish;
    end
endmodule