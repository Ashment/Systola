module ARR_CTRL
    #(
    parameter ROWS = 16,
    parameter COLS = 16
    )(
    input clk,
    input rstn,
    input [7:0] config_dat_in,
    input [3:0] config_num_in,
    ...
    );

    reg [7:0] configs [0:7];
    // CONFIGURATIONS:
    // 0: operation
    // 1: input Channels
    // 2: input width
    // 3: input height

    // Target Address:
    // Convs per row: cr = w - 2
    // Total Convs: (w-2) * (cr-2)

endmodule