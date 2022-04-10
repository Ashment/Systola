module PE_ARR
    #(
    parameter rows = 16,
    parameter cols = 16) 
    (
    input clk, 
    input rstn,
    input fire,
    input[0 : 8*(rows)-1] in_w_port,
    input[0 : 8*(cols)-1] in_a_port,
    output wire [0 : 32*(rows*cols)-1] outs_port);


    wire [7:0] in_w [0:rows-1];
    wire [7:0] in_a [0:cols-1];
    wire [31:0] outs [0:(rows*cols)-1];

    genvar i, j;
    generate
        for (i=0; i<rows; i=i+1) begin
            assign in_w[i] = in_w_port[8*i : 8*(i+1)-1];
        end
        for (i=0; i<cols; i=i+1) begin
            assign in_a[i] = in_a_port[8*i : 8*(i+1)-1];
        end
        for (i=0; i<rows*cols; i=i+1) begin
            assign outs_port[32*i : 32*(i+1)-1] = outs[i];
        end
    endgenerate

    generate
        wire [31:0] res_o [0:(rows*cols)-1];
        wire [7:0] w_o [0:(rows*cols)-1];
        wire [7:0] a_o [0:(rows*cols)-1];
        wire f_o [0:(rows*cols)-1];

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
                        .out(outs[0]));
                    end else begin  // Rest of first column
                        PE PEL (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + (i-1)*cols]), 
                        .in_w(w_o[j + (i-1)*cols]), 
                        .in_a(in_a[i]), 
                        .out_f(f_o[j + i*cols]), 
                        .out_a(a_o[j + i*cols]), 
                        .out_w(w_o[j + i*cols]), 
                        .out(outs[j + i*cols]));
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
                        .out(outs[j + i*cols]));
                    end else begin // Not first row, not first column
                        PE PER (.clk(clk), .rstn(rstn), 
                        .fire(f_o[j + i*cols - 1]), 
                        .in_w(w_o[j + (i-1)*cols]), 
                        .in_a(a_o[j + i*cols - 1]), 
                        .out_f(f_o[j + i*cols]), 
                        .out_a(a_o[j + i*cols]), 
                        .out_w(w_o[j + i*cols]), 
                        .out(outs[j + i*cols]));
                    end
                end

            end
        end
    endgenerate
endmodule
