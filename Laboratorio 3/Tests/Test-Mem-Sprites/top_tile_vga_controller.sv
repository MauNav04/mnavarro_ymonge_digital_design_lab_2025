// Top module: Integra todo el sistema de tiles con VGA
module top_tile_vga_controller (
    input  logic clk,           // Reloj de la FPGA (50MHz)
    input  logic reset,         // Reset global
    // Salidas VGA
    output logic        vgaclk,     // 25 MHz VGA pixel clock
    output logic        hsync,      // Sincronización horizontal
    output logic        vsync,      // Sincronización vertical
    output logic        sync_b,     // keep 0 for modern monitors
    output logic        blank_b,    // high during active video
    output logic [7:0]  vga_r,      // Canal rojo
    output logic [7:0]  vga_g,      // Canal verde  
    output logic [7:0]  vga_b       // Canal azul
);

    // Dividir 50 MHz por 2 -> ~25 MHz pixel clock
    always_ff @(posedge clk or posedge reset) begin
        if (reset) vgaclk <= 1'b0;
        else       vgaclk <= ~vgaclk;
    end

    // Señales internas
    logic [9:0] x, y;

    // Instancia del controlador VGA
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
    
    // Instancia del renderizador de tiles
    tile_renderer renderer (
        .clk(vgaclk),
        .reset(reset),
        .x_pos(x),
        .y_pos(y),
        .vga_red(vga_r),
        .vga_green(vga_g),
        .vga_blue(vga_b)
    );

endmodule


// 640x480@60 timing (25.175 MHz nominal; works with 25.000 on most monitors)
module vgaController #(
    parameter int unsigned HBP     = 10'd48,
    parameter int unsigned HACTIVE = 10'd640,
    parameter int unsigned HFP     = 10'd16,
    parameter int unsigned HSYN    = 10'd96,
    parameter int unsigned HMAX    = HBP + HACTIVE + HFP + HSYN,

    parameter int unsigned VBP     = 10'd33,
    parameter int unsigned VACTIVE = 10'd480,
    parameter int unsigned VFP     = 10'd10,
    parameter int unsigned VSYN    = 10'd2,
    parameter int unsigned VMAX    = VBP + VACTIVE + VFP + VSYN
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
    assign sync_b = 1'b0;

    // active video region
    logic visible;
    assign visible = (hcnt < HACTIVE) && (vcnt < VACTIVE);
    assign blank_b = visible;

endmodule