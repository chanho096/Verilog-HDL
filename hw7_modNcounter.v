module hw7_modNcounter(qout, tc, enable, reset, clk);
	parameter n = 10;
	parameter m = 4;
	output tc;
	output [m-1:0] qout;
	input enable, reset, clk;
	reg [m-1:0] qout;
	reg tc;
	
	always @(posedge clk, negedge reset) begin
		if (~reset) qout <= 0;
		else if (enable) begin
			if (qout == n-1) begin
				qout <= 0;
				tc <= 1;
			end
			else begin
				qout <= qout + 1;
				tc <= 0;
			end
		end
	end

endmodule