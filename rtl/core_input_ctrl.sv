module CORE_INPUT_CTRL #(
    parameter ROWS=8,
    parameter INWIDTH=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    input [INWIDTH-1 : 0] ainport,
    input [INWIDTH-1 : 0] winport,
    input r_read,);

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