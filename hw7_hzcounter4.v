module hw7_hzcounter4(hex1, hex0, enable, reset, clk_50);
	output [0:6] hex1, hex0;
	input enable, reset, clk_50;
	wire [3:0] t1, t0;
	wire en1, tc;
	reg tick;
	
	hw7_hzsignal(tick, reset, clk_50);
	hw6_counter4 u1 (t0, en1, enable, reset, tick);
	hw6_counter4 u2 (t1, tc, en1, reset, tick);
	
	LED7seg led0 (hex0, t0);
	LED7seg led1 (hex1, t1);

endmodule