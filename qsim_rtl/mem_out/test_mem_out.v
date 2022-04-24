`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #5
`define QSIM_OUT_FN "./output.out"
`define INPUT_FN "./input.out"

module testbench();

	localparam word_len = 32;
	localparam sram_addr = 8;
	localparam sram_count = 16;
    	wire [word_len-1:0] Q_out [0:sram_count-1];
	reg CLK;
    	reg [sram_count-1:0] CEN;
   	reg [sram_count-1:0] WEN;
	reg [sram_addr-1:0] A_in [0:sram_count-1];
	reg [word_len-1:0] D_in [0:sram_count-1];
	wire [sram_count*word_len-1:0] Q;
	wire [sram_count*word_len-1:0] D;
	wire [sram_count*sram_addr-1:0] A;
   
	integer read_out_qsim [0:sram_count-1];
	integer input_qsim [0:sram_count-1];

	integer i;
	integer j;
	integer output_file;
	integer input_file;
	integer ret_read;

	integer error_count;

	mem_out mem_out_0 ( .Q(Q), .clk(CLK), .CEN(CEN), .WEN(WEN), .A(A), .D(D) );
	defparam mem_out_0.word_len = word_len;
	defparam mem_out_0.sram_addr = sram_addr;
	defparam mem_out_0.sram_count = sram_count;

	genvar k;
	generate
		for(k = 0; k < sram_count; k = k + 1) begin : generate_tb_wire
			assign A[sram_addr*(k+1)-1:sram_addr*k] = A_in[k];
			assign D[word_len*(k+1)-1:word_len*k] = D_in[k];
			assign Q_out[k] = Q[word_len*(k+1)-1:word_len*k];
		end
	endgenerate

	always begin
		`HALF_CLOCK_PERIOD;
		CLK = ~CLK;
	end

	initial begin
		// File IO
		error_count = 0;
		output_file = $fopen(`QSIM_OUT_FN,"w");
		if (!output_file) begin
			$display("Couldn't create the output file.");
			$finish;
		end

		input_file = $fopen(`INPUT_FN,"w");
		if (!input_file) begin
			$display("Couldn't create the input file.");
			$finish;
		end

		// register setup
		CLK = 0;
		CEN = 0;
		WEN = 0;
		@(posedge CLK);
		CEN = {sram_count{1'b1}};
		WEN = {sram_count{1'b1}};
		@(posedge CLK);

		@(negedge CLK);   // release resetn
		CEN = 0;
		WEN = 0;      
		
		for (i=0 ; i<$pow(2,sram_addr); i=i+1) begin
			for (j=0; j<sram_count; j=j+1) begin
				A_in[j] = i;	
				D_in[j] = j+i;	
				input_qsim[j] = D_in[j];		
			end
			$fwrite(input_file, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n", input_qsim[0], input_qsim[1], input_qsim[2], input_qsim[3],
				input_qsim[4], input_qsim[5], input_qsim[6], input_qsim[7], input_qsim[8], input_qsim[9], input_qsim[10], input_qsim[11],
				input_qsim[12], input_qsim[13], input_qsim[14], input_qsim[15]);
			@(posedge CLK);
			`HALF_CLOCK_PERIOD;
		end
		WEN = {sram_count{1'b1}};
		//repoen to reset cursor
		$fclose(input_file);
		input_file = $fopen(`INPUT_FN,"r");
		if (!input_file) begin
			$display("Couldn't open the input file.");
			$finish;
		end

		for (i=0 ; i<$pow(2,sram_addr); i=i+1) begin
			for (j=0; j<sram_count; j=j+1) begin
				A_in[j] = i;		
			end
			@(posedge CLK);
			`HALF_CLOCK_PERIOD;
			for (j=0; j<sram_count; j=j+1) begin
				read_out_qsim[j] = Q_out[j];		
			end
			$fwrite(output_file, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n", read_out_qsim[0], read_out_qsim[1], read_out_qsim[2], read_out_qsim[3],
				read_out_qsim[4], read_out_qsim[5], read_out_qsim[6], read_out_qsim[7], read_out_qsim[8], read_out_qsim[9], read_out_qsim[10], read_out_qsim[11],
				read_out_qsim[12], read_out_qsim[13], read_out_qsim[14], read_out_qsim[15]);
			ret_read = $fscanf(input_file, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d", input_qsim[0], input_qsim[1], input_qsim[2], input_qsim[3],
				input_qsim[4], input_qsim[5], input_qsim[6], input_qsim[7], input_qsim[8], input_qsim[9], input_qsim[10], input_qsim[11],
				input_qsim[12], input_qsim[13], input_qsim[14], input_qsim[15]);
			for (j=0; j<sram_count; j=j+1) begin
				if (read_out_qsim[j] != input_qsim[j]) begin
					error_count = error_count + 1;
				end
			end
		end
		@(posedge CLK);		

		// Any mismatch b/w input data and read data
 		if (error_count > 0) begin
			$display("The read data DO NOT match with the input data :( ");
		end
		else begin
			$display("The read data DO match with the input data :) ");
		end
		// finishing this testbench
		$fclose(output_file);
		$fclose(input_file);
		$finish;
	end 

endmodule // testbench

