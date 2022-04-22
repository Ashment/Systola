`timescale 1 ns/1 ps

module PE #(
	parameter OUTWIDTH=32
	)(
	input clk, 
	input rstn,
	input fire, 
	input [7:0] in_w,
	input [7:0] in_a,
	output reg out_f,
	output reg [7:0] out_a,
	output reg [7:0] out_w,
	output reg [OUTWIDTH:0] out_r,
	output reg resvalid);
	
	reg fireprev;

	always_ff @ (posedge clk) begin
		if (!rstn) begin
			fireprev <= 0;
			out_a <= 0;
			out_w <= 0;
			out_f <= 0;
			out_r <= 0;
		end else begin
			fireprev <= fire;
			out_f <= fire;
			
			if (fireprev && !fire) begin
				resvalid <= 1;
			end

			if (resvalid) begin
				// resvalid goes high for one cycle only
				resvalid <= 0;
			end

			if (fire) begin
				if (fireprev <= 0) begin
					out_r <= (in_w * in_a);
				end else begin
					out_r <= out_r + (in_w * in_a);
				end
				out_a <= in_a;
				out_w <= in_w;
			end 
		end
	end	
endmodule