// i2c INTERFACE
module AUD_i2c (
	// i2c OUTPUT
	I2C_SCLK,
	I2C_SDAT,
	
	// i2c INPUT
	I2C_ADDR1, // SLAVE_ADDRESS + RW
	I2C_ADDR2, // SUB_ADDRESS (REGISTER)
	I2C_DATA, // 9 bit information
	
	enable,
	done,
	reset,
	CLOCK_50 // 50 Mhz, T = 20ns
);
	output I2C_SCLK, done;
	inout I2C_SDAT;
	input [7:0] I2C_ADDR1;
	input [6:0] I2C_ADDR2;
	input [8:0] I2C_DATA;
	input enable, reset, CLOCK_50;

	reg I2C_SCLK, SDIN, RW;
	reg [2:0] state;
	reg [10:0] clk_count;
	reg [4:0] d_count;
	reg [26:0] DATA;
	localparam T_ENABLE = 600/2; // Start setup time = 600ns
	localparam T_STOP = 600/2; // Stop setup time = 600ns
	localparam T_hSCL = 1300/2/2; // half of SCLK low pulse width = 1.3us / 2
	localparam T_SCH = 1300/2; // SCLK high pulse width = 600ns
	localparam S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7;
	
	always @(posedge CLOCK_50, negedge reset) begin
		if (~reset) begin 
			state <= S0; DATA <= 0; I2C_SCLK <= 1; SDIN <= 1; RW <= 0;
		end else
			case (state)
				// DATA LOAD
				S0: if (enable) begin
						DATA <= {I2C_ADDR1, 1'bz, I2C_ADDR2, I2C_DATA[8], 1'bz, I2C_DATA[7:0], 1'bz};
						clk_count <= T_ENABLE; d_count <= 27; SDIN <= 0; 
						state <= S1; 
					end
					
				// SETUP Delay	
				S1: if (clk_count == 0) begin clk_count = T_hSCL; I2C_SCLK = 0; state = S2; end 
						else clk_count = clk_count-1;
				
				// half of SCLK low pulse (Before write)
				S2: if (clk_count == 0) state <= S3;
					else clk_count = clk_count-1;
				
				// SDAT WRITE
				S3: begin
						SDIN <= DATA[26]; DATA <= {DATA[25:0], 1'b0}; 
						if (d_count == 0) state <= S6;
						else begin state <= S4; d_count = d_count-1; end
						clk_count = T_hSCL;
					end
				
				// half of SCLK low pulse (After write)
				S4: if (clk_count == 0) begin I2C_SCLK = 1; state <= S5; clk_count = T_SCH; end
					else clk_count = clk_count-1;
					
				// SCLK high pulse
				S5: begin if (d_count == 18 | d_count == 9 | d_count == 0) RW=1; // ACK
					if (clk_count == 0) begin I2C_SCLK = 0; state <= S2; clk_count = T_hSCL; RW=0; end
					else clk_count = clk_count-1; end
				
				// half of SCLK low pulse before STOP
				S6: if (clk_count == 0) begin I2C_SCLK = 1; state <= S7; clk_count = T_STOP; end
					else clk_count = clk_count-1;
					
				S7: if (clk_count == 0) begin SDIN = 1; state <= S0; end
					else clk_count = clk_count-1;
				default: state <= S0;
			endcase
	end
	
	assign #2 done = (state==S0);
	assign I2C_SDAT = RW ? 1'bz : SDIN;
endmodule