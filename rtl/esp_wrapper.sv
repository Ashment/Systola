
module SYSTOLA_ESP_WRAPPER (clk, rst, dma_read_chnl_valid, dma_read_chnl_data, dma_read_chnl_ready,
/* <<--params-list-->> */
conf_info_depth, conf_done, acc_done, debug, 
dma_read_ctrl_valid, dma_read_ctrl_data_index, dma_read_ctrl_data_length, dma_read_ctrl_data_size, dma_read_ctrl_ready, 
dma_write_ctrl_valid, dma_write_ctrl_data_index, dma_write_ctrl_data_length, dma_write_ctrl_data_size, dma_write_ctrl_ready, 
dma_write_chnl_valid, dma_write_chnl_data, dma_write_chnl_ready);

    input clk;
    input rst;

    /* <<--params-def-->> */
    input [31:0]  conf_info_depth;
    input 	 conf_done;

    input 	 dma_read_ctrl_ready;
    output 	 dma_read_ctrl_valid;
    output [31:0] dma_read_ctrl_data_index;
    output [31:0] dma_read_ctrl_data_length;
    output [2:0]  dma_read_ctrl_data_size;

    output 	 dma_read_chnl_ready;
    input 	 dma_read_chnl_valid;
    input [31:0]  dma_read_chnl_data;

    input 	 dma_write_ctrl_ready;
    output 	 dma_write_ctrl_valid;
    output [31:0] dma_write_ctrl_data_index;
    output [31:0] dma_write_ctrl_data_length;
    output [2:0]  dma_write_ctrl_data_size;

    input 	 dma_write_chnl_ready;
    output 	 dma_write_chnl_valid;
    output [31:0] dma_write_chnl_data;

    output 	 acc_done;
    output [31:0] debug;

    //           A              x         B
    //  _                    _     _             _
    // | a1  a2  a3  ...  a8  |   | b1   b9   b17 |
    // | a9  a10 a11 ...  a16 | x | ...  ...  ... |
    // | a17 a18 a19 ...  a24 |   | b8   b16  b24 |
    //  -                    -     -             -
    //
    //        PLM
    //  ______________
    // |      a1      |
    // |--------------|
    // |      a2      |
    // |--------------|
    // |      a3      |
    // |--------------|
    // |     . . .    |
    // |--------------|
    // |      a24     |
    // |--------------|
    // |      b1      |
    // |--------------|
    // |      b2      |
    // |--------------|
    // |      b3      |
    // |--------------|
    // |     . . .    |
    // |--------------|
    // |      b24     |
    //  --------------
    //
    // For now lets assume 8xn nx8 GEMM
    // and data fit in the PLM.
    //
    // We use 2048x8 bram.
    // Reserve addr 0000~0512 for input matrix A
    //         addr 0512~1024 for input matrix B
    //         addr 1024~2048 for output
    // Note the full memory capacity is not be used.

    /*
    // read_ctrl_valid goes high for DMA read request
    assign dma_read_ctrl_valid = 1'b0;
    // read_chnl_ready goes high when ready to receive
    assign dma_read_chnl_ready = 1'b1;

    assign dma_write_ctrl_valid = 1'b0;
    assign dma_write_chnl_valid = 1'b0;
    assign debug = 32'd0;

    assign acc_done = conf_done;
    */

    /*
    module BRAM_2048x8( CLK, A0, D0, Q0, WE0, WEM0, CE0, A1, D1, Q1, WE1, WEM1, CE1 );
        input CLK;
        input [10:0] A0;
        input [7:0] D0;
        output [7:0] Q0;
        input WE0;
        input [7:0] WEM0;
        input CE0;
        input [10:0] A1;
        input [7:0] D1;
        output [7:0] Q1;
        input WE1;
        input [7:0] WEM1;
        input CE1;
    */

    // ESP Socket Outputs
    reg acc_done;

    // Control Signals
    reg start;
    reg done;

    // BRAM signals
    reg [10:0] A0, A1;
    reg [7:0] D0, D1;
    reg [7:0] Q0, Q1;
    reg CE0, CE1, WE0, WE1;
    reg [7:0] WEM0, WEM1;   // This port doesn't appear to do anything

    BRAM_2048x8 plm (.clk(),
        .A0(A0),
        .D0(D0),
        .Q0(Q0),
        .WE0(WE0),
        .WEM0(WEM0),
        .CE0(CE0),
        .A1(A1),
        .D1(D1),
        .Q1(Q1),
        .WE1(WE1),
        .WEM1(WEM1),
        .CE1(CE1)
    );


    always @ (posedge clk) begin
        
    end

endmodule