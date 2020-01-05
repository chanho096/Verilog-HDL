module clk_256fs(MCLK, clock50);
	// 12.5Mhz ~= 12.288Mhz
	output MCLK;
	input clock50;
	reg clock25, MCLK;
	
	initial begin clock25 = 0; MCLK = 0; end
	always @(posedge clock50) clock25 = ~clock25;
	always @(posedge clock25) MCLK = ~MCLK;
endmodule