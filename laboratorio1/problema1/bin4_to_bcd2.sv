module bin4_to_bcd2(
  input  logic b3,b2,b1,b0,    // {b3,b2,b1,b0} binario 0..15
  output logic       T,    // decena (0 o 1)
  output logic [3:0] ones  // unidades en BCD 0..9
);
  // Decena
  assign T        = b3 & (b2 | b1);

  // Unidades
  assign ones[3]  =  b3 & ~b2 & ~b1;
  assign ones[2]  = (b2 & b1) | (~b3 & b2 & ~b1);
  assign ones[1]  = (~b3 & b1) | (b3 & b2 & ~b1);
  assign ones[0]  =  b0;
endmodule