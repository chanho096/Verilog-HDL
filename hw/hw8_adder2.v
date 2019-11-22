module hw8_adder2(sub, a, b, cin, s, cout);
	input sub;
	input [3:0] a, b;
	input cin;
	output [3:0] s;
	output cout;
	
	assign cin2 = sub ? ~cin : cin;
	assign {cout2, s} = sub ? a - b - cin: a + b + cin;

endmodule