module fsm_controller (
    input  logic clk,
    input  logic reset,
    input  logic switch_input,
    output logic color_control
);

    // Definición de estados
    typedef enum logic {
        STATE_BLUE = 1'b0,
        STATE_RED  = 1'b1
    } state_t;
    
    state_t current_state, next_state;
    
    // Registro de estado
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_BLUE;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Lógica de siguiente estado (Máquina de Mealy)
    always_comb begin
        case (current_state)
            STATE_BLUE: next_state = switch_input ? STATE_RED : STATE_BLUE;
            STATE_RED:  next_state = switch_input ? STATE_RED : STATE_BLUE;
            default:    next_state = STATE_BLUE;
        endcase
    end
    
    // Salida - señal de control de color
    assign color_control = (current_state == STATE_RED);
    
endmodule