module PE_Lin(
	input clk,
	input rstn,
	input fire,
	input[7:0] in_w1,
	input[7:0] in_w2,
	input[7:0] in_w3,
	input[7:0] in_w4,
	input[7:0] in_a,
	output[11:0] o1,
	output[11:0] o2,
	output[11:0] o3,
	output[11:0] o4
	);

	wire fo1, fo2, fo3, fo4;
	wire[7:0] ao1, ao2, ao3, ao4;
	wire[11:0] o1, o2, o3, o4;
	
	PE PE1 (clk, rstn, fire, in_w1, in_a, fo1, ao1, o1);
	PE PE2 (clk, rstn, fo1, in_w2, ao1, fo2, ao2, o2);
	PE PE3 (clk, rstn, fo2, in_w3, ao2, fo3, ao3, o3);
	PE PE4 (clk, rstn, fo3, in_w4, ao3, fo4, ao4, o4);

endmodule
