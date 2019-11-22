module hw8_adder(sub, a, b, cin, s, cout);
	input sub;
	input [3:0] a, b;
	input cin;
	output [3:0] s;
	output cout;
	
	wire [3:0] b2;
	wire cin2, cout2;
	
	assign b2 = sub ? ~b : b;
	assign cin2 = sub ? ~cin : cin;
	assign {cout2, s} = a + b2 + cin2;
	assign  cout = sub ? ~cout2 : cout2;
endmodule