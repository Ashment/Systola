module ROW_IN_BUF
    #(parameter WORD_LEN = 8)
    (
        input clk,
        input [WORD_LEN:0] in_dat,
    )



endmodule


module ARR_CTRL
    #(
    parameter ROWS = 16,
    parameter COLS = 16
    )(

    input clk,
    input rstn,

    input [2:0] mode,
    // mode is used to control current operating mode.
    // 00 is config loading.
    // 01 is data loading.
    // 10 is start compute.
    // 11 is currently unused.

    input config_load,
    input data_load,
    input [7:0] data_in,

    output valid,
    output done);

    // Instantiate input mem
    INPMEM inpmem(.Q, .clk, .CEN, .WEN, .A, .D);

    integer i;
    reg [7:0] configs [0:7];
    reg inpWEN;
    reg inpCEN;
    // CONFIGURATIONS:
    // 0: operation
    // 1: input Channels
    // 2: input width
    // 3: input height

    // Target Address:
    // Convs per row: cr = w - 2
    // Total Convs: (w-2) * (cr-2)

    reg [3:0] cur_conf = 0;
    reg [15:0] cur_addr = 0;

    always @ (posedge clk) begin
        if(!rstn) begin
            // RESET
            for(i=0; i<4; i=i+1) begin
               configs[i] <= 0; 
            end
            for(i=0; i<4; i=i+1) begin
                cur_conf[i] <= 0;
            end
            for(i=0; i<16; i=i+1) begin
                cur_addr[i] <= 0;
            end
            inpCEN <= 0;
            inpWEN <= 1;
        end
        else begin

            if(config_load) begin
                configs[cur_conf] <= data_in;
            end 
            if (data_load) begin
                inpWEN <= 0; // Enable write to inp mem
            end else begin
                inpWEN <= 1;
            end
        end
    end

endmodule