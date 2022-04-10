`timescale 1ns/100ps
`define HALF_CLOCK #10


module pe_arr_test();
    parameter ROWS = 16;
    parameter COLS = 16;
    parameter test_count = (2*COLS)-1;

    reg clk;
    reg rstn;
    reg fire;

    reg [7:0] in_w [0:COLS-1];
    wire [0 : 8*(COLS)-1] in_w_bus;

    reg [7:0] in_a [0:ROWS-1];
    wire [0 : 8*(ROWS)-1] in_a_bus;

    wire[31:0] outs [0:COLS*ROWS-1];
    wire[0 : 32*(COLS*ROWS)-1] outs_bus;

    integer inti, intj;
    genvar i,j;
    generate
        for (i=0; i<ROWS; i=i+1) begin
            assign in_w_bus[8*i : 8*(i+1)-1] = in_w[i];
        end
        for (i=0; i<COLS; i=i+1) begin
            assign in_a_bus[8*i : 8*(i+1)-1] = in_a[i];
        end
        for (i=0; i<ROWS*COLS; i=i+1) begin
            assign outs[i] = outs_bus[32*i : 32*(i+1)-1];
        end
    endgenerate

    // TESTBENCH CLOCK
    initial forever 
    begin
        `HALF_CLOCK clk = ~clk;
    end

    // INSTANTIATE DUT
    PE_ARR #(.rows(ROWS), .cols(COLS)) 
        dut (.clk(clk), .rstn(rstn), .fire(fire), .in_w_port(in_w_bus), .in_a_port(in_a_bus), .outs_port(outs_bus));


    initial begin    
        // Initialize Testbench
        clk <= 1;
        rstn <= 0;
        for (inti=0; inti<ROWS; inti=inti+1) begin
            in_w[inti] = inti;
        end
        for (inti=0; inti<COLS; inti=inti+1) begin
           in_a[inti] = 1;
        end

        @(negedge clk)
        fire <= 1;
        rstn <= 1;
        @(posedge clk)
	
	for(inti=0; inti<test_count; inti=inti+1) begin
            for (inti=0; inti<ROWS; inti=inti+1) begin
                in_w[inti] = in_w[inti] + 1;
            end
            @(posedge clk);
	end
        // Idle and wait for outputs
        fire <= 0;
        for(inti=0; inti<COLS+1; inti=inti+1) begin
            @(posedge clk);
        end
	$finish;
    end
endmodule
