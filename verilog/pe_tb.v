`timescale 1 ns/1 ps

`define INPUT_FN "./input.txt"
`define OUTPUT_FN "./qsim.out"
`define HALF_CLOCK_PERIOD #10
module PE_TB();
	reg clk, rstn, fire;
	reg [7:0] w, a;
	wire [31:0] out;
	wire out_f;
	wire [7:0] out_a, out_w;
	reg [7:0] cnt;

	integer i;
	integer input_file;
	integer output_file;
	integer ret_read;

	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	always @(posedge clk) begin
		cnt <= cnt + 1'b1;
	end

	PE dut(clk, rstn, fire, w, a, out_f, out_a, out_w, out);

	initial begin
		clk <= 0;
		rstn <= 0;
		cnt <= 0;
		w <= 0;
		a <= 0;
		fire <= 0;

		$display("Initialized");

		//Open input and output files
		output_file = $fopen(`OUTPUT_FN,"w");
		if (!output_file) begin
			$display("Couldn't open the output file.");
			$finish;
		end
		input_file = $fopen(`INPUT_FN,"r");
		if (!input_file) begin
			$display("Couldn't open the input file.");
			$finish;
		end
		@(posedge clk);
		@(posedge clk);
		@(negedge clk);
		rstn <= 1;
		fire <= 1;
		for (i=0; i<16; i=i+1) begin
			ret_read = $fscanf(input_file, "%d %d", w, a); //Testing the reading in and writing out of values
			$fwrite(output_file, "w = %0d, a = %0d\n", w, a); //Testing the reading and writing out of values
			@(posedge clk);
			$display("i=%d\tout=%d", i, out);
		end
		@(negedge clk);
		fire <= 0;
		@(posedge clk);
		@(posedge clk);
		$finish;
	end
endmodule



