module hw9_smuldp (product, m0, word1, word2, Load, Shift, Add, Sub, reset, clk);
	output [7:0] product;
	output m0;
	input [3:0] word1, word2;
	input Load, Shift, Add, Sub, reset, clk;
	reg [8:0] eproduct;
	reg [3:0] multiplier;
	reg [4:0] multiplicand;
	reg c_out;
	wire m0;
	
	assign m0 = multiplier[0];
	assign product = eproduct[7:0];
	
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			multiplicand <= 0; multiplier <= 0; eproduct <= 0;
		end else if (Load) begin
			multiplicand <= {word1[3], word1}; multiplier <= word2; eproduct <= 0;
		end else if (Shift) begin
			multiplier <= multiplier >> 1;
			eproduct <= {eproduct[8], eproduct[8:1]};
		end else if (Add) begin
			eproduct[8:4] <= eproduct[8:4] + multiplicand;
		end else if (Sub) begin
			eproduct[8:4] <= eproduct[8:4] - multiplicand;
		end
	end
endmodule
