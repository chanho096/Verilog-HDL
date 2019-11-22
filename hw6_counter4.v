module hw6_counter4(qout, tc, enable, reset, clk);
	output [3:0] qout;
	output tc;
	input enable, reset, clk;
	reg [3:0] qout;
	
	always @(posedge clk or negedge reset) begin
		if (~reset) qout <= 0;
		else if (enable) qout <= qout + 1;
	end
	
	assign tc = (qout == 4'b1111) & enable;
endmodule