module hw7_clock(hex1, hex0, enable, reset, clk_50);
	output [0:6] hex1, hex0;
	input enable, reset, clk_50;
	wire [3:0] t1, t0;
	wire hz, hz10, tc;
	
	hw7_hzsignal u1(hz, reset, clk_50);
	hw7_modNcounter #(.n(10), .m(4)) u2 (t0, hz10, enable, reset, hz);
	hw7_modNcounter #(.n(6), .m(4)) u3 (t1, tc, enable, reset, hz10);
	
	LED7seg led0 (hex0, t0);
	LED7seg led1 (hex1, t1);
endmodule