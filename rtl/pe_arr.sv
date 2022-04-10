module PE_ARR
    #(
    parameter rows = 4,
    parameter cols = 4) 
    (
    input clk, 
    input rstn,
    input fire,
    input[7:0] in_w [0:rows-1],
    input[7:0] in_a [0:cols-1],
    output wire [11:0] outs [0:(rows*cols)-1]);

    genvar i, j;
    generate
        wire [11:0] res_o [0:(rows * cols)-1];
        wire [7:0] w_o [0:(rows * cols)-1];
        wire [7:0] a_o [0:(rows * cols)-1];
        wire f_o [0:(rows * cols)-1];

        // may need to change
        assign outs = res_o;

        for (i=0; i<rows; i=i+1) begin
            for (j=0; j<cols; j=j+1) begin

                if (j == 0) begin // First Column
                    if(i == 0) begin // Only for top left PE
                        PE PEL (.clk(clk), .rstn(rstn), 
                        .fire(fire), 
                        .in_w(in_w[0]), 
                        .in_a(in_a[0]), 
                        .out_f(f_o[0]), 
                        .out_a(a_o[0]), 
                        .out_w(w_o[0]), 
                        .out(res_o[0]));
                    end else begin  // Rest of first column
                        PE PEL (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + (i-1)*cols]), 
                        .in_w(w_o[j + (i-1)*cols]), 
                        .in_a(in_a[i]), 
                        .out_f(f_o[j + i*cols]), 
                        .out_a(a_o[j + i*cols]), 
                        .out_w(w_o[j + i*cols]), 
                        .out(res_o[j + i*cols]));
                    end

                end else begin // Not first column
                    if(i == 0) begin // First Row
                        PE PER (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + i*cols - 1]), 
                        .in_w(in_w[j]), 
                        .in_a(in_a[j - 1]), 
                        .out_f(f_o[j + i*cols]), 
                        .out_a(a_o[j + i*cols]), 
                        .out_w(w_o[j + i*cols]), 
                        .out(res_o[j + i*cols]));
                    end else begin // Not first row, not first column
                        PE PER (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + i*cols - 1]), 
                        .in_w(w_o[j + (i-1)*cols]), 
                        .in_a(a_o[j + i*cols - 1]), 
                        .out_f(f_o[j + i*cols]), 
                        .out_a(a_o[j + i*cols]), 
                        .out_w(w_o[j + i*cols]), 
                        .out(res_o[j + i*cols]));
                    end
                end

            end
        end
    endgenerate
endmodule
