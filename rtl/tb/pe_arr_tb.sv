`timescale 1ns/100ps
`define HALF_CLOCK #10


module pe_arr_tb();

parameter COL = 8;
parameter ROW = 8;
parameter SIMCYCLES = 10;

reg clk;
reg rstn;
reg fire;
reg [7:0] in_w [0 : COL-1];
reg [7:0] in_a [0 : ROW-1];
wire [31:0] outs [0 : (ROW*COL)-1];
wire outvalids [0 : (ROW*COL)-1];

integer i,j;

PE_ARR #(.ROWS(ROW), .COLS(COL)) 
	dut (.clk(clk), .rstn(rstn), 
        .fire(fire), 
        .in_w(in_w), 
        .in_a(in_a), 
        .outs(outs),
        .outvalids(outvalids));

initial forever 
begin
    `HALF_CLOCK clk = ~clk;
end

initial
begin    // File Configuration
    clk <= 1;
    rstn <= 0;
    for(i=0; i<COL; i=i+1) begin
        in_w[i] <= 1;
        in_a[i] <= 0;
    end
    
    @(posedge clk);
    
    fire <= 1;
    rstn <= 1;

    for (i=0; i<SIMCYCLES; i=i+1) begin
        for (j=0; j<COL; j=j+1) begin
            in_a[j] <= in_a[j] + 1;
        end
        @(posedge clk);
    end

    fire <= 0;

    for(i=0; i<ROW*2; i=i+1) begin
        @(posedge clk);
    end
end

endmodule
