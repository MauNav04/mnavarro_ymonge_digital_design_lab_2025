module bin2gray(
	input logic a,b,c,d,
	output logic w,x,y,z
);

assign w = a;
assign x = a ^ b;
assign y = b ^ c;
assign z = c ^ d;

endmodule
