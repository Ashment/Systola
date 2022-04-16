`timescale 1 ns/1 ps

module PEROWBUF
    #(
        parameter WORDLEN = 8,
        parameter BUFSIZE = 8
    )(
        input clk,
        input rstn,
        input read,
        input write,
        input [WORDLEN-1 : 0] in_dat,
        output [WORDLEN-1 : 0]
    );

    reg [WORDLEN-1 : 0] bufdat [0:BUFSIZE];
    reg [WORDLEN-1 : 0] outdat;
    reg [7:0] curhead;
    reg [7:0] curtail;

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
                outdat <= bufdat[curhead];
                curhead <= curhead + 1;
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
