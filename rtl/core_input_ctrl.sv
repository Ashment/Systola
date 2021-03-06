module CORE_INPUT_CTRL #(
    parameter ROWS=8,
    parameter INWIDTH=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    input [INWIDTH-1 : 0] ainport [0 : ROWS-1],
    input [INWIDTH-1 : 0] winport [0 : ROWS-1],
    input write,    // write goes high when inputs are ready. Writes to buffers.
    input read,     // read goes high when buffers have been read.
    output [0 : ROWS-1] aemptys,
    output [0 : ROWS-1] wemptys,
    output [INWIDTH-1 : 0] ws [0 : ROWS-1],
    output [INWIDTH-1 : 0] as [0 : ROWS-1]);

    // Instantiate buffers for handling input
    wire [INWIDTH-1 : 0] abufdins [0 : ROWS-1];
    wire [INWIDTH-1 : 0] wbufdins [0 : ROWS-1];
    wire [INWIDTH-1 : 0] abufouts [0 : ROWS-1];
    wire [INWIDTH-1 : 0] wbufouts [0 : ROWS-1];
    
    assign abufdins = ainport;
    assign wbufdins = winport;
    assign as = abufouts;
    assign ws = wbufouts;

    genvar i, j;
    generate
    for (i=0; i<ROWS; i=i+1) begin
        INBUF #(.PADDING(i)) ainbuf (.clk(clk), .rstn(rstn),
            .read(read),
            .write(write),
            .din(abufdins[i]),
            .empty(aemptys[i]),
            .dout(abufouts[i]));

        INBUF #(.PADDING(i)) winbuf (.clk(clk), .rstn(rstn),
            .read(read),
            .write(write),
            .din(wbufdins[i]),
            .empty(wemptys[i]),
            .dout(wbufouts[i]));
    end
    endgenerate
    
    // We use padding of the buffers to help schedule inputs
    // Padding pads buffers with 0 as appropriate.
    //                .  .  .  .  .
    //                W  W  W
    //                W  W
    //                W
    //                V  V  V  V  V
    //               _______________
    // ... A A A -> |               |
    // ... A A   -> |               |
    // ... A     -> |    PE Array   |
    // ...       -> |               |
    // ...       -> |               |
    //               _______________
    //

endmodule