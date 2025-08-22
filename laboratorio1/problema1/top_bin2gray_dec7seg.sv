module top_bin2gray_dec7seg(
  input  logic a,b,c,d,  // binary in (a=MSB)
  output logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g,      // tens
  output logic seg2_a, seg2_b, seg2_c, seg2_d, seg2_e, seg2_f, seg2_g // ones
);
  // Bin -> Gray
  logic w,x,y,z;
  
  bin2gray U0 (.a(a), .b(b), .c(c), .d(d), .w(w), .x(x), .y(y), .z(z));

  // Gray -> BCD (tens/ones)
  logic T;
  logic [3:0] ones;
  bin4_to_bcd2 U1 (.b3(w), .b2(x), .b1(y), .b0(z), .T(T), .ones(ones));

  // Tens (0 or 1) -> 7seg
  seven_segments_hex U2 (
    .A3(1'b0), .A2(1'b0), .A1(1'b0), .A0(T),
    .a(seg_a), .b(seg_b), .c(seg_c), .d(seg_d),
    .e(seg_e), .f(seg_f), .g(seg_g)
  );

  // Ones (0..9) -> 7seg
  seven_segments_hex U3 (
    .A3(ones[3]), .A2(ones[2]), .A1(ones[1]), .A0(ones[0]),
    .a(seg2_a), .b(seg2_b), .c(seg2_c), .d(seg2_d),
    .e(seg2_e), .f(seg2_f), .g(seg2_g)
  );

endmodule