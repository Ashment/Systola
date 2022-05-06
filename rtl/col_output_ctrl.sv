module COL_OUTPUT_CTRL #(
    parameter ROWS=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    input [OUTWIDTH-1:0] in_r [0:ROWS-1],
    input in_v [0:ROWS-1],
    input rread,
    output [OUTWIDTH-1:0] out_r,
    output rvalid);

    // Takes output from a column of PEs
    // and buffers + outputs them to top level.

    reg [OUTWIDTH-1:0] outbuf [0:ROWS-1];
    // cnt widths need to change if rows=/=8
    reg [2:0] icnt, ocnt;

    assign rvalid = (ocnt < icnt);
    assign out_r = outbuf[ocnt];

    always_ff @ (posedge clk) begin
        if (!rstn) begin
            for (i=0; i<ROWS; i=i+1) begin
                outbuf <= 0;
            end
            rvalid <= 0;

        end else begin
            for (i=0; i<ROWS; i=i+1) begin
                if (in_v[i] == 1) begin
                    outbuf[i] <= in_r[i];
                    icnt <= icnt + 1;
                end
            end
            if (rread) begin
                ocnt <= ocnt + 1;
                outbuf
            end
        end
    end

    /*
    // Could also handle output multiplexing with
    // case in always_comb
    always_comb begin
        case (icnt)
            // . . .
        endcase
    end
    */
endmodule    