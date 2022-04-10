`timescale 1 ns/1 ps

`define INPUT_FN "./input.txt"
`define OUTPUT_FN "./qsim.out"
`define HALF_CLOCK_PERIOD #2.5

module PE_TB();
	reg clk, rstn, fire;
	reg [7:0] w, a;
	wire [31:0] out;
	wire out_f;
	wire [7:0] out_a, out_w;
	reg [7:0] cnt;

	integer i;
	
	initial $sdf_annotate("../../dc/pe_bzh/PE.syn.sdf", dut);

	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	always @(posedge clk) begin
		cnt <= cnt + 1'b1;
	end

	PE dut(clk, rstn, fire, w, a, out_f, out_a, out_w, out);

	initial begin
	$dumpfile("./PE.vcd");
        $dumpvars(0, PE_TB.dut);
		clk <= 0;
		rstn <= 0;
		cnt <= 0;
		w <= 0;
		a <= 1;
		fire <= 0;

		$display("Initialized");

		@(posedge clk);
		@(negedge clk);

		rstn <= 1;
		fire <= 1;

		for (i=0; i<16; i=i+1) begin
			w <= w + 1;
			@(posedge clk);
		end

		@(negedge clk);
		fire <= 0;
		@(posedge clk);
		@(posedge clk);

        	$dumpall;
        	$dumpflush;
		$finish;
	end
endmodule



