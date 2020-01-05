module AUD_init (
	I2C_SCLK,
	I2C_SDAT,
	
	volume,
	isout,
	start,
	done,
	reset,
	CLOCK_50 // 50 Mhz, T = 20ns
);
	output I2C_SCLK, done;
	inout I2C_SDAT;
	input isout, start, reset, CLOCK_50;
	input [6:0] volume;
	reg [7:0] addr1;
	reg [6:0] addr2;
	reg [8:0] data;
	reg [2:0] state;
	reg [3:0] count;
	reg done;
	reg [3:0] index; // Index of Command Table
	wire I2C_START, I2C_IDLE;
	
	localparam S0=0, S1=1, S2=2, S3=3, S4=4, S5=5;
	localparam INIT=1;
	localparam LAST=INIT+7;
	localparam T_DELAY = 100/20; // 1 us Delay
	
	// I2C Interface
	assign I2C_START = (state == S2);
	AUD_i2c u1 (I2C_SCLK, I2C_SDAT, addr1, addr2, data, I2C_START, I2C_IDLE, reset, CLOCK_50);

	// STATE MACHINE
	always @(posedge CLOCK_50, negedge reset) begin
		if (~reset) begin
			addr1 <= 8'b0011_0100;
			state <= S0; index <= 0; count <= 0;
		end else
			case (state)
				S0: if (start) begin state <= S1; index <= INIT; count <= T_DELAY; end
				S1: if (count == 0) state <= S2; // Setup Time of first address update
					else count = count-1;
				S2: if (count == 0) state <= S3; // I2C Data Write
					else count = count-1;
				S3: if (I2C_IDLE) state <= S4;
				S4: begin
						index = index+1;
						if (index == LAST) state <= S0;
						else begin state <= S5; count <= T_DELAY; end
					end
				S5: if (count == 0) begin state <= S2; count <= T_DELAY; end
					else count = count-1;
				default state <= S0;
			endcase
	end
	
	// Command Table
	always @(posedge CLOCK_50) begin
		done = 0;
		case (index)
			INIT: begin addr2 = 7'b000_0110; data = 9'b000000001; end // Power Setting
			INIT+1: begin addr2 = 7'b000_0010; data = {3'b101, volume}; end // Headphone out
			INIT+2: begin addr2 = 7'b000_0100; data = {3'b000, ~isout, isout, 4'b0101}; end // ADC path
			INIT+3: begin addr2 = 7'b000_0101; data = {5'b00000, ~isout, 3'b000}; end // DAC path
			INIT+4: begin addr2 = 7'b000_0111; data = {8'b00000001, ~isout}; end // Digital Audio Interface
			INIT+5: begin addr2 = 7'b000_1000; data = 9'b000001100; end // Sampling Control
			INIT+6: begin addr2 = 7'b000_1001; data = 9'b000000001; end // Activate Interface
			LAST: done = 1;
			default: done = 1;
		endcase
	end
endmodule