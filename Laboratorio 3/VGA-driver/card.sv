`timescale 1ns/1ps
`default_nettype none

module card #(
  parameter int CARD_W  = 70,
  parameter int CARD_H  = 100,
  parameter [2:0] PATTERN = 3'd0,
  parameter logic [7:0] BG_R = 8'hF0, BG_G = 8'hF0, BG_B = 8'hF0,
  parameter logic [7:0] BD_R = 8'h00, BD_G = 8'h00, BD_B = 8'h00,
  parameter logic [7:0] P0_R = 8'h80, P0_G = 8'h00, P0_B = 8'h80,
  parameter logic [7:0] P1_R = 8'h00, P1_G = 8'h80, P1_B = 8'h80,
  parameter logic [7:0] P2_R = 8'hFF, P2_G = 8'h80, P2_B = 8'h00,
  parameter logic [7:0] P3_R = 8'hFF, P3_G = 8'h00, P3_B = 8'h80
)(
  input  logic [9:0] x, y,
  input  logic [9:0] x0, y0,
  output logic       hit,
  output logic [7:0] r, g, b
);

  logic in_area;
  assign in_area = (x >= x0) && (x < x0 + CARD_W) &&
                   (y >= y0) && (y < y0 + CARD_H);
  assign hit = in_area;

  // Inicializadores no-constantes en la declaración
  logic [9:0] cx, cy;
  assign cx = x - x0;
  assign cy = y - y0;

  logic is_border, is_corner, is_pattern;

  assign is_border = (cx < 3) || (cx >= CARD_W-3) ||
                     (cy < 3) || (cy >= CARD_H-3);

  assign is_corner = ((cx < 10 && cy < 10) ||
                      (cx >= CARD_W-10 && cy < 10) ||
                      (cx < 10 && cy >= CARD_H-10) ||
                      (cx >= CARD_W-10 && cy >= CARD_H-10));

  // Variables para el círculo (declaradas a nivel de módulo, no en el case)
  logic [9:0]  dx, dy;
  logic [21:0] rad2; // 10b*10b -> ~20b; damos margen

  always_comb begin
    // valores por defecto
    is_pattern = 1'b0;
    dx = '0; dy = '0; rad2 = '0;

    case (PATTERN)
      3'd0: is_pattern = (cy[3:0] < 4'd2); // líneas H
      3'd1: is_pattern = (cx[3:0] < 4'd2); // líneas V
      3'd2: is_pattern = (cx[3] ^ cy[3]);  // ajedrez
      3'd3: is_pattern = (cx >= cy - 2) && (cx <= cy + 2); // diag
      3'd4: is_pattern = ((cx >= CARD_W/2 - 3) && (cx <= CARD_W/2 + 3)) ||
                         ((cy >= CARD_H/2 - 3) && (cy <= CARD_H/2 + 3));
      3'd5: begin
        dx   = (cx > CARD_W/2) ? (cx - CARD_W/2) : (CARD_W/2 - cx);
        dy   = (cy > CARD_H/2) ? (cy - CARD_H/2) : (CARD_H/2 - cy);
        rad2 = dx*dx + dy*dy;
        is_pattern = (rad2 > 10'd400) && (rad2 < 10'd625);
      end
      3'd6: is_pattern = ((cx >= cy - 2) && (cx <= cy + 2)) ||
                         ((cx >= (CARD_H - cy) - 2) && (cx <= (CARD_H - cy) + 2));
      3'd7: is_pattern = ((cx[4:0] < 5'd3) && (cy[4:0] < 5'd3));
      default: is_pattern = 1'b0;
    endcase
  end

  always_comb begin
    r = BG_R; g = BG_G; b = BG_B;
    if (is_border) begin
      r = BD_R; g = BD_G; b = BD_B;
    end else if (is_corner) begin
      case (PATTERN[1:0])
        2'd0: begin r = 8'hFF; g = 8'h00; b = 8'h00; end
        2'd1: begin r = 8'h00; g = 8'hFF; b = 8'h00; end
        2'd2: begin r = 8'h00; g = 8'h00; b = 8'hFF; end
        2'd3: begin r = 8'hFF; g = 8'hFF; b = 8'h00; end
      endcase
    end else if (is_pattern) begin
      case (PATTERN[2:1])
        2'd0: begin r = P0_R; g = P0_G; b = P0_B; end
        2'd1: begin r = P1_R; g = P1_G; b = P1_B; end
        2'd2: begin r = P2_R; g = P2_G; b = P2_B; end
        2'd3: begin r = P3_R; g = P3_G; b = P3_B; end
      endcase
    end
  end

endmodule

`default_nettype wire