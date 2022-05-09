`timescale 1ns/1ps

module BUF_TB #(
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
    reg read, write;
    reg [7:0] din;
    wire [2:0] empty;
    wire [7:0] douts [0:2];

    always begin
        #10
        clk = ~clk;
    end

    always @ (posedge clk) begin
        simCyclesElapsed <= simCyclesElapsed + 1;
    end

    INBUF #(.PADDING(0)) DUT1 (.clk(clk), .rstn(rstn),
        .read(read),
        .write(write),
        .din(din),
        .empty(empty[0]),
        .dout(douts[0]));

    INBUF #(.PADDING(3)) DUT2 (.clk(clk), .rstn(rstn),
        .read(read),
        .write(write),
        .din(din),
        .empty(empty[1]),
        .dout(douts[1]));

    INBUF #(.PADDING(7)) DUT3 (.clk(clk), .rstn(rstn),
        .read(read),
        .write(write),
        .din(din),
        .empty(empty[2]),
        .dout(douts[2]));

    initial begin
        clk <= 0;
        rstn <= 0;
        din <= 1;
        read <= 0;
        write <= 0;

        $display("INITIALZIED.");

        #25;
        rstn <= 1;
        write <= 1;

        @(posedge clk);

        // Same Cycle R&W
        for (i=0; i<5; i=i+1) begin
            write <= 1;
            read <= 1;
            
            @(posedge clk);

            din <= din + 1;
        end

        // W Only
        for (i=0; i<3; i=i+1) begin
            write <= 1;
            read <= 0;
            
            @(posedge clk);

            din <= din + 1;
        end

        // R Only
        for (i=0; i<6; i=i+1) begin
            write <= 0;
            read <= 1;
            
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
