module AUD_mem (
	addr,
	CLOCK_50,
	q
);
	/*
		addr EVENT 감지하여 해당 주소값의 데이터를 q값에 상주시켜야한다.
	*/
	input [17:0] addr;
	input CLOCK_50;
	output [15:0] q;
	wire data;
	
	mem u4 (addr, CLOCK_50, data, 0, q);

endmodule