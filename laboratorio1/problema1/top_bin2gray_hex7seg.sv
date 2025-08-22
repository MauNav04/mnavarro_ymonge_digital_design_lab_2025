module top_bin2gray_hex7seg(
  input  logic a,b,c,d, 
  output logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g
);
  // 1) Bin -> Gray
  logic w,x,y,z;             
  bin2gray U0 (
    .a(a), .b(b), .c(c), .d(d),
    .w(w), .x(x), .y(y), .z(z)
  );

  // 2) Gray (4b)
  seven_segments_hex U1 (
    .A3(w), .A2(x), .A1(y), .A0(z), 
    .a(seg_a), .b(seg_b), .c(seg_c), .d(seg_d),
    .e(seg_e), .f(seg_f), .g(seg_g)
  );

endmodule