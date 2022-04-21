`timescale 1ns/1ps

module PE_TB;
	reg clk, rstn, fire;
	reg [7:0] w1, w2, w3, w4, a;
	wire [11:0] o1, o2, o3, o4;
	reg [7:0] cnt;

	integer i;

	always begin
		#10;
		clk = ~clk;
	end

	always @ (posedge clk) begin
		cnt <= cnt + 1'b1;
	end

	PE_Lin dut(clk, rstn, fire, 
		w1, w2, w3, w4, a,
		o1, o2, o3, o4);

	initial begin
		$dumpfile("lin_tb.vcd");
		clk <= 0;
		rstn <= 0;
		cnt <= 0;
		w1 <= 1;
		w2 <= 2;
		w3 <= 3;
		w4 <= 4;
		a <= 1;
		fire <= 1;

		$display("Initialized");

		#25;
		rstn <= 1;

		for (i=0; i<8; i=i+1) begin
			@(posedge clk);
			$display("i=%d\tout=%d,%d,%d,%d",i,o1,o2,o3,o4);

			a <= a + 1;
		end
		
		#5;
		a <= 0;
		fire <= 0;

		for (i=0; i<8; i=i+1) begin
			@(posedge clk);
			$display("i=%d\tout=%d,%d,%d,%d",i,o1,o2,o3,o4);
		end

		$dumpvars(0, PE_TB);
		$dumpall;
		$dumpflush;
		$finish;
	end
endmodule


