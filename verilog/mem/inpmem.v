`timescale 1ns/1ps
`define HOLD_DELAY

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
	reg [sub_mems-1:0] CEN_sub_d;
	reg WEN_d;
	reg [addr_len+7:0] A_d;
	reg [7:0] D_d;


	`ifdef HOLD_DELAY 
		always@(*) #1 CEN_sub_d = CEN_sub;
		always@(*) #1 WEN_d = WEN;
		always@(*) #1 A_d = A;
		always@(*) #1 D_d = D;
	`else
		always@(CEN_sub) CEN_sub_d = CEN_sub;
		always@(WEN) WEN_d = WEN;
		always@(A) A_d = A;
		always@(D) D_d = D;
	`endif

	assign Q = Q_sub[A_out];


    // Instantiate sub memories
    // mem8: 256 words | 8 bits
	genvar i;
	generate
		for(i = 0; i < sub_mems; i = i + 1) begin : generate_mem_8
			mem8 mem8_u(.Q(Q_sub[i]), .CLK(clk), .CEN(CEN_sub_d[i]), .WEN(WEN_d), .A(A_d[7:0]), .D(D_d));
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
