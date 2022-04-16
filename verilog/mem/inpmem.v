`timescale 1ns/1ps

module INPMEM 
	#(parameter sub_mems = 256, parameter addr_len = 8)
	(Q, clk, CEN, WEN, A, D);
	
	wire [sub_mems-1:0] CEN_sub;        //chip enables for each mem8
	wire [7:0] Q_sub [0:sub_mems-1];   	//output from each mem8

	//input and outputs
	input clk;
	input [addr_len+7:0] A;
	input [7:0] D;
	input CEN;
	input WEN;
	output wire [7:0] Q;
	reg [addr_len-1:0] A_out;


	assign Q = Q_sub[A_out];

    // Instantiate sub memories
    // mem8: 256 words | 8 bits
	genvar i;
	generate
		for(i = 0; i < sub_mems; i = i + 1) begin : generate_mem_8
			mem8 mem8_u(.Q(Q_sub[i]), .CLK(clk), .CEN(CEN_sub[i]), .WEN(WEN), .A(A[7:0]), .D(D));
			assign CEN_sub[i] = ((A[addr_len+7:8] == i) & ~CEN) ? 0 : 1;
		end
	endgenerate

	always @(posedge clk)
	begin
		if(CEN == 0) begin
			A_out <= A[addr_len+7:8];
		end
	end

endmodule