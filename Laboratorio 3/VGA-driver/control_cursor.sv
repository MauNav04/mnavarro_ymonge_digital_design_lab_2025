
// Controlador de posición para el cursor del juego de memoria.
// Admite movimientos incrementales (botones) y una carga directa de
// coordenadas cuando se necesita posicionar el cursor de forma rápida
// (por ejemplo, para selecciones aleatorias).
module control_cursor (
    input  logic clk,
    input  logic reset,          // Reset global, vuelve a (fila=0, columna=0)
    input  logic mover_adelante, // Pulso de avance (dependiendo del modo)
    input  logic mover_atras,    // Pulso de retroceso
    input  logic modo_vertical,  // 0 mover columnas, 1 -> mover filas
    input  logic cargar,         // 1  cargar índice externo
    input  logic [3:0] indice_cargar,
    output logic [1:0] fila,
    output logic [1:0] columna,
    output logic [3:0] indice    // Índice lineal {fila, columna}
);

    logic [1:0] fila_r, columna_r;

    // Registro de fila
    always_ff @(posedge clk or posedge reset) begin
        if (reset) fila_r <= 2'd0;
        else if (cargar) fila_r <= indice_cargar[3:2];
        else if (modo_vertical) begin
            case ({mover_adelante, mover_atras})
                2'b10: fila_r <= (fila_r == 2'd3) ? 2'd0 : fila_r + 2'd1;
                2'b01: fila_r <= (fila_r == 2'd0) ? 2'd3 : fila_r - 2'd1;
                default: fila_r <= fila_r; // sin cambio o pulsos simultáneos
            endcase
        end
    end

    // Registro de columna
    always_ff @(posedge clk or posedge reset) begin
        if (reset) columna_r <= 2'd0;
        else if (cargar) columna_r <= indice_cargar[1:0];
        else if (!modo_vertical) begin
            case ({mover_adelante, mover_atras})
                2'b10: columna_r <= (columna_r == 2'd3) ? 2'd0 : columna_r + 2'd1;
                2'b01: columna_r <= (columna_r == 2'd0) ? 2'd3 : columna_r - 2'd1;
                default: columna_r <= columna_r;
            endcase
        end
    end

    assign fila    = fila_r;
    assign columna = columna_r;
    assign indice  = {fila_r, columna_r}; // fila como bits más significativos

endmodule


