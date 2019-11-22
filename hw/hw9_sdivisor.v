module hw9_sdivisor (quotient, reminder, Ready, word1, word2, Start, reset, clk, state);
	output [3:0] quotient, reminder;
	output Ready;
	input [7:0] word1;
	input [3:0] word2;
	input Start, reset, clk;
	output [3:0] state;
	wire [3:0] count;
	wire Load, Shift, Sub, Compare, End, Enable;
	
	hw9_sdivdp u1 (quotient, reminder, word1, word2, Load, Shift, Sub, Compare, reset, clk);
	hw9_sdivctrl u2 (Load, Shift, Sub, Compare, Ready, Enable, Start, End, reset, clk, state);
	hw9_counter u3 (count, Enable, reset, clk);
	assign End = (count==4);
	
endmodule