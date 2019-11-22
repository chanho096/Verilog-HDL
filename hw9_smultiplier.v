module hw9_smultiplier (product, Ready, word1, word2, Start, reset, clk, state);
	parameter N = 4;
	output Ready;
	output [N*2-1:0] product;
	input [N-1:0] word1, word2;
	input Start, clk, reset;
	output [3:0] state;
	wire [3:0] count;
	wire m0, Load, Shift, Add, Sub, End, Enable;
	
	hw9_smuldp u1 (product, m0, word1, word2, Load, Shift, Add, Sub, reset, clk);
	hw9_smulctrl u2 (Load, Shift, Add, Sub, Ready, Enable, m0, Start, End, reset, clk, state);
	hw9_counter u3 (count, Enable, reset, clk);
	assign End = (count==N);
endmodule
