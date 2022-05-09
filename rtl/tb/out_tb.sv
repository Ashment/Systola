`timescale 1ns/1ps

module OUT_TB #(
    parameter SIMCYCLES = 16)
    ();

    /////////////////////////
    // Testbench Variables //
    /////////////////////////

    integer i,j;

    /////////////////
    // DUT Signals //
    /////////////////

    reg clk, rstn;
    reg [7:0] din [0:7];
    reg in_v [0:7];
    reg read;
    wire [31:0] dout;
    wire rvalid;

    always begin
        #10
        clk = ~clk;
    end

    COL_OUTPUT_CTRL DUT (.clk(clk), .rstn(rstn),
        .in_r(din),
        .in_v(in_v),
        .rread(read),
        .out_r(dout),
        .rvalid(rvalid));

    initial begin
        clk <= 0;
        rstn <= 0;
        in_v <= 0;
        read <= 0;
        
        for (i=0; i<8 ; i=i+1) begin
            din[i] <= i+1;
        end

        $display("INITIALZIED.");

        #25;
        rstn <= 1;

        @(posedge clk);

        // Main simulation loop
        for (i=0; i<8; i=i+1) begin
            

            @(posedge clk);

            din <= din + 1;
        end

        // End
        for (i=0; i<8; i=i+1) begin
            write <= 0;
            read <= 0;
            @(posedge clk);
        end

        $display("SIMULATION ENDED.");
        $finish;
    end
endmodule
