module hw9_mulctrl (Load, Shift, Add, Ready, Enable, m0, Start, End, reset, clk, state);
	output Load, Shift, Add, Ready, Enable;
	input m0, Start, End, reset, clk;
	output [3:0] state;
	reg [3:0] state, next_state;
	parameter S0 = 0, S1 = 1, S2 = 2;
	reg Load, Shift, Add, Enable;
	wire Ready;
	
	// State transition
	always @ (posedge clk or posedge reset) begin
		if (reset) state <= S0;
		else state <= next_state;
	end
	
	always @ (state or Start or End or m0) begin
		Load = 0; Shift = 0; Add = 0; Enable = 0;
		if (End) next_state = S0;
		else begin
			case (state)
				S0: if (Start) begin Load = 1; next_state = S1; end
					else next_state = S0;
				S1: if (m0) begin Add = 1; next_state = S2; end
					else begin Shift = 1; next_state = S1; Enable = 1; end
				S2: begin Shift = 1; next_state = S1; Enable = 1; end
				default: next_state = S0;
			endcase
		end
	end
	
	assign Ready = (state==S0) && ~reset;
endmodule