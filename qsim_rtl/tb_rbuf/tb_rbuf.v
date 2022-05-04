`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #10

module testbench();
    reg clk, rstn, abufread, abufwrite;
    reg [7:0] abufdin;
    wire [7:0] abufdout;
    integer i;

    RBUF #(.WORDLEN(8), .BUFSIZE(16)) abuf (
                .clk(clk),
                .rstn(rstn),
                .read(abufread),
                .write(abufwrite),
                .din(abufdin),
                .dout(abufdout));


    always begin
	`HALF_CLOCK_PERIOD;
	clk = ~clk;
    end

    initial begin
        clk = 0;
        rstn = 0;
        abufread = 0;
        abufwrite = 0;
        abufdin = 0;
        @(posedge clk);

	@(negedge clk);   // release resetn
        rstn = 1;
        @(posedge clk);  //first cycle

        for (i=0; i<32; i=i+1) begin
            if (i<4) begin
                abufwrite = 1;
                abufdin = i;
            end else if (i<8) begin
                abufwrite = 0;
                abufread = 1;
            end else begin
                abufwrite = 1;
                abufdin = i;
            end
            @(posedge clk);
        end
        $finish;
    end

endmodule













