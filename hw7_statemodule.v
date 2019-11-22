module hw7_statemodule(out, state, w, reset, clk);
	output out;
	output [3:0] state;
	input w, reset, clk;
	reg out;
	reg [3:0] state, nextstate;
	
	always @(posedge clk, negedge reset) begin
		if (~reset) state <= 4'b0000;
		else state <= nextstate;
	end
	
	always @(state or w) begin
		case (state[3:2])
			2'b01: begin // F, G, H, I
				if (w & state[1:0] == 2'b11) begin
					out = 1;
					nextstate = 4'b0111;
				end
				else begin
					out = 0;
					if (w) nextstate = {state[3:2], (state[1:0] + 2'b01)};
					else nextstate = 4'b1000;
				end
			end
			2'b10: begin // B, C, D, E
				if (~w & state[1:0] == 2'b11) begin
					out = 1;
					nextstate = 4'b1011;
				end
				else begin
					out = 0;
					if (~w) nextstate = {state[3:2], (state[1:0] + 2'b01)};
					else nextstate = 4'b0100;
				end
			end
			2'b00: if (w) nextstate = 4'b0100;
				else nextstate = 4'b1000;
			default: nextstate = 4'b0000;
		endcase
	end
endmodule