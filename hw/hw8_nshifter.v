module hw8_nshifter(din, select, dout);
	parameter n = 1;
	input select;
	input [31:0] din;
	output [31:0] dout;
	wire [31:0] d;
	
	assign dout[31:0] = select ? din[31 - n:0] : din[31:0];
endmodule