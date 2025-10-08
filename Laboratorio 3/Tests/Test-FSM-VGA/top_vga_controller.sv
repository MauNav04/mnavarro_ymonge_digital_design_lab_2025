module top_vga_controller (
    input  logic clk,           // Reloj de la FPGA (ej. 50MHz)
    input  logic reset,         // Reset global
    input  logic switch_input,  // Entrada del switch
    // Salidas VGA
	 output logic        vgaclk, // 25 MHz VGA pixel clock
    output logic hsync,     // Sincronización horizontal
    output logic vsync,     // Sincronización vertical
	 output logic        sync_b,   // keep 0 for modern monitors
    output logic        blank_b,  // high during active video in this design
    output logic [7:0] vga_r,   // Canal rojo
    output logic [7:0] vga_g,   // Canal verde  
    output logic [7:0] vga_b    // Canal azul
);

	// divide 50 MHz by 2 -> ~25 MHz pixel clock
    always_ff @(posedge clk or posedge reset) begin
        if (reset) vgaclk <= 1'b0;
        else       vgaclk <= ~vgaclk;
    end

    // Señales internas
    logic [9:0] x, y;
    logic color_control_signal;

    // Instancia del controlador FSM
    fsm_controller fsm_inst (
        .clk(clk),
        .reset(reset),
        .switch_input(switch_input),
        .color_control(color_control_signal)
    );
	 
	 vgaController vgaCont (
        .vgaclk (vgaclk),
        .reset  (reset),
        .hsync  (hsync),
        .vsync  (vsync),
        .sync_b (sync_b),
        .blank_b(blank_b),
        .hcnt   (x),
        .vcnt   (y)
    );
    
    // Instancia del controlador de color VGA
    vga_color_controller color_inst (
        .clk(vgaclk),
        .reset(reset),
        .x_pos(x),
        .y_pos(y),
        .color_signal(color_control_signal),
        .vga_red(vga_r),
        .vga_green(vga_g),
        .vga_blue(vga_b)
    );

endmodule


// 640x480@60 timing (25.175 MHz nominal; works with 25.000 on most monitors)
module vgaController #(
    parameter int unsigned HBP     = 10'd48,   // back porch
    parameter int unsigned HACTIVE = 10'd640,  // visible
    parameter int unsigned HFP     = 10'd16,   // front porch
    parameter int unsigned HSYN    = 10'd96,   // hsync
    parameter int unsigned HMAX    = HBP + HACTIVE + HFP + HSYN, // 800 total

    parameter int unsigned VBP     = 10'd33,   // back porch (33 works well)
    parameter int unsigned VACTIVE = 10'd480,  // visible
    parameter int unsigned VFP     = 10'd10,   // front porch
    parameter int unsigned VSYN    = 10'd2,    // vsync
    parameter int unsigned VMAX    = VBP + VACTIVE + VFP + VSYN  // 525 total
) (
    input  logic       vgaclk,
    input  logic       reset,
    output logic       hsync,
    output logic       vsync,
    output logic       sync_b,
    output logic       blank_b,
    output logic [9:0] hcnt,
    output logic [9:0] vcnt
);

// horizontal/vertical counters
    always_ff @(posedge vgaclk or posedge reset) begin
        if (reset) begin
            hcnt <= '0;
            vcnt <= '0;
        end else begin
            if (hcnt == HMAX-1) begin
                hcnt <= '0;
                if (vcnt == VMAX-1) vcnt <= '0;
                else                vcnt <= vcnt + 10'd1;
            end else begin
                hcnt <= hcnt + 10'd1;
            end
        end
    end

    // syncs are active low in VGA
    assign hsync  = ~((hcnt >= (HACTIVE + HFP))  && (hcnt < (HACTIVE + HFP + HSYN)));
    assign vsync  = ~((vcnt >= (VACTIVE + VFP)) && (vcnt < (VACTIVE + VFP + VSYN)));
    assign sync_b = 1'b0; // keep low for modern monitors

    // active video region
    logic visible;
    assign visible = (hcnt < HACTIVE) && (vcnt < VACTIVE);

    assign blank_b = visible;

endmodule
