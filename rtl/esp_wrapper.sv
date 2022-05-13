
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
    input conf_done;

    input dma_read_ctrl_ready;
    output reg dma_read_ctrl_valid;
    output reg [31:0] dma_read_ctrl_data_index;
    output reg [31:0] dma_read_ctrl_data_length;
    output reg [2:0]  dma_read_ctrl_data_size;

    output reg dma_read_chnl_ready;
    input dma_read_chnl_valid;
    input [31:0]  dma_read_chnl_data;

    input dma_write_ctrl_ready;
    output dma_write_ctrl_valid;
    output reg [31:0] dma_write_ctrl_data_index;
    output reg [31:0] dma_write_ctrl_data_length;
    output reg [2:0]  dma_write_ctrl_data_size;

    input dma_write_chnl_ready;
    output reg dma_write_chnl_valid;
    output reg [31:0] dma_write_chnl_data;

    output reg acc_done;
    output reg [31:0] debug;

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
    wire rstn;
    assign rstn = rst;

    // BRAM signals
    reg [10:0] A0, A1;
    reg [7:0] D0, D1;
    wire [7:0] Q0, Q1;
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

    // Number of 64bit beats:
    // Each beat represents 8x8b data
    // # of beats per matrix = depth

    // Control Signals
    reg start;          // Start = 1 after config done.
    reg [1:0] state;    
    // STATE:
    //  00 = loading to plm
    //  01 = computing
    //  10 = storing
    //  11 = done
    reg [1:0] cnt;      // generic counter for control flow
    reg [1:0] stateaux; // aux state for internal control flow

    reg [63:0] dmabuf;  // for buffering data from DMA, since its wider than memory
    reg [31:0] beatit;  // big for counting beat iterations and stuff

    // inptarget: 0 => a | 1 => w
    reg inptarget;

    always @ (posedge clk) begin
        if (!rstn) begin
            // RESET
            start <= 0;
            state <= 0;

            inptarget <= 0;
            cnt <= 0;
            stateaux <= 0;
            beatit <= 0;
            
            // Reset plm con
            A0 <= 0;    A1 <= 0;
            D0 <= 0;    D1 <= 0;
            CE0 <= 0;   CE1 <= 0;
            WE0 <= 0;   WE1 <= 0;
            WEM0 <= 0;  WEM1 <= 0;

        end else begin
            if (start) begin
                case (state)
                    2'b00 : begin
                        // LOAD PLM
                        // Set read valid and wait for data from DMA
                        // 00 no read request yet
                        // 01 waiting for valid data
                        // 10 writing to valid
                        case (stateaux)
                            2'b00 : begin
                                dma_read_ctrl_valid <= 1;
                                dma_read_chnl_ready <= 0;
                                dma_read_ctrl_data_index <= 0;
                                dma_read_ctrl_data_length <= depth;
                                dma_read_ctrl_data_size <= 011; //This is token size encoding: 011=64b
                                dma_read_chnl_ready <= 1;

                                if(dma_read_ctrl_valid && dma_read_ctrl_ready) begin
                                    dmabuf <= dma_read_chnl_data;
                                    dma_read_chnl_ready <= 0;   //deassert ready until buffered data written to PLM
                                    
                                end
                            end 
                            default: 
                        endcase
                    end

                    2'b01 : begin
                        // COMPUTE
                    end
                    2'b10 : begin
                        // Store
                    end
                    2'b11 : beginw
                        acc_done <= 1;
                    end
                endcase
            end else begin
                if (conf_done) begin
                    start <= 1;
                    cnt <= 0;
                end
            end
        end
    end



endmodule