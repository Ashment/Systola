module INBUF
    #(
    parameter WORDLEN = 8,
    parameter BUFSIZE = 8,
    parameter PADDING = 0)
    (
    input clk,
    input rstn,
    input read,
    input write,
    input [WORDLEN-1 : 0] din,
    output empty,
    output full,
    output [WORDLEN-1 : 0] dout);

    // Circular FIFO buffer.
    // HEAD is pointer to FIRST valid data
    // TAIL is pointer to LAST valid data.

    // Buffer can have no dmore than 32 depth (5 bit pointers)
    reg [WORDLEN-1 : 0] bufdat [0:BUFSIZE];
    reg [4:0] curhead, curtail;
    integer i;

    // full and empty for signaling only. Doesn't prevent overwrite or empty read.
    assign empty = (curtail == curhead);
    assign full = (curtail+1 == curhead) || (curhead == 0 && curtail == BUFSIZE-1);
    assign dout = bufdat[curhead];

    always @ (posedge clk) begin
        if(!rstn) begin
            // RESET
            for(i=0; i<BUFSIZE; i=i+1) begin
               bufdat[i] <= 0; 
            end
            outdat <= 0;
            curhead <= PADDING;
            curtail <= 0;
        end else begin
            if (read) begin
                // Output has been read. Increment head.
                // /!\ NO EMPTY CHECK
                if (curhead == BUFSIZE-1) begin
                    // wraparound if necessary.
                    curhead <= 0;
                end else begin
                    curhead <= curhead + 1;
                end
            end
            if (write) begin
                // Write to next empty spot. Increment tail.
                // /!\ NO FULL CHECK
                if (curtail == BUFSIZE-1) begin
                    // wraparound if necessary
                    bufdat[0] <= din;
                    curtail <= 0;
                end else begin
                    bufdat[curtail+1] <= din;
                    curtail <= curtail + 1;
                end
            end
        end
    end
endmodule