module hw9_counter(count, Enable, reset, clk);
	parameter N = 4;
	output [N-1:0] count;
	input Enable, reset, clk;
	reg [N-1:0] count;
	
	always @ (posedge clk)
		if (reset) count <= 0;
		else if (Enable) count <= count + 1;
endmodule