module COL_OUTPUT_MODULE #(
    parameter ROWS=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    input fire,
    input [OUTWIDTH-1:0] in_res [0:ROWS-1],
    input in_valids [0:ROWS-1],
    input res_read,
    output [OUTWIDTH-1:0] out_r,
    output rvalid);

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
                if (in_valids[i] == 1) begin
                    outbuf[i] <= in_res[i];
                    icnt <= icnt + 1;
                end
            end
            if (res_read) begin
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