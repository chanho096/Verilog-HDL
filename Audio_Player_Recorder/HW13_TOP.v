module HW13_TOP (
	// FPGA OUPUTcx
	LEDR,
	LEDG,
	
	// FPGA INPUT
	CLOCK_50,
	SW,
	KEY,
	
	// AUDIO (WM8731) INTERFACE
	AUD_ADCLRCK,
	AUD_ADCDAT,
	AUD_DACLRCK,
	AUD_DACDAT,
	AUD_XCK,
	AUD_BCLK,
	I2C_SCLK,
	I2C_SDAT
);
	// FPGA I/O
	output [17:0] LEDR; 
	output [8:0] LEDG;
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	
	// AUDIO I/O
	output AUD_BCLK, AUD_XCK, AUD_DACDAT, I2C_SCLK;
	input AUD_ADCDAT;
	inout I2C_SDAT, AUD_ADCLRCK, AUD_DACLRCK;
	
	wire AUDINF_INIT, AUDINF_RESET, AUDINF_START, AUDINF_NEXT,
		AUDINF_PLAY, AUDINF_RESTART, AUDINF_VOLDOWN, AUDINF_VOLUP,
		AUDINF_MODE, AUDINF_ISREADY, AUDINF_ISPLAY;
	wire [1:0] AUDINF_SELECT;	
	reg [15:0] AUD_inst;
	wire [15:0] CPU_inst;
	
	AUD_main u1 (AUD_ADCLRCK, AUD_ADCDAT, AUD_DACLRCK, AUD_DACDAT, AUD_XCK, AUD_BCLK,
	I2C_SCLK, I2C_SDAT, CLOCK_50, AUDINF_INIT, AUDINF_RESET, AUDINF_START, AUDINF_NEXT,
		AUDINF_PLAY, AUDINF_RESTART, AUDINF_VOLDOWN, AUDINF_VOLUP,
		AUDINF_MODE, AUDINF_ISREADY, AUDINF_ISPLAY, AUDINF_SELECT);
	
	assign AUDINF_INIT = (~SW[0] | KEY[3]) & AUD_inst[0];
	assign AUDINF_RESET = (~SW[0] | KEY[2]) & AUD_inst[1];
	assign AUDINF_START = (~SW[0] | KEY[1]) & AUD_inst[2];
	assign AUDINF_NEXT = (~SW[0] | KEY[0]) & AUD_inst[3];
	
	assign AUDINF_PLAY = (SW[0] | KEY[3]) & AUD_inst[4];
	assign AUDINF_RESTART = (SW[0] | KEY[2]) & AUD_inst[5];
	assign AUDINF_VOLDOWN = (SW[0] | KEY[1]) & AUD_inst[6];
	assign AUDINF_VOLUP = (SW[0] | KEY[0]) & AUD_inst[7];
	
	assign LEDG[1:0] = AUDINF_SELECT;
	assign LEDG[7:6] = {AUDINF_ISREADY, AUDINF_ISPLAY};
	
	initial AUD_inst = 8'b1111_1111;
	always @ (CPU_inst) begin
		AUD_inst = 8'b1111_1111;
		case (CPU_inst)
			16'h2000: AUD_inst[0] = 0;
			16'h2001: AUD_inst[1] = 0;
			16'h2002: AUD_inst[2] = 0;
			16'h2003: AUD_inst[3] = 0;
			16'h2004: AUD_inst[4] = 0;
			16'h2005: AUD_inst[5] = 0;
			16'h2006: AUD_inst[6] = 0;
			16'h2007: AUD_inst[7] = 0;
			default: AUD_inst = 8'b1111_1111;
		endcase
	end
endmodule