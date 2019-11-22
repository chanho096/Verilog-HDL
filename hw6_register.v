module hw6_register(qout, data, sel, clk);
	output [3:0] qout;
	input [3:0] data;
	input [1:0] sel;
	input clk;
	reg [3:0] qout;
	
	always @(posedge clk) begin
		if (sel == 2'b11) qout <= data;
		else if (sel == 2'b01) // rotate right
			qout[3:0] = {qout[0], qout[3:1]};
		else if (sel == 2'b10) // rotate left
			qout[3:0] = {qout[2:0], qout[3]};
	end
endmodule
