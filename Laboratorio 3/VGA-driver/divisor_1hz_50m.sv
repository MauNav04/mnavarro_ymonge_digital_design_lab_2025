

module divisor_1hz_50m #(
    parameter [25:0] TARGET = 26'd49_999_999
) (
    input  logic clk_50m,
    input  logic reset,       // activo alto
    output logic tick_1Hz
);
    logic [25:0] q, next;

    // --- +1 ripple (AND + XOR), igual a tu versión ---
    logic c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24;
    assign c0 = q[0];
    and (c1 , q[1],  c0 );  and (c2 , q[2],  c1 );  and (c3 , q[3],  c2 );
    and (c4 , q[4],  c3 );  and (c5 , q[5],  c4 );  and (c6 , q[6],  c5 );
    and (c7 , q[7],  c6 );  and (c8 , q[8],  c7 );  and (c9 , q[9],  c8 );
    and (c10, q[10], c9 );  and (c11, q[11], c10);  and (c12, q[12], c11);
    and (c13, q[13], c12);  and (c14, q[14], c13);  and (c15, q[15], c14);
    and (c16, q[16], c15);  and (c17, q[17], c16);  and (c18, q[18], c17);
    and (c19, q[19], c18);  and (c20, q[20], c19);  and (c21, q[21], c20);
    and (c22, q[22], c21);  and (c23, q[23], c22);  and (c24, q[24], c23);

    not (next[0], q[0]);
    xor (next[1],  q[1],  c0 );
    xor (next[2],  q[2],  c1 );
    xor (next[3],  q[3],  c2 );
    xor (next[4],  q[4],  c3 );
    xor (next[5],  q[5],  c4 );
    xor (next[6],  q[6],  c5 );
    xor (next[7],  q[7],  c6 );
    xor (next[8],  q[8],  c7 );
    xor (next[9],  q[9],  c8 );
    xor (next[10], q[10], c9 );
    xor (next[11], q[11], c10);
    xor (next[12], q[12], c11);
    xor (next[13], q[13], c12);
    xor (next[14], q[14], c13);
    xor (next[15], q[15], c14);
    xor (next[16], q[16], c15);
    xor (next[17], q[17], c16);
    xor (next[18], q[18], c17);
    xor (next[19], q[19], c18);
    xor (next[20], q[20], c19);
    xor (next[21], q[21], c20);
    xor (next[22], q[22], c21);
    xor (next[23], q[23], c22);
    xor (next[24], q[24], c23);
    xor (next[25], q[25], c24);

    // --- Comparador genérico q == TARGET ---
    // dif[i] = q[i] ^ TARGET[i];  eq = ~(|dif)   (NOR de todos los dif)
    logic [25:0] dif;
    xor (dif[0],  q[0],  TARGET[0]);
    xor (dif[1],  q[1],  TARGET[1]);
    xor (dif[2],  q[2],  TARGET[2]);
    xor (dif[3],  q[3],  TARGET[3]);
    xor (dif[4],  q[4],  TARGET[4]);
    xor (dif[5],  q[5],  TARGET[5]);
    xor (dif[6],  q[6],  TARGET[6]);
    xor (dif[7],  q[7],  TARGET[7]);
    xor (dif[8],  q[8],  TARGET[8]);
    xor (dif[9],  q[9],  TARGET[9]);
    xor (dif[10], q[10], TARGET[10]);
    xor (dif[11], q[11], TARGET[11]);
    xor (dif[12], q[12], TARGET[12]);
    xor (dif[13], q[13], TARGET[13]);
    xor (dif[14], q[14], TARGET[14]);
    xor (dif[15], q[15], TARGET[15]);
    xor (dif[16], q[16], TARGET[16]);
    xor (dif[17], q[17], TARGET[17]);
    xor (dif[18], q[18], TARGET[18]);
    xor (dif[19], q[19], TARGET[19]);
    xor (dif[20], q[20], TARGET[20]);
    xor (dif[21], q[21], TARGET[21]);
    xor (dif[22], q[22], TARGET[22]);
    xor (dif[23], q[23], TARGET[23]);
    xor (dif[24], q[24], TARGET[24]);
    xor (dif[25], q[25], TARGET[25]);

    wire any_dif = |dif;   // OR-reduce (sintetiza a árbol de OR)
    wire eq;
    not (eq, any_dif);

    assign tick_1Hz = eq;

    // --- Reset síncrono: D = (~eq) & next ---
    logic [25:0] D;
    and (D[0] , next[0] , ~eq);
    and (D[1] , next[1] , ~eq);
    and (D[2] , next[2] , ~eq);
    and (D[3] , next[3] , ~eq);
    and (D[4] , next[4] , ~eq);
    and (D[5] , next[5] , ~eq);
    and (D[6] , next[6] , ~eq);
    and (D[7] , next[7] , ~eq);
    and (D[8] , next[8] , ~eq);
    and (D[9] , next[9] , ~eq);
    and (D[10], next[10], ~eq);
    and (D[11], next[11], ~eq);
    and (D[12], next[12], ~eq);
    and (D[13], next[13], ~eq);
    and (D[14], next[14], ~eq);
    and (D[15], next[15], ~eq);
    and (D[16], next[16], ~eq);
    and (D[17], next[17], ~eq);
    and (D[18], next[18], ~eq);
    and (D[19], next[19], ~eq);
    and (D[20], next[20], ~eq);
    and (D[21], next[21], ~eq);
    and (D[22], next[22], ~eq);
    and (D[23], next[23], ~eq);
    and (D[24], next[24], ~eq);
    and (D[25], next[25], ~eq);

    // --- 26 FF maestro-esclavo (tu flip_flop) ---
    flip_flop ff0  (.D(D[0]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[0]),  .nQ());
    flip_flop ff1  (.D(D[1]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[1]),  .nQ());
    flip_flop ff2  (.D(D[2]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[2]),  .nQ());
    flip_flop ff3  (.D(D[3]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[3]),  .nQ());
    flip_flop ff4  (.D(D[4]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[4]),  .nQ());
    flip_flop ff5  (.D(D[5]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[5]),  .nQ());
    flip_flop ff6  (.D(D[6]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[6]),  .nQ());
    flip_flop ff7  (.D(D[7]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[7]),  .nQ());
    flip_flop ff8  (.D(D[8]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[8]),  .nQ());
    flip_flop ff9  (.D(D[9]),  .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[9]),  .nQ());
    flip_flop ff10 (.D(D[10]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[10]), .nQ());
    flip_flop ff11 (.D(D[11]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[11]), .nQ());
    flip_flop ff12 (.D(D[12]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[12]), .nQ());
    flip_flop ff13 (.D(D[13]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[13]), .nQ());
    flip_flop ff14 (.D(D[14]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[14]), .nQ());
    flip_flop ff15 (.D(D[15]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[15]), .nQ());
    flip_flop ff16 (.D(D[16]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[16]), .nQ());
    flip_flop ff17 (.D(D[17]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[17]), .nQ());
    flip_flop ff18 (.D(D[18]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[18]), .nQ());
    flip_flop ff19 (.D(D[19]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[19]), .nQ());
    flip_flop ff20 (.D(D[20]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[20]), .nQ());
    flip_flop ff21 (.D(D[21]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[21]), .nQ());
    flip_flop ff22 (.D(D[22]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[22]), .nQ());
    flip_flop ff23 (.D(D[23]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[23]), .nQ());
    flip_flop ff24 (.D(D[24]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[24]), .nQ());
    flip_flop ff25 (.D(D[25]), .CLK(clk_50m), .PRE(1'b1), .CLR(~reset), .Q(q[25]), .nQ());
endmodule
