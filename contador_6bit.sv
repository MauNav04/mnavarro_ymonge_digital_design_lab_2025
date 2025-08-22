module contador_6bit (
    input  logic btn_clk,    // Botón para incrementar
    input  logic reset,      // Reset asíncrono
    output logic [5:0] count // Salida del contador de 6 bits
);

    logic [5:0] current_count;
    logic [5:0] next_count;
    
    // Asignar la salida directamente desde los flip-flops
    assign count = current_count;
    
    // Lógica combinacional para calcular next_count
    // Esta lógica debe estar separada de los flip-flops
    
    // Generación de carry usando compuertas primitivas
    logic c0, c1, c2, c3, c4;
    
    // Carry chain para incremento
    assign c0 = current_count[0];  // carry para bit 1
    and (c1, c0, current_count[1]);  // carry para bit 2
    and (c2, c1, current_count[2]);  // carry para bit 3
    and (c3, c2, current_count[3]);  // carry para bit 4
    and (c4, c3, current_count[4]);  // carry para bit 5
    
    // Cálculo de next_count usando compuertas primitivas
    not (next_count[0], current_count[0]);  // bit 0 siempre se invierte
    xor (next_count[1], current_count[1], c0);
    xor (next_count[2], current_count[2], c1);
    xor (next_count[3], current_count[3], c2);
    xor (next_count[4], current_count[4], c3);
    xor (next_count[5], current_count[5], c4);
    
    // Flip-flops para almacenar el estado
    flip_flop ff0 (
        .D(next_count[0]),
        .CLK(btn_clk),
        .PRE(1'b1),
        .CLR(~reset),
        .Q(current_count[0]),
        .nQ()
    );
    
    flip_flop ff1 (
        .D(next_count[1]),
        .CLK(btn_clk),
        .PRE(1'b1),
        .CLR(~reset),
        .Q(current_count[1]),
        .nQ()
    );
    
    flip_flop ff2 (
        .D(next_count[2]),
        .CLK(btn_clk),
        .PRE(1'b1),
        .CLR(~reset),
        .Q(current_count[2]),
        .nQ()
    );
    
    flip_flop ff3 (
        .D(next_count[3]),
        .CLK(btn_clk),
        .PRE(1'b1),
        .CLR(~reset),
        .Q(current_count[3]),
        .nQ()
    );
    
    flip_flop ff4 (
        .D(next_count[4]),
        .CLK(btn_clk),
        .PRE(1'b1),
        .CLR(~reset),
        .Q(current_count[4]),
        .nQ()
    );
    
    flip_flop ff5 (
        .D(next_count[5]),
        .CLK(btn_clk),
        .PRE(1'b1),
        .CLR(~reset),
        .Q(current_count[5]),
        .nQ()
    );

endmodule