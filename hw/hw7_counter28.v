module hw7_counter28(qout, enable, reset, clk);
	output [27:0] qout;
	input enable, reset, clk;
	wire [7:1] en;
	
	hw6_counter4 u1 (qout[3:0], en[1], enable, reset, clk);
	hw6_counter4 u2 (qout[7:4], en[2], en[1], reset, clk);
	hw6_counter4 u3 (qout[11:8], en[3], en[2], reset, clk);
	hw6_counter4 u4 (qout[15:12], en[4], en[3], reset, clk);
	hw6_counter4 u5 (qout[19:16], en[5], en[4], reset, clk);
	hw6_counter4 u6 (qout[23:20], en[6], en[5], reset, clk);
	hw6_counter4 u7 (qout[27:24], en[7], en[6], reset, clk);
endmodule