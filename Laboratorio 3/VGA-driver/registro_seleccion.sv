
// Registro que almacena la carta que seleccionamos
// El registro se actualiza cuando captura=1 y puede limpiarse con reset o limpiar.
module registro_seleccion (
    input  logic clk,
    input  logic reset,
    input  logic limpiar,
    input  logic captura,
    input  logic [3:0] indice_in,
    output logic [3:0] indice_out
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)        indice_out <= 4'd0;
        else if (limpiar) indice_out <= 4'd0;
        else if (captura) indice_out <= indice_in;
    end

endmodule

