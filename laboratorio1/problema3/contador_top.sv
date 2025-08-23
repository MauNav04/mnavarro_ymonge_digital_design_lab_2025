module contador_top (
    input  logic clk,           // Reloj del sistema
    input  logic btn_increment, // Botón para incrementar
    input  logic switch_reset,  // Switch de reset
    output logic [6:0] HEX0,    // Display derecho (4 bits menos significativos)
    output logic [6:0] HEX1     // Display izquierdo (2 bits más significativos)
);

    logic btn_clean;
    logic [5:0] count;
    logic [3:0] lower_4bits;   // Para display derecho
    logic [3:0] upper_2bits;   // Para display izquierdo (extendido a 4 bits)
    
    // Debouncer del botón usando compuertas primitivas
    boton_incrementador debouncer (
        .clk(clk),
        .btn_raw(btn_increment),
        .reset(switch_reset),
        .btn_pulse(btn_clean)
    );
    
    // Contador de 6 bits usando compuertas primitivas
    contador_6bit counter (
        .btn_clk(btn_clean),
        .reset(switch_reset),
        .count(count)
    );
    
    // Separar los bits para los displays
    assign lower_4bits = count[3:0];           // 4 bits menos significativos
	 //assign lower_4bits = count[1:0];           // 2 bits menos significativos
	 //assign upper_2bits = {2'b00, count[4:4]}; // 2 bits más significativos extendidos a 4 bits
	 assign upper_2bits = {2'b00, count[5:4]}; // 2 bits más significativos extendidos a 4 bits
    //assign upper_2bits = 4'b0000; // 2 bits más significativos extendidos a 4 bits
    
    // Display derecho - 4 bits menos significativos (0-F)
    bcd_4b display_right (
        .A0(lower_4bits[0]),
        .A1(lower_4bits[1]),
        .A2(lower_4bits[2]),
        .A3(lower_4bits[3]),
        .a(HEX0[6]),
        .b(HEX0[5]),
        .c(HEX0[4]),
        .d(HEX0[3]),
        .e(HEX0[2]),
        .f(HEX0[1]),
        .g(HEX0[0])
    );
    
    // Display izquierdo - 2 bits más significativos (0-3)
    bcd_4b display_left (
        .A0(upper_2bits[0]),
        .A1(upper_2bits[1]),
        .A2(upper_2bits[2]),
        .A3(upper_2bits[3]),
        .a(HEX1[6]),
        .b(HEX1[5]),
        .c(HEX1[4]),
        .d(HEX1[3]),
        .e(HEX1[2]),
        .f(HEX1[1]),
        .g(HEX1[0])
    );

endmodule