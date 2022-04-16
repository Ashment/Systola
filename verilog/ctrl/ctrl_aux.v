`timescale 1 ns/1 ps

module RINGBUF
    #(
        parameter WORDLEN = 8,
        parameter BUFSIZE = 16)
    (
        input clk,
        input rstn,
        input read,
        input write,
        input [WORDLEN-1 : 0] din,
        output [WORDLEN-1 : 0] dout,
        output eout,
        output fout);

    reg [WORDLEN-1 : 0] bufdat [0:BUFSIZE];
    reg [WORDLEN-1 : 0] outdat;
    // assume buffer no dmore than 32 depth
    reg [4:0] curhead;
    reg [4:0] curtail;

    assign dout = outdat;
    wire bempty, bfull;
    assign bempty = (curhead == curtail);
    assign bfull = (curhead == curtail + 1);
    assign eout = bempty;
    assign fout = bfull;

    always @ (posedge clk) begin
        if(!rstn) begin
            for(i=0; i<BUFSIZE; i=i+1) begin
               bufdat[i] <= 0; 
            end
            outdat <= 0;
            curhead <= 0;
            curtail <= 0;
        end else begin
            if (read && ~bempty) begin
                outdat <= bufdat[curhead];
                curhead <= curhead + 1;
            end
            if (write && ~bfull) begin
                bufdat[curtail+1] <= in_dat;
                curtail <= curtail + 1;
            end
        end
    end
endmodule

module CLKDIV
    #(parameter DIV_CNT = 16, parameter BITS = 4;
    )(
        input clk,
        input rstn,
        output clkout,
    );

    reg [BITS-1:0] cnt;
    reg clkreg;
    assign clkout = clkreg;

    always @ (posedge clk) begin
        if(!rstn) begin
            clkreg <=  0;
            cnt <= 0;
        end else begin
            if(cnt == DIV_CNT-1) begin
                clkreg <= ~clkreg;
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
endmodule
