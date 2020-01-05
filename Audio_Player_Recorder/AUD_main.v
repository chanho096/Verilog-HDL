module AUD_main (
	// AUDIO (WM8731) INTERFACE
	AUD_ADCLRCK,
	AUD_ADCDAT,
	AUD_DACLRCK,
	AUD_DACDAT,
	AUD_XCK,
	AUD_BCLK,
	I2C_SCLK,
	I2C_SDAT,
	CLOCK_50,
	
	// AUDIO Control Interface
	AUDINF_INIT,
	AUDINF_RESET,
	AUDINF_START,
	AUDINF_NEXT,
	
	// AUDIO Manipulate Interface
	AUDINF_PLAY,
	AUDINF_RESTART,
	AUDINF_VOLDOWN,
	AUDINF_VOLUP,

	// AUDIO State Interface
	AUDINF_MODE,
	AUDINF_ISREADY,
	AUDINF_ISPLAY,
	AUDINF_SELECT
);
	// AUDIO I/O
	output AUD_BCLK, AUD_XCK, AUD_DACDAT, I2C_SCLK;
	input AUD_ADCDAT, CLOCK_50;
	inout I2C_SDAT, AUD_ADCLRCK, AUD_DACLRCK;
	
	// AUDIO Control Interface
	input AUDINF_INIT, AUDINF_RESET, AUDINF_START, AUDINF_NEXT;
	
	// AUDIO Manipulate Interface
	input AUDINF_PLAY, AUDINF_VOLUP, AUDINF_VOLDOWN, AUDINF_RESTART;
	
	// AUDIO State Interface
	output AUDINF_MODE, AUDINF_ISREADY, AUDINF_ISPLAY;
	output [1:0] AUDINF_SELECT;
	
	/*
		AUDIO Main 작동 설명
		* AUDIO INTERFACE 는 CLOCK에 동기화, low level 에서 동작한다.
		
		1. AUDIO Control Interface
			AUDIO 가 비작동 상태일 때에만 Control Interface 사용 가능
			- INIT : WM8731 동작 초기화
			- START : 작동 상태로 변환
			- RESET : 비작동 상태로 변환
			- SELECT : 오디오 시작주소 및 종료주소 변경
		
		2. AUDIO Manipulate Interface
			AUDIO 가 작동 상태일 때에만 Manipulate Interface 사용 가능
			- AUDINF_PLAY : PLAY / PAUSE Toggle
			- AUDINF_RESTART : 시작 주소로 변경
			- AUDINF_VOLUP : Volume Up
			- AUDINF_VOLDOWN : Volume Down
	*/
	
	reg [6:0] volume;
	reg ctrl, play;
	reg [1:0] select;
	reg [25:0] delay;
	wire [17:0] addr, addr1, addr2;
	wire [15:0] q, data;
	wire idle_inout, idle_init;
	localparam SELECT_MAX=3, VOLUME_MAX=127, VOLUME_TERM=30, DELAY_MAX=25000000;
	
	// 12.5 ~= 122.88 Mhz 'XCK/MCLK 생성
	clk_256fs u1 (AUD_XCK, CLOCK_50);
	
	// AUDIO Initialization with i2c interface
	AUD_init u2 (I2C_SCLK, I2C_SDAT, volume, ~select[1], (ctrl & ~AUDINF_INIT) | ~AUDINF_VOLUP | ~AUDINF_VOLDOWN, idle_init, AUDINF_RESET, CLOCK_50);
		
	// AUDIO In-Out
	AUD_inout u3 (AUD_DACLRCK, AUD_DACDAT, AUD_ADCLRCK, AUD_ADCDAT, AUD_BCLK, AUD_XCK,
		select[1], addr1, addr2, addr, data, q, play, idle_inout, AUDINF_RESET & AUDINF_RESTART); 
	mem u5 (addr, CLOCK_50, data, select[1], q);
	// AUDIO Memory Interface
	//AUD_mem u4 (addr, CLOCK_50, q);

	assign AUDINF_MODE = ctrl;
	assign AUDINF_ISREADY = idle_init & idle_inout;
	assign AUDINF_ISPLAY = ~idle_inout;
	assign AUDINF_SELECT = select;
	assign addr1 = ~select[0] ? 18'b00_0000_0000_0000_0000 : 18'b01_1011_0101_1000_0000;
	assign addr2 = ~select[0] ? 18'b01_1011_0101_1000_0000 : 18'b10_1110_1110_0000_0000;	

	initial begin volume <= 7'b1111001; delay <= 0; select <= 0; end
	always @ (posedge CLOCK_50 or negedge AUDINF_RESET) begin
		// AUDIO Control Interface
		if (~AUDINF_RESET) begin
			// RESET
			ctrl <= 1; play <= 0; select <= 0; delay <= 0;
		end else if (ctrl & AUDINF_ISREADY & ~AUDINF_START) begin
			// START
			ctrl <= 0; play <= 1;
		end else begin
		// AUDIO Interface with 0.5 sec delay
			if (delay > 0) delay <= delay-1; // 0.5초 Delay
			else if (~ctrl & ~AUDINF_PLAY) begin
				// Play / Pause Toggle
				play <= ~play; delay <= DELAY_MAX;
			end else if (~ctrl & ~AUDINF_VOLUP) begin
				// Volume UP
				if (volume > VOLUME_MAX - VOLUME_TERM) volume <= VOLUME_MAX;
				else volume <= volume+VOLUME_TERM;
				delay <= DELAY_MAX;
			end else if (~ctrl & ~AUDINF_VOLDOWN) begin
				// Volume Down
				if (volume < VOLUME_TERM) volume <= 0;
				else volume <= volume-VOLUME_TERM;
				delay <= DELAY_MAX;
			end else if (ctrl & AUDINF_ISREADY & ~AUDINF_NEXT) begin
				// SELECT NEXT
				if (select < SELECT_MAX) select <= select+1;
				else select <= 0;
				delay <= DELAY_MAX;
			end
		end
	end
	
endmodule