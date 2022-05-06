`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #5
`define SIM_CYCLES 2048
//`define QSIM_OUT_FN "./lfsr1_rtl.result"
//`define MATLAB_OUT_FN "../../matlab/lfsr1/lfsr1_matlab.result"

module testbench();

	reg clk;
	reg rstn;
	reg enable;

	reg [1:0] mode;

	reg data_load;
	reg [7:0] data_in;
	//integer lfsr_out_matlab;
	//integer lfsr_out_qsim;

	wire [16*8 - 1 : 0] aouts, wouts;
	wire saclk;
	wire fire, done;

	integer i;
	

	ARR_CTRL_16x16 ARR_CTRL_16x16_0 ( .clk(clk), .rstn(rstn), .enable(enable), .mode(mode), .data_load(data_load), .data_in(data_in), .aouts(aouts), .wouts(wouts), .saclk(saclk), .fire(fire), .done(done));

	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	initial begin
		// register setup
		clk = 0;
		rstn = 0;
		enable = 0;
		mode = 2'b00;
		data_load = 0;
		data_in = 8'd0;
		
		@(posedge clk);

		@(negedge clk);   // release resetn
		rstn = 1;      

		@(posedge clk);   // start the first cycle
		
		enable = 1;
		data_load = 1;
		mode = 2'b00;
		data_in = 8'd16;
		@(posedge clk);
		data_in = 8'd3;
		@(posedge clk);
		data_in = 8'd16;
		@(posedge clk);
		data_in = 8'd16;
		@(posedge clk);

		mode = 2'b01;
		data_in = 8'd0;
                //@(posedge clk); 

		for (i=0; i<3*3*3*16; i=i+1) begin
			@(posedge clk);
			data_in = data_in +1;
		end

                mode = 2'b10;
		data_in = 8'd0;
                //@(posedge clk); 

		for (i=0; i<3*16*16; i=i+1) begin
			@(posedge clk);
			data_in = data_in +1;
		end

		for (i=0; i<`SIM_CYCLES; i=i+1) begin
			mode = 2'b11;
			@(posedge clk);
		end

		/*
		for (i=0 ; i<; i=i+1) begin 
			mode = 2'b01;
			data_in = 8'b1;
			if (i>=1152) begin
				mode = 2'b10;
				data_in = 8'd2;
			end
			if (i>=1352) mode = 2'b11;
			@(posedge clk);  // next cycle
		end
		*/
		
		$finish;
	end 

endmodule // testbench

