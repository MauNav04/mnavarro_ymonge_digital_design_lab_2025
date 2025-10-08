`timescale 1ns/1ps
`default_nettype none

// Top-level
module vga (
    input  logic        clk,      // 50 MHz board clock
    input  logic        reset,    // async active-high
    output logic        vgaclk,   // 25 MHz VGA pixel clock
    output logic        hsync,
    output logic        vsync,
    output logic        sync_b,   // keep 0 for modern monitors
    output logic        blank_b,  // high during active video in this design
    output logic [7:0]  r, g, b
);

    // divide 50 MHz by 2 -> ~25 MHz pixel clock
    always_ff @(posedge clk or posedge reset) begin
        if (reset) vgaclk <= 1'b0;
        else       vgaclk <= ~vgaclk;
    end

    logic [9:0] x, y;

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

    videoGen videoGen_i (
        .x(x), .y(y), .r(r), .g(g), .b(b)
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


module videoGen (
  input  logic [9:0] x,
  input  logic [9:0] y,
  output logic [7:0] r,
  output logic [7:0] g,
  output logic [7:0] b
);
  localparam int CARD_W   = 70;
  localparam int CARD_H   = 100;
  localparam int SPACE    = 10;
  localparam int START_X  = 40;
  localparam int START_Y0 = 50;
  localparam int START_Y1 = 280;

  // salidas por carta
  logic [7:0] r_i [0:7], g_i [0:7], b_i [0:7];
  logic       hit[0:7];

  // === FIX 2: algunos Quartus requieren generate/endgenerate ===
  generate
    genvar i;
    for (i=0; i<8; i=i+1) begin : GEN_CARDS
      localparam int COL = i % 4;
      localparam int ROW = i / 4;
      localparam int X0 = START_X + COL*(CARD_W + SPACE);
      localparam int Y0 = (ROW==0) ? START_Y0 : START_Y1;
      localparam [2:0] PSEL = i[2:0]; // patrón = índice

      card #(
        .CARD_W(CARD_W), .CARD_H(CARD_H),
        .PATTERN(PSEL)
      ) u_card (
        .x(x), .y(y),
        .x0(X0[9:0]), .y0(Y0[9:0]),
        .hit(hit[i]),
        .r(r_i[i]), .g(g_i[i]), .b(b_i[i])
      );
    end
  endgenerate

  // composición por prioridad (la última gana)
  always_comb begin
    r = 8'h20; g = 8'h20; b = 8'h30; // fondo
    for (int k=0; k<8; k++) begin
      if (hit[k]) begin
        r = r_i[k]; g = g_i[k]; b = b_i[k];
      end
    end
  end

endmodule

`default_nettype wire