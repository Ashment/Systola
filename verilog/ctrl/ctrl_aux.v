`timescale 1 ns/1 ps

module RBUF
    #(
        parameter WORDLEN = 8,
        parameter BUFSIZE = 16)
    (
        input clk,
        input rstn,
        input read,
        input write,
        input [WORDLEN-1 : 0] din,
        output [WORDLEN-1 : 0] dout);

    reg [WORDLEN-1 : 0] bufdat [0:BUFSIZE];
    reg [WORDLEN-1 : 0] outdat;

    // assume buffer no dmore than 32 depth (5 bit pointers)
    reg [4:0] curhead;
    reg [4:0] curtail;
    wire empty;

    integer i;

    assign empty = (curhead == curtail);
    assign dout = outdat;

    always @ (posedge clk) begin
        if(!rstn) begin
            for(i=0; i<BUFSIZE; i=i+1) begin
               bufdat[i] <= 0; 
            end
            outdat <= 0;
            curhead <= 0;
            curtail <= 0;
        end else begin
            if (read) begin
                // /!\ NO EMPTY CHECK
                outdat <= bufdat[curhead];
                curhead <= curhead + 1;
            end
            if (write) begin
                // /!\ NO FULL CHECK
                bufdat[curtail+1] <= din;
                curtail <= curtail + 1;
            end
        end
    end
endmodule

module CLKDIV
    #(parameter DIV_CNT = 8, parameter BITS = 3)
    (
        input clk,
        input rstn,
        input enable,
        output clkout
    );
    // DIV_CNT is cnt before toggle (e.g. DIV_CNT = 8 is 16x clock period.)

    reg [BITS-1:0] cnt;
    reg clkreg;
    assign clkout = clkreg;

    always @ (posedge clk) begin
        if(!rstn) begin
            clkreg <= 1;
            cnt <= 0;
        end else begin
            if(enable) begin
                if(cnt == (DIV_CNT-1)) begin
                    clkreg <= ~clkreg;
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end
endmodule
