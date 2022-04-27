`timescale 1ns/1ps

module SA_CORE_TB ();

/////////////////////////
// Testbench Variables //
/////////////////////////

integer i;
integer simCyclesElapsed;

always begin
    #10
    clk = ~clk;
end

always @ (posedge clk) begin
    simCyclesElapsed <= simCyclesElapsed + 1;
end

/////////////////
// DUT Signals //
/////////////////

reg clk, rstn, fire, r_read;
wire [31 : 0] routport;



SA_CORE DUT_CORE (.clk(clk), .rstn(rstn),
    .r_read(),
    .routport(),
    .rvalidport()
);

