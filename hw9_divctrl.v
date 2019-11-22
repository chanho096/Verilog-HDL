module hw9_divctrl (Load, Shift, Sub, Compare, Ready, Enable, Start, End, reset, clk, state);
	output Load, Shift, Sub, Compare, Ready, Enable;
	input Start, End, reset, clk;
	output [3:0] state;
	reg [3:0] state, next_state;
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
	reg Load, Shift, Sub, Compare, Enable;
	wire Ready;
	
	// State transition
	always @ (posedge clk or posedge reset) begin
		if (reset) state <= S0;
		else state <= next_state;
	end
	
	always @ (state or Start or End) begin
		Load = 0; Shift = 0; Sub = 0; Compare = 0; Enable = 0;
		if (End) next_state = S0;
		else begin
			case (state)
				S0: if (Start) begin Load = 1; next_state = S1; end
					else next_state = S0;
				S1: begin Shift = 1; next_state = S2; end
				S2: begin Sub = 1; next_state = S3; end
				S3: begin Compare = 1; next_state = S1; Enable = 1; end
				default: next_state = S0;
			endcase
		end
	end
	
	assign Ready = (state==S0) && ~reset;
endmodule