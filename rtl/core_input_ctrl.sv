module COL_OUTPUT_CTRL #(
    parameter ROWS=8,
    parameter OUTWIDTH=32)
    (
    input clk,
    input rstn,
    input [OUTWIDTH-1 : 0] ainport,
    input [OUTIWDTH-1 : 0] winport,
    input r_read,
    output [OUTWIDTH-1 : 0] routport,
    output rvalidport);

    