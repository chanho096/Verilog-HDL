module hw6_top(hex1, hex0, enable, reset, clk);
	output [0:6] hex1, hex0;
	input enable, reset, clk;
	wire [3:0] t1, t0;
	wire en1, tc;
	
	hw6_counter4 u1 (t0, en1, enable, reset, clk);
	hw6_counter4 u2 (t1, tc, en1, reset, clk);
	
	LED7seg led0 (hex0, t0);
	LED7seg led1 (hex1, t1);

endmodule