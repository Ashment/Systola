`timescale 1ns/1ps

module SA_CORE_TB #(
    parameter ROWS = 8,
    parameter SIMCYCLES = 16)
    ();

    /////////////////////////
    // Testbench Variables //
    /////////////////////////

    integer i,j;
    integer simCyclesElapsed;

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

    always @ (posedge clk) begin
        simCyclesElapsed <= simCyclesElapsed + 1;
    end

    wire [31:0] coreout [0 : ROWS-1];
    wire [0 : ROWS-1] resvalid;

    SA_CORE DUT_CORE (.clk(clk), .rstn(rstn),
        .ainport(a_in),
        .winport(w_in),
        .inpvalid(inpvalid),
        .outread(outread),
        .routport(coreout),
        .rvalidport(resvalid));

    always @ (posedge clk) begin
        if (resvalid) begin
            outread <= 1;
        end else begin
            outread <= 0;
        end
    end

    initial begin
        clk <= 0;
        rstn <= 0;
        for (i=0; i<ROWS; i=i+1) begin
            a_in[i] <= 1;
            w_in[i] <= 2;
        end
        inpvalid <= 0;
        outread <= 0;
        $display("INITIALZIED.");

        #25;
        rstn <= 1;

        @(posedge clk);
        inpvalid <= 0;
        @(posedge clk);

        for (i=0; i<SIMCYCLES; i=i+1) begin
            inpvalid <= 1;

            @(posedge clk);

            for (j=0; j<ROWS; j=j+1) begin
                if (a_in[j] == 15) begin
                    a_in[j] <= 0;
                end else begin
                    a_in[j] <= a_in[j] + 1;
                end
                if (w_in[j] == 8) begin
                    w_in[j] <= 0;
                end else begin
                    w_in[j] <= w_in[j] + 1;
                end
            end
        end

        for (i=0; i<ROWS*4; i=i+1) begin
            inpvalid <= 0;
            @(posedge clk);
        end

        $display("SIMULATION ENDED.");
        $finish;
    end
endmodule