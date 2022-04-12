`timescale 1ns/1ps

module inpmem
	#(parameter sub_mems = 128)
	(Q, clk, CEN, WEN, A, D);

	wire [0:sub_mems-1] CEN_sub; 	//chip enables for each mem8

	wire [7:0] Q_sub [0:sub_mems-1];   	//output from each mem8

	//input and outputs
	input clk;
	input [14:0] A;
	input [7:0] D;
	input CEN;
	input WEN;
    // WEN and CEN are active low
	output wire [7:0] Q;
	wire [7:0] Q_ff;
	reg [7:0] A_out;
	//wire [7:0] A_sub;

	//assign A_sub = A[7:0];

	assign Q = Q_sub[A_out];
	genvar i;
	generate
		for(i = 0; i < sub_mems; i = i + 1) begin : generate_mem_8
			mem8 mem8_u(.Q(Q_sub[i]), .CLK(clk), .CEN(CEN_sub[i]), .WEN(WEN), .A(A[7:0]), .D(D));
			assign CEN_sub[i] = ((A[14:8] == i) & ~CEN) ? 0 : 1;
		end
	endgenerate

	always @(posedge clk)
	begin
		if(CEN == 0) begin
			A_out <= A[14:8];
		end
	end
endmodule