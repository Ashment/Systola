module PE_ARR
    #(
    parameter ROWS = 8,
    parameter COLS = 8,
    parameter OUTWIDTH = 32) 
    (
    input clk, 
    input rstn,
    input fire,
    input[7:0] in_w [0 : ROWS-1],
    input[7:0] in_a [0 : COLS-1],
    output [OUTWIDTH-1 : 0] outs [0 : (ROWS*COLS)-1]
    output [OUTWIDTH-1 : 0] outvalids [0 : (ROWS*COLS)-1]);

    wire [OUTWIDTH-1 : 0] res_o [0 : (ROWS * COLS)-1];
    wire [7:0] w_o [0 : (ROWS * COLS)-1];
    wire [7:0] a_o [0 : (ROWS * COLS)-1];
    wire f_o [0 : (ROWS * COLS)-1];
    wire rvalid [0 : (ROWS * COLS)-1];

    // may need to change
    assign outs = res_o;
    assign outvalids = rvalid;

    genvar i, j;
    generate
        for (i=0; i<ROWS; i=i+1) begin
            for (j=0; j<COLS; j=j+1) begin
                if (j == 0) begin // First Column
                    if(i == 0) begin // Only for top left PE
                        PE PEL (.clk(clk), .rstn(rstn), 
                        .fire(fire), 
                        .in_w(in_w[0]), 
                        .in_a(in_a[0]),
                        .out_f(f_o[0]), 
                        .out_a(a_o[0]), 
                        .out_w(w_o[0]), 
                        .out_r(res_o[0]),
                        .resvalid(rvalid[j + i*COLS]));
                    end else begin  // Rest of first column
                        PE PEL (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + (i-1)*COLS]), 
                        .in_w(w_o[j + (i-1)*COLS]), 
                        .in_a(in_a[i]),
                        .out_f(f_o[j + i*COLS]), 
                        .out_a(a_o[j + i*COLS]), 
                        .out_w(w_o[j + i*COLS]), 
                        .out_r(res_o[j + i*COLS]),
                        .resvalid(rvalid[j + i*COLS]));
                    end
                end else begin // Not first column
                    if(i == 0) begin // First Row
                        PE PER (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + i*COLS - 1]), 
                        .in_w(in_w[j]), 
                        .in_a(in_a[j - 1]), 
                        .out_f(f_o[j + i*COLS]), 
                        .out_a(a_o[j + i*COLS]), 
                        .out_w(w_o[j + i*COLS]), 
                        .out_r(res_o[j + i*COLS]),
                        .resvalid(rvalid[j + i*COLS]));
                    end else begin // Not first row, not first column
                        PE PER (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + i*COLS - 1]), 
                        .in_w(w_o[j + (i-1)*COLS]), 
                        .in_a(a_o[j + i*COLS - 1]), 
                        .out_f(f_o[j + i*COLS]), 
                        .out_a(a_o[j + i*COLS]), 
                        .out_w(w_o[j + i*COLS]), 
                        .out_r(res_o[j + i*COLS]),
                        .resvalid(rvalid[j + i*COLS]));
                    end
                end

            end
        end


        /*
        wire [OUTWIDTH-1:0] res_transpose [0:ROWS-1];
        wire rvalid_transpose [0:(ROWS * COLS)-1]

        for (i=0; i<COLS; i=i+1) begin
            for (j=0; j<ROWS; j=j+1) begin
                res_transpose[i + j*COLS] = res_o[j + i*COLS];
                rvalid_transpose[i * j*COLS] = rvalid[j + i*COLS];
            end
        end

        for (i=0; i<COLS; i=i+1) begin
            COL_OUTPUT_CTRL #(.ROWS(ROWS), .OUTWIDTH(OUTWIDTH)) col_out (.clk(clk), .rstn(rstn)
                .in_res(res_transpose[i*ROWS : (i+1)*ROWS-1]),
                .in_valids(rvalid_transpose[i*ROWS : (i+1)*ROWS-1]),
                //.res_read(),
                .out_r(),
                .rvalid());
        end
        */
    endgenerate
endmodule
