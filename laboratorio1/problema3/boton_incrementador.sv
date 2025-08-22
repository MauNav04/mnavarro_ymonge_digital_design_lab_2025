module boton_incrementador (
    input  logic clk,        // Reloj del sistema
    input  logic btn_raw,    // Botón sin acondicionar
    input  logic reset,      // Reset
    output logic btn_pulse   // Pulso limpio del botón
);

    logic q0, nq0;  // Salidas del primer flip-flop
    logic q1, nq1;  // Salidas del segundo flip-flop
    logic q2, nq2;  // Salidas del tercer flip-flop
    
    logic reset_n;  // Reset negado (para CLR activo en bajo)
    
    // Negar el reset para usar con CLR (activo en bajo)
    not (reset_n, reset);
    
    // Cadena de 3 flip-flops para sincronizar la señal del botón
    flip_flop ff0 (
        .D(btn_raw),
        .CLK(clk),
        .PRE(1'b1),      // PRE inactivo
        .CLR(reset_n),   // CLR activo cuando reset = 1
        .Q(q0),
        .nQ(nq0)
    );
    
    flip_flop ff1 (
        .D(q0),
        .CLK(clk),
        .PRE(1'b1),
        .CLR(reset_n),
        .Q(q1),
        .nQ(nq1)
    );
    
    flip_flop ff2 (
        .D(q1),
        .CLK(clk),
        .PRE(1'b1),
        .CLR(reset_n),
        .Q(q2),
        .nQ(nq2)
    );
    
    // Detectar flanco de subida: q1 AND (NOT q2)
    // Esto genera un pulso cuando hay transición de 0 a 1
    and (btn_pulse, q1, nq2);

endmodule