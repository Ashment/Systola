`timescale 1ns/1ps

module SA_CORE_TB #(
    parameter ROWS = 8,
    parameter SIMCYCLES = 160)
    ();

    /////////////////////////
    // Testbench Variables //
    /////////////////////////

    integer i,j;
    integer simCyclesElapsed;

    always @ (posedge clk) begin
        simCyclesElapsed <= simCyclesElapsed + 1;
    end

    /////////////////
    // DUT Signals //
    /////////////////

    reg clk, rstn, inpvalid, outread;
    reg [7:0] a_in [0 : ROWS-1];
    reg [7:0] w_in [0 : ROWS-1];

    always begin
        #10
        clk = ~clk;
    end

    wire [31:0] routport [0 : ROWS-1];
    wire resvalid [0 : ROWS-1];

    SA_CORE DUT_CORE (.clk(clk), .rstn(rstn),
        .ainport(a_in),
        .winport(w_in),
        .inpvalid(inpvalid),
        .outread(outread),
        .routport(resvalid),
        .rvalidport(routport));


    initial begin
        clk <= 0;
        rstn <= 0;
        for (i=0; i<ROWS-1; i=i+1) begin
            a_in[i] <= 0;
            w_in[i] <= 1;
        end
        inpvalid <= 0;
        outread <= 0;
        $$display("INITIALZIED.");

        #25;
        rstn <= 1;

        for (i=0; i<SIMCYCLES; i=i+1) begin
            inpvalid <= 1;

            if(resvalid != 0) begin
                outread <= 1;
            end else begin
                outread <= 0;
            end

            @(posedge clk);
            for (j=0; j<ROWS-1; j=j+1) begin
                a_in[j] <= i % 16;
            end
            $display("Current Sim Cycle: %d", i);
        end

        for (i=0; i<ROWS*2; i=i+1) begin
            inpvalid <= 0;
        end

        $display("SIMULATION ENDED.");
        $finish;
    end
endmodule