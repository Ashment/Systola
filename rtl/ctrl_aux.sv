module INBUF
    #(
    parameter WORDLEN = 8,
    parameter BUFSIZE = 10,
    parameter PADDING = 0)
    (
    input clk,
    input rstn,
    input read,
    input write,
    input [WORDLEN-1 : 0] din,
    output reg empty,
    output [WORDLEN-1 : 0] dout);

    // Circular FIFO buffer.
    // HEAD is pointer to FIRST valid data
    // TAIL is pointer to FIRST empty location
    // PADDING lets reset set head to a given amount of 0s
    // this is useful for use as input buffers for the PE array

    // Buffer can have no dmore than 32 depth (5 bit pointers)
    reg [WORDLEN-1 : 0] bufdat [0:BUFSIZE];
    reg [4:0] curhead, curtail;
    integer i;

    // empty for signaling only. Doesn't prevent overwrite or empty read.
    //assign empty = (curtail == curhead);
    assign dout = empty ? 0 : bufdat[curhead];

    always @ (posedge clk) begin
        if(!rstn) begin
            // RESET
            for(i=0; i<BUFSIZE; i=i+1) begin
               bufdat[i] <= 0; 
            end
            curhead <= 0;
            curtail <= PADDING;
            empty <= 1;
        end else begin
            empty <= (curtail == curhead);
            if (read && !empty) begin
                // Output has been read. Increment head.
                // /!\ NO EMPTY CHECK; Can still read when empty.
                if (curhead == BUFSIZE-1) begin
                    // wraparound if necessary.
                    curhead <= 0;
                end else begin
                    curhead <= curhead + 1;
                end
            end
            if (write) begin
                // Write to next empty spot. Increment tail.
                // /!\ NO FULL CHECK; FULL does not prevent overwrite.
                if (curtail == BUFSIZE-1) begin
                    // wraparound if necessary
                    bufdat[curtail] <= din;
                    curtail <= 0;
                end else begin
                    bufdat[curtail] <= din;
                    curtail <= curtail + 1;
                end
            end
        end
    end
endmodule