module hw9_divdp (quotient, reminder, word1, word2, Load, Shift, Sub, Compare, reset, clk);
	output [3:0] quotient, reminder;
	input [7:0] word1;
	input [3:0] word2;
	input Load, Shift, Sub, Compare, reset, clk;
	reg [8:0] dividend;
	reg [4:0] diff;
	reg [3:0] divisor;
	
	assign quotient = dividend[3:0];
	assign reminder = dividend[7:4];
	
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			dividend <= 0; divisor <= 0; diff <= 0;
		end else if (Load) begin
			dividend <= word1; divisor <= word2; diff <= 0;
		end else if (Shift) begin
			dividend <= dividend << 1;
		end else if (Sub) begin
			diff <= dividend[8:4] - {1'b0, divisor};
		end else if (Compare) begin
			if (diff[4]==1) dividend[0] <= 0;
			else begin dividend[0] <= 1;
				dividend[8:4] <= diff;
			end
		end
	end
endmodule