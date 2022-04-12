module ROW_IN_BUF
    #(parameter WORD_LEN = 8)
    (
        input clk,
        input [WORD_LEN:0] in_dat,
    )

    // WIP

endmodule


module ARR_CTRL
    #(
    parameter ROWS = 16,
    parameter COLS = 16
    )(

    input clk,
    input rstn,
    input fire,

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
    reg [14:0] cur_addr = 0;

    always @ (posedge clk) begin
        if(!rstn) begin
            // RESET
            for(i=0; i<4; i=i+1) begin
               configs[i] <= 0; 
            end
            cur_conf[i] <= 0;
            cur_addr[i] <= 0;
            inpCEN <= 0; // Mem always on
            inpWEN <= 1;
        end
        else begin
            case (mode)
                2'b00: begin
                    inpWEN <= 1;
                    configs[cur_conf] <= data_in;
                end
                2'b01: begin
                    inpWEN <= 0; // Enable write to inp mem
                    cur_addr <= cur_addr + 1;
                end
                2'b10: begin
                    inpWEN <= 1;
                end
                default: begin
                    inpWEN <= 1;
                end
            end
        end
    end



endmodule