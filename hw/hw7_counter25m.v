module hw7_counter25m(qout, tc, enable, reset, clk);
	output [27:0] qout;
	output tc;
	input enable, reset, clk;
	wire rst;
	
	hw7_counter28 u1 (qout, enable, ~rst, clk);
	assign rst = ~reset || tc;
	assign tc = (qout == 24_999_999) & enable;
endmodule