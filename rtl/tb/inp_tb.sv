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
    reg [7:0] ain [0:7];
    reg [7:0] win [0:7];
    wire [0:7] aemptys, wemptys;
    wire [7:0] as [0:7];
    wire [7:0] ws [0:7];

    always begin
        #10
        clk = ~clk;
    end

    always @ (posedge clk) begin
        simCyclesElapsed <= simCyclesElapsed + 1;
    end

    CORE_INPUT_CTRL DUT (.clk(clk), .rstn(rstn),
        .ainport(ain),
        .winport(win),
        .write(write),
        .read(read),
        .aemptys(aemptys),
        .wemptys(wemptys),
        .ws(as),
        .as(ws));

    initial begin
        clk <= 0;
        rstn <= 0;
        read <= 0;
        write <= 0;

        for (i=0; i<8; i=i+1) begin
            ain <= 0;
            win <= 0;
        end

        $display("INITIALZIED.");

        #25;
        rstn <= 1;

        for (i=0; i<SIMCYCLES; i=i+1) begin
            write <= 1;
            read <= 1;
            
            @(posedge clk);
            for (i=0; i<8; i=i+1) begin
                ain <= ain + 1;
                win <= win + 1;
            end
        end

        // End
        for (i=0; i<8; i=i+1) begin
            write <= 0;
            read <= 1;
            @(posedge clk);
        end

        $display("SIMULATION ENDED.");
        $finish;
    end
endmodule
