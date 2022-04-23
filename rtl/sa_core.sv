module SA_CORE #(
    parameter ROWS=8,
    parameter OUTWIDTH=32
    )(
    input clk,
    input rstn
    );

    wire f_in;
    wire [7:0] w_in [0 : ROWS-1];
    wire [7:0] a_in [0 : ROWS-1];
    wire [7:0] r_outs [0 : (ROWS*COLS)-1];

    PE_ARR #(.ROWS(ROWS), .COLS(COLS)) sysarr (.clk(clk), .rstn(rstn),
        .fire(fire),
        .in_w(w_in),
        .in_a(a_in),
        .outs(r_outs));

    // Need to instantiate col_ctrl to capture outputs

    // Need to instantiate buffers to control inputs

    // + ESP Interface

endmodule