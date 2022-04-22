module INBUF
    #(
        parameter WORDLEN = 8,
        parameter BUFSIZE = 16,
        parameter PADDING = 0)
    (
        input clk,
        input rstn,
        input read,
        input write,
        input [WORDLEN-1 : 0] din,
        //output empty,
        //output full,
        output [WORDLEN-1 : 0] dout);

    reg [WORDLEN-1 : 0] bufdat [0:BUFSIZE];
    reg [WORDLEN-1 : 0] outdat;

    // assume buffer no dmore than 32 depth (5 bit pointers)
    reg [4:0] curhead, curtail;
    wire empty;
    integer i;

    assign empty = (curhead == curtail);
    assign full = (curhead + 1 == curtail);
    assign dout = outdat;

    always @ (posedge clk) begin
        if(!rstn) begin
            for(i=0; i<BUFSIZE; i=i+1) begin
               bufdat[i] <= 0; 
            end
            outdat <= 0;
            curhead <= PADDING;
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