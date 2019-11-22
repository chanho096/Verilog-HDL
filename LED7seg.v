module LED7seg(display, bcd);
	output [6:0] display;
	input [3:0] bcd;
	reg [6:0] display;
	always @(bcd) begin
		case (bcd)
			0: display = 7'b111_1110;
			1: display = 7'b011_0000;
			2: display = 7'b110_1101;
			3: display = 7'b111_1001;
			4: display = 7'b011_0011;
			5: display = 7'b101_1011;
			6: display = 7'b101_1111;
			7: display = 7'b111_0000;
			8: display = 7'b111_1111;
			9: display = 7'b111_1011;
			10: display = 7'b111_0111;
			11: display = 7'b001_1111;
			12: display = 7'b100_1110;
			13: display = 7'b011_1101;
			14: display = 7'b100_1111;
			15: display = 7'b100_0111;
			default: display = 7'b000_0000;
		endcase
		display = ~display;
	end
endmodule