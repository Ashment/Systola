module SA_CORE #(
    parameter ROWS=8,
    parameter OUTWIDTH=32
    )(
    input clk,
    input rstn,
    input r_read,
    output [OUTWIDTH-1 : 0] routport,
    output rvalidport
    );

    wire f_in;
    wire [7:0] w_in [0 : ROWS-1];
    wire [7:0] a_in [0 : ROWS-1];
    wire [7:0] r_outs [0 : (ROWS*COLS)-1];
    wire       r_valids [0 : (ROWS*COLS)-1];

    PE_ARR #(.ROWS(ROWS), .COLS(COLS)) sysarr (.clk(clk), .rstn(rstn),
        .fire(fire),
        .in_w(w_in),
        .in_a(a_in),
        .outs(r_outs),
        .outvalids(r_valids));

    // Need to instantiate col_ctrl to capture outputs
    wire [7:0] r_t [0 : (ROWS*COLS)-1];
    wire       v_t [0 : (ROWS*COLS)-1];
    genvar i, j;
    generate
        for (i=0; i<ROWS; i=i+1) begin
            for (j=0; j<COLS; j=j+1) begin
                assign r_t[j + i*(ROWS)] = r_outs[i + j*ROWS];
                assign v_t[j + i*(ROWS)] = r_valids[i + j*ROWS];
            end
        end
    endgenerate

    // Need to instantiate buffers to control inputs
    COL_OUTPUT_CTRL (.clk(), .rstn(),
        .in_r(r_t),
        .in_v(v_t),
        .res_read(r_read),
        .out_r(routport),
        .rvalid(rvalidport));

    // + ESP Interface
    

endmodule