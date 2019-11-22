module hw9_sdivdp (quotient, reminder, word1, word2, Load, Shift, Sub, Compare, reset, clk);
	output [3:0] quotient, reminder;
	input [7:0] word1;
	input [3:0] word2;
	input Load, Shift, Sub, Compare, reset, clk;
	reg [8:0] dividend;
	reg [4:0] diff;
	reg [3:0] divisor;
	reg sign1, sign2;
	
	assign quotient = (sign1==sign2) ? dividend[3:0] : (~dividend[3:0] + 1'b1);
	assign reminder = dividend[7:4];
	
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			dividend <= 0; divisor <= 0; diff <= 0; sign1 <= 0; sign2 <= 0;
		end else if (Load) begin
			dividend <= word1; divisor <= word2; diff <= 0;
			sign1 <= word1[7]; sign2 <= word2[3];
		end else if (Shift) begin
			dividend <= dividend << 1;
		end else if (Sub) begin
			if (dividend[8] == divisor[3]) diff <= dividend[8:4] - {divisor[3], divisor};
			else diff <= dividend[8:4] + {divisor[3], divisor};
		end else if (Compare) begin
			if (dividend[8] == diff[4] || diff==0) begin
				dividend[0] <= 1;
				dividend[8:4] <= diff;
			end
			else dividend[0] <= 0;
		end
	end
endmodule