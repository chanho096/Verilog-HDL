module hw9_muldp (product, m0, word1, word2, Load, Shift, Add, reset, clk);
	output [7:0] product;
	output m0;
	input [3:0] word1, word2;
	input Load, Shift, Add, reset, clk;
	reg [7:0] product;
	reg [3:0] multiplier, multiplicand;
	reg c_out;
	wire m0;
	
	assign m0 = multiplier[0];
	
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			multiplicand <= 0; multiplier <= 0; product <= 0;
		end else if (Load) begin
			multiplicand <= word1; multiplier <= word2; product <= 0;
		end else if (Shift) begin
			multiplier <= multiplier >> 1;
			{c_out, product} <= {c_out, product} >> 1;
		end else if (Add) begin
			{c_out, product[7:4] } <= product[7:4] + multiplicand;
		end
	end
endmodule