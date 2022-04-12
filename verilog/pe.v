`timescale 1 ns/1 ps

module PE (
	input clk, 
	input rstn,
	input fire, 
	input [7:0] in_w, 
	input [7:0] in_a, 
	output out_f,
	output [7:0] out_a,
	output [7:0] out_w,
	output [31:0] out);

	reg out_f_reg;
	reg signed [7:0] out_a_reg, out_w_reg;
	reg signed [31:0] out_reg;
	assign out_f = out_f_reg;
	assign out_a = out_a_reg;
	assign out_w = out_w_reg;
	assign out = out_reg;

	always @ (posedge clk) begin
		if (!rstn) begin
			out_a_reg <= 0;
			out_w_reg <= 0;
			out_f_reg <= 0;
			out_reg <= 0;
		end else begin
			out_f_reg <= fire;
			if (fire) begin
				out_reg <= out_reg + (in_w * in_a);
				out_a_reg <= in_a;
				out_w_reg <= in_w;
			end
		end
	end
endmodule
