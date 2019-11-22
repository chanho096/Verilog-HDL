module hw7_hzsignal(qout, reset, clk_50);
	output qout;
	input reset, clk_50;

	reg qout;
	wire tc;
	wire [27:0] ticktock;
	
	always @(posedge tc or negedge reset) begin
		if (~reset) qout <= 0;
		else if (tc) qout <= ~qout;
	end
	
	hw7_counter25m u1 (ticktock, tc, 1'b1, reset, clk_50);
	
endmodule