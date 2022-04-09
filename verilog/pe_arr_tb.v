`timescale 1ns/100ps
`define HALF_CLOCK #10

m`define WEIGHTS_IN_FN "weights.in"
`define ACTIVATIONS_IN_FN "activations.in"
`define QSIM_OUT_FN "qsim.out"
`define PYTHON_OUT_FN "./python.out"


module pe_arr_tb();

parameter ROWS = 4;
parameter COLS = 4;
parameter test_count = 10;

reg clk;
reg rstn;
reg fire;

reg[7:0] in_w [0:COLS-1];
reg[0 : 8*(COLS)-1] in_w_bus;

reg[7:0] in_a [0:ROWS-1];
reg[0 : 8*(ROWS)-1] in_a_bus;

wire[31:0] outs [0:COLS*ROWS-1];
wire[0 : 32*(COLS*ROWS)-1] outs_bus;

integer i;
integer j;
integer weights_in_file;
integer activations_in_file;
integer qsim_out_file;

// TESTBENCH CLOCK
initial forever 
begin
    `HALF_CLOCK clk = ~clk;
end

// INSTANTIATE DUT
PE_ARR #(.rows(ROWS), .cols(COLS)) 
	dut (.clk(clk), .rstn(rstn), .fire(fire), .in_w(in_w_bus), .in_a(in_a_bus), .outs(outs_bus));


initial begin    
    // File Configuration
    weights_in_file = $fopen(`WEIGHTS_IN_FN, "r");
    activations_in_file = $fopen(`ACTIVATIONS_IN_FN, "r");
    qsim_out_file = $fopen(`QSIM_OUT_FN, "w");
   
    if (!weights_in_file) begin
        $display("Couldn't open the weights file.");
        $finish;
    end
    if (!activations_in_file) begin
        $display("Couldn't open the activations file.");
        $finish;
    end 
    if (!qsim_out_file) begin
        $display("Couldn't create the output file.");
        $finish;
    end

    // Initialize Testbench
    clk <= 1;
    rstn <= 0;
    @(posedge clk)
    fire <= 1;
    rstn <= 1;
    
    // Read Stuff
    for (i = 0; i < test_count; i++) begin
        $fscanf(weights_in_file, "%d %d %d %d", in_w[0], in_w[1], in_w[2], in_w[3]);
        $fscanf(activations_in_file, "%d %d %d %d", in_a[0], in_a[1], in_a[2], in_a[4]);
        for (j = 0; j < COL * ROW - 1 ; j = j + 4) begin
            $fwrite(qsim_out_file, "%d %d %d %d \n", outs[j/4], outs[j/4 + 1], outs[j/4 + 2], outs[j/4 + 3]);
        end
    end
    
    // Print inputs to console
    while($fscanf(weights_in_file, "%d %d %d %d", in_w[0], in_w[1], in_w[2], in_w[3]) == 2) begin
        $display("w[0] = %d w[1] = %d w[2] = %d w[3] = %d", in_w[0], in_w[1], in_w[2], in_w[3]);
    end
    while($fscanf(activations_in_file, "%d %d %d %d", in_a[0], in_a[1], in_a[2], in_a[3]) == 2) begin
        $display("a[0] = %d a[1] = %d a[2] = %d a[3] = %d", in_a[0], in_a[1], in_a[2], in_a[3]);
    end
    
    // Idle and wait for outputs
    fire <= 0;
    for(i=0; i<16; i++) 
    begin
        @(posedge clk);
    end
    
    $fclose(weights_in_file);
    $fclose(activations_in_file);
    $fclose(qsim_out_file);
