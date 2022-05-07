module CORE_INPUT_CTRL #(
    parameter ROWS=8,
    parameter INWIDTH=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    input [INWIDTH-1 : 0] ainport,
    input [INWIDTH-1 : 0] winport,
    input r_read,
    output [INWIDTH-1 : 0] ws [0 : ROWS-1],
    output [INWIDTH-1 : 0] as [0 : ROWS-1]);

    // Instantiate buffers for handling input
    wire abufreads [0 : ROWS-1];
    wire wbufreads [0 : ROWS-1];
    wire abufwrites [0 : ROWS-1];
    wire wbufwrites [0 : ROWS-1];
    wire afulls [0 : ROWS-1];
    wire wfulls [0 : ROWS-1];
    wire aemptys [0 : ROWS-1];
    wire wemptys [0 : ROWS-1];
    wire [INWIDTH-1 : 0] abufdins [0 : ROWS-1];
    wire [INWIDTH-1 : 0] wbufdins [0 : ROWS-1];
    wire [INWIDTH-1 : 0] abufouts [0 : ROWS-1];
    wire [INWIDTH-1 : 0] wbufouts [0 : ROWS-1];
    
    genvar i, j;
    generate
    for (i=0; i<ROWS; i=i+1) begin
        INBUF ainbuf (.clk(clk), .rstn(rstn),
            .read(abufreads[i]),
            .write(abufwrites[i]),
            .din(abufdins[i]),
            .empty(aemptys[i]),
            .full(afulls[i]),
            .dout(bufouts[i]));

        INBUF winbuf (.clk(clk), .rstn(rstn),
            .read(wbufreads[i]),
            .write(wbufwrites[i]),
            .din(wbufdins[i]),
            .empty(wemptys[i]),
            .full(wfulls[i]),
            .dout(bufouts[i]));
    end
    endgenerate

    // counter for scheduling. based on num rows
    reg [3:0] initcycles;

    // We use initcycles to count whether it is the
    // initial phases where later rows/columns receive 0s.
    //               .  .  .  .  .
    //               W  W  W
    //               W  W
    //               W
    //               V  V  V  V  V
    //              ________________
    // ... A A A ->|                |
    // ... A A   ->|                |
    // ... A     ->|    PE Array    |
    // ...       ->|                |
    // ...       ->|                |
    //              ________________
    //

    assign as[0] = ~aemptys[0] ? abufouts[0] : 0;
    assign ws[0] = ~wemptys[0] ? wbufouts[0] : 0;

    generate
    for (i=1; i<ROWS; i=i+1) begin
        assign as[i] = (~aemptys[i] && initcycles >= i) ? abufouts[i] : 0;
        assign ws[i] = (~wemptys[i] && initcycles >= i) ? wbufouts[i] : 0;
    end
    endgenerate

    always @ (posedge clk) begin
        if (!rstn) begin
            initcycles <= 0;
        end else begin
            if (initcycles < ROWS-1) begin
                initcycles <= initcycles + 1;
            end

            // Pending interface to ESP socket
        end
    end



endmodule