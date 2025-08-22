module top_bin2gray_hex7seg(
  input  logic a,b,c,d,        // BIN de entrada (a = MSB)
  output logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g // a..g
);
  // 1) Bin -> Gray
  logic w,x,y,z;               // Gray = {w,x,y,z} = {g3,g2,g1,g0}
  bin2gray U0 (
    .a(a), .b(b), .c(c), .d(d),
    .w(w), .x(x), .y(y), .z(z)
  );

  // 2) Gray (4b) -> 7 segmentos HEX (ánodo común: 0=ON)
  seven_segments_hex U1 (
    .A3(w), .A2(x), .A1(y), .A0(z),   // ¡ojo al orden!
    .a(seg_a), .b(seg_b), .c(seg_c), .d(seg_d),
    .e(seg_e), .f(seg_f), .g(seg_g)
  );

  // Si tu display fuera CÁTODO COMÚN (1=ON), invierte:
  // assign {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} =
  //       ~{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g};

endmodule