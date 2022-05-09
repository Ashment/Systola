module COL_OUTPUT_CTRL #(
    parameter ROWS=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    input [OUTWIDTH-1 : 0] in_r [0 : ROWS-1],
    input in_v [0:ROWS-1],
    input rread,
    output [OUTWIDTH-1 : 0] out_r,
    output rvalid);
    integer i;

    // Takes output from a column of PEs
    // and buffers + outputs them to top level.

    // ports:
    // in_r => comes from PEs. Only 1 can be valid at a time.
    // rread comes from upstream. 1 when res is readout.
    // the result has been read, so the next result is outputted.

    reg [OUTWIDTH-1:0] outbuf [0:ROWS-1];
    // cnt widths need to change if rows=/=8
    reg [2:0] icnt, ocnt;
    // icnt is # of results written in
    // ocnt is # of results read out

    assign rvalid = (ocnt < icnt);
    assign out_r = outbuf[ocnt];

    always_ff @ (posedge clk) begin
        if (!rstn) begin
            for (i=0; i<ROWS; i=i+1) begin
                outbuf[i] <= 0;
            end
            ocnt <= 0;
            icnt <= 0;
        end else begin
            // for each res input from PE, write to the
            // corresponding buffer when it becomes valid.
            for (i=0; i<ROWS; i=i+1) begin
                if (in_v[i] == 1) begin
                    outbuf[i] <= in_r[i];
                    icnt <= icnt + 1;
                end
            end

            // increment ocnt if res has been read.
            if (rread) begin
                ocnt <= ocnt + 1;
            end

            if (ocnt == 3'b111 && icnt == 3'b111) begin
                ocnt <= 0;
                icnt <= 0;
            end
        end
    end
endmodule