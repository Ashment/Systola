module PE_Lin_gen(
    input clk,
    input rstn,
    input fire,
    input[7:0] in_w [0:3],
    input[7:0] in_a,
    output [11:0] outs [0:3]);

    wire fo0 [0:3];
    wire[7:0] ao0 [0:3];
    wire[11:0] o0 [0:3];

    assign outs = o0;

    PE PE00 (.clk(clk), .rstn(rstn), .fire(fire), 
                .in_w(in_w[0]), .in_a(in_a), 
                .out_f(fo0[0]), .out_a(ao0[0]), .out(o0[0]));
    
    genvar i;
    generate
        for (i=1; i<4; i=i+1) begin
           PE PE0 (.clk(clk), .rstn(rstn), .fire(fo0[i-1]),
               .in_w(in_w[i]), .in_a(ao0[i-1]), 
               .out_f(fo0[i]), .out_a(ao0[i]), .out(o0[i]));
        end
    endgenerate

endmodule