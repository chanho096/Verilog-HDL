module hw8_shifter(din, shift, dout);
	input [31:0] din;
	input [4:0] shift;
	output [31:0] dout;
	wire [31:0] d1, d2, d3, d4;
	
	hw8_nshifter #(1) u1 (din, shift[0], d1);
	hw8_nshifter #(2) u2 (d1, shift[1], d2);
	hw8_nshifter #(4) u3 (d2, shift[2], d3);
	hw8_nshifter #(8) u4 (d3, shift[3], d4);
	hw8_nshifter #(16) u5 (d4, shift[4], dout);	
endmodule