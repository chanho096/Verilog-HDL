module AUD_inout (
	AUD_DACLRCK,
	AUD_DACDAT,
	AUD_ADCLRCK,
	AUD_ADCDAT,
	AUD_BCLK,
	MCLK,
	
	AUD_RW, // RW = 0 일때 READ
	AUD_ADDR1, // Start Address
	AUD_ADDR2, // End Address
	MEM_CURRENT, // Current Address
	MEM_DATA, // Memory Data
	MEM_Q, // Memory Q
	
	enable,
	done,
	reset
);
	inout AUD_DACLRCK, AUD_ADCLRCK;
	output AUD_DACDAT, AUD_BCLK, done;
	input AUD_ADCDAT, AUD_RW, MCLK, enable, reset;
	// 48 * 32 * 8khz = 12.288mhz
	input [17:0] AUD_ADDR1, AUD_ADDR2;
	input [15:0] MEM_Q;
	output [15:0] MEM_DATA;
	output [17:0] MEM_CURRENT;
	
	reg [7:0] clk_count;
	reg [4:0] d_count;
	reg [2:0] state;
	reg BCLK, AUD_DACLRCK, AUD_ADCLRCK, AUD_DACDAT, RW;
	reg [15:0] DATL, DATR;
	reg [17:0] addr, addr_e;
	reg load;
	localparam S0=0, S1=1, S2=2, S3=3;
	
	initial clk_count = 0;	
	always @ (posedge MCLK) begin
		if (clk_count < 24) BCLK = 0;
		else BCLK = 1;
		
		if (clk_count < 47) clk_count = clk_count+1;
		else clk_count = 0;
	end
	
	always @ (negedge BCLK or negedge reset) begin
		if (~reset) begin state <= S0; AUD_DACLRCK <= 1; 
			addr <= 0; addr_e <= 0; load <= 0; RW <= 0;
		end else if (~load & enable) begin
			addr <= AUD_ADDR1; addr_e <= AUD_ADDR2; load <= 1; RW <= AUD_RW;
			// BCLK 1 cycle은 충분히 memory setup time 을 보장한다.
		end else begin
			case (state)
				S0: if (enable & (addr < addr_e)) begin 
						if (~RW) begin AUD_DACLRCK <= 0; AUD_DACDAT = 1'bz; // AUDIO Out
							DATL <= MEM_Q; DATR <= MEM_Q; 
						end else begin // AUDIO In
							DATL <= 0; AUD_ADCLRCK <= 0; 
						end
						state <= S1; d_count <= 16;
					end
				S1: begin d_count = d_count-1;
						if (~RW) begin AUD_DACDAT = DATL[15]; DATL[15:0] = {DATL[14:0], 1'b0}; end
						else begin DATL[15:0] = {DATL[14:0], 1'b0}; DATL[0] = AUD_ADCDAT; end
						if (d_count == 0) state <= S2;
					end
				S2: begin state <= S3; d_count <= 16; 
						if (~RW) begin AUD_DACDAT = 1'bz; AUD_DACLRCK <= 1; end 
						else AUD_ADCLRCK <= 1;
					end
				S3: begin d_count = d_count-1;
						if (~RW) begin AUD_DACDAT = DATR[15]; DATR[15:0] = {DATR[14:0], 1'b0}; end
						if (d_count == 0) begin state <= S0; addr <= addr + 1; end
					end
			endcase
		end
	end
	
	assign MEM_DATA = ((state == S3) & RW) ? DATL : 16'bz;
	assign MEM_CURRENT = addr;
	assign done = (state==S0) & (addr == addr_e);	
	assign AUD_BCLK = BCLK;
endmodule