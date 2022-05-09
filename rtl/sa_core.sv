module SA_CORE #(
    parameter ROWS=8,
    parameter INWIDTH=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    // A and W inputs from the testbench or wrapper
    input inpvalid,     // all inputs valid.
    input outread,      // all current buffered outputs have been read.
    input [INWIDTH-1 : 0] ainport [0 : ROWS-1],
    input [INWIDTH-1 : 0] winport [0 : ROWS-1],
    output [OUTWIDTH-1 : 0] routport [0 : ROWS-1],
    output [0 : ROWS-1] rvalidport);

    //////////////
    // PE Array //
    //////////////
    reg fire;
    wire f_in;
    wire [INWIDTH-1 : 0] arr_w_in [0 : ROWS-1];
    wire [INWIDTH-1 : 0] arr_a_in [0 : ROWS-1];
    wire [OUTWIDTH-1 : 0] r_outs [0 : (ROWS*ROWS)-1];
    wire                 pe_valids [0 : (ROWS*ROWS)-1];

    PE_ARR #(.ROWS(ROWS), .COLS(ROWS)) sysarr (.clk(clk), .rstn(rstn),
        .fire(fire),
        .in_w(arr_w_in),
        .in_a(arr_a_in),
        .outs(r_outs),
        .outvalids(pe_valids));

    ////////////////
    // Aux Blocks //
    ////////////////
    // OUTPUT CONTROL
    // transpose output wire orders for the control blocks
    // and instantiate control block for each column
    wire [OUTWIDTH-1 : 0] r_t [0 : (ROWS*ROWS)-1];
    wire       v_t [0 : (ROWS*ROWS)-1];
    genvar i, j;
    generate
    for (i=0; i<ROWS; i=i+1) begin
        for (j=0; j<ROWS; j=j+1) begin
            assign r_t[j + i*(ROWS)] = r_outs[i + j*ROWS];
            assign v_t[j + i*(ROWS)] = pe_valids[i + j*ROWS];
        end
    end
    for (i=0; i<ROWS; i=i+1) begin
        COL_OUTPUT_CTRL output_ctrl(.clk(clk), .rstn(rstn),
            .in_r(r_t[ROWS*i : ROWS*(i+1)-1]),
            .in_v(v_t[ROWS*i : ROWS*(i+1)-1]),
            .rread(outread),
            .out_r(routport[i]),
            .rvalid(rvalidport[i]));
    end
    endgenerate

    // INPUT CONTROL
    wire [0 : ROWS-1] aemptys, wemptys;
    wire inpwrite;
    wire inpread;
    assign inpread = fire;
    assign inpwrite = inpvalid;
    // a and w inputs are the top module's a and w ports.
    // inpwrite when inputs are valid.
    CORE_INPUT_CTRL input_ctrl(.clk(clk), .rstn(rstn),
        .ainport(ainport),
        .winport(winport),
        .write(inpwrite),
        .read(inpread),
        .aemptys(aemptys),
        .wemptys(wemptys),
        .ws(arr_w_in),
        .as(arr_a_in));

    ///////////////////
    // CONTROl LOGIC //
    ///////////////////
    reg start;
    always_ff @ (posedge clk) begin
        if (!rstn) begin
            fire <= 0;
            start <= 0;
        end else begin
            if (start) begin
                if (aemptys != 0 && wemptys != 0) begin
                    // buffers not empty = fire
                    fire <= 1;
                end else begin
                    // buffers are all empty. No more fire.
                    fire <= 0;
                    start <= 0;
                end
            end else begin
                // wait for first valid input before starting
                if (inpvalid == 1) begin
                    fire <= 1;
                    start <= 1;
                end
            end
        end
    end

endmodule