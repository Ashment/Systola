`timescale 1 ns/1 ps

module ARR_CTRL_16x16
        input clk,
        input rstn,
        input enable,

        input [2:0] mode,
        // mode is used to control current operating mode.
        // 00 is config loading
        // 01 is weight loading
        // 10 is data loading
        // 11 is compute

        input data_load,
        input [7:0] data_in,

        output [16*8 - 1 : 0] aouts,
        output [16*8 - 1 : 0] wouts, 
        output done);

    integer i;
    genvar gi;

    ////////////////////
    // INPUT MEMORIES //
    ////////////////////

    reg aWEN, wWEN;
    reg [7:0] Dbuf;
    wire [7:0] amemQ, wmemQ;

    // Instantiate SRAM for weights and activations
    INPMEM amem(.Q(amemQ), .clk(clk), .CEN(1'b0), .WEN(aWEN), .A(a_addr), .D(Dbuf));
    INPMEM wmem(.Q(wmemQ), .clk(clk), .CEN(1'b0), .WEN(wWEN), .A(w_addr), .D(Dbuf));

    /////////////////////
    // A and W Buffers //
    /////////////////////

    wire [15:0] abufreads, wbufreads;
    reg [15:0] abufwrites, wbufwrites;
    wire [7:0] abufdout [0:15];
    wire [7:0] wbufdout [0:15];
    reg [7:0] abufdin, wbufdin;
    reg [3:0] prefillcnt;

    for (i=0; i<16; i=i+1) begin
        assign aouts[i*8 : (i+1) * 8 - 1] = abufdout[i];
        assign wouts[i*8 : (i+1) * 8 - 1] = wbufdout[i];
    end

    generate
        for (gi=0; gi<16; gi=gi+1) begin
            INPBUF #(.WORDLEN(8), .BUFSIZE(gi+1)) abuf_gen (
                .clk(clk),
                .rstn(rstn),
                .read(abufreads[gi]),
                .write(abufwrites[gi]),
                .din(abufdin),
                .dout(abufdout[gi]));
        end
        for (gi=0; gi<16; gi=gi+1) begin
            INPBUF #(.WORDLEN(8), .BUFSIZE(gi+1)) wbuf_gen (
                .clk(clk),
                .rstn(rstn),
                .read(wbufreads[gi]),
                .write(wbufwrites[gi]),
                .din(wbufdin),
                .dout(wbufdout[gi]));
        end
    endgenerate

    /////////////
    // CONFIGS //
    /////////////

    reg [3:0] cur_conf;
    reg [7:0] configs [0:3];

    /////////////////////////
    // CONFIGURATIONS:
    // 0: output channels
    // 1: input Channels
    // 2: input width
    // 3: input height
    //
    // Target Address:
    // Convs per row: cr = w - 2
    // Total Convs: (w-2) * (cr-2)
    /////////////////////////

    /////////////////////////////
    // DATA MOVEMENT VARIABLES //
    /////////////////////////////

    reg [15:0] a_addr, w_addr;

    wire [15:0] chconvs;        //number of convs per input channel
    wire [15:0] rowconvs;       //number of convs per row
    assign chconvs = (configs[2]-2) * (configs[3]-2);
    assign rowconvs = (configs[2]-2);

    reg [15:0] base_addr;       // base_addr of current ARR iteration
    reg [15:0] convcnt;         // total number of convs done
    reg [15:0] inpscnt;         // number of inputs sent in the current window
    reg [7:0] basecol;          // x location of base_addr (L -> R)
    reg [7:0] baserow;          // y location of base_addr (U -> D)
    reg [7:0] basecolnext;      // global col at next iter
    reg baserowinc;             // If row need increase at next iter

    reg [3:0] peitcnt;         // current PE row of current ARR iteration
    reg [7:0] lchcnt;           // current channel of current kernel
    reg [2:0] lcolcnt;          // current column location of current kernel
    reg [2:0] lrowcnt;          // current row of the current kernel
    reg [4:0] rowendcnt;        // num PE row iters before end of row

    ///////////////////
    // CLOCKED LOGIC //
    ///////////////////

    always @ (posedge clk) begin
        if(!rstn) begin

            ///////////
            // RESET //
            ///////////

            aWEN <= 1;
            wWEN <= 1;
            Dbuf <= 0;
            abufwrites <= 0;
            wbufwrites <= 0;
            abufdin <= 0;
            wbufdin <= 0;

            cur_conf <= 0;
            for(i=0; i<4; i=i+1) begin
               configs[i] <= 0; 
            end
            a_addr <= 0;
            w_addr <= 0;

            base_addr <= 0;
            convcnt <= 0;
            inpscnt <= 0;
            basecol <= 0;
            baserow <= 0;
            basecolnext <= 0;
            baserowinc <= 0;

            peitcnt <= 0;
            lchcnt <= 0;
            lcolcnt <= 0;
            lrowcnt <= 0;
            rowendcnt <= 0;

        end else begin
            if(enable) begin
                case (mode)

                    2'b00: begin    // MODE: Config Loading
                        aWEN <= 1;
                        wWEN <= 1;
                        // Load data_in into configs
                        if (cur_conf < 2'b11 && data_load) begin
                            configs[cur_conf] <= data_in;
                            cur_conf <= cur_conf + 1;
                        end
                    end

                    2'b01: begin    // MODE: Weight Loading
                        aWEN <= 1;
                        Dbuf <= data_in;
                        if(w_addr < 16'hFFFF) begin
                            // writes data_in to wmem at w_addr
                            wWEN <= ~data_load; //Enable write to wmem if data_load high
                            w_addr <= w_addr + 1;
                        end
                    end

                    2'b10: begin    // MODE: Data Loading
                        wWEN <= 1;
                        Dbuf <= data_in;
                        if (a_addr < 16'hFFFF) begin
                            // writes data_in to amem at a_addr
                            aWEN <= ~data_load;  // Enable write to amem if data_load high
                            a_addr <= a_addr + 1;
                        end
                    end

                    // Also prefill buffers for inputs
                    // First row/col needs no pad, last row/col needs 15 pad, etc.
                    if(prefillcnt == 4'hF) begin
                        abufwrites <= 0;
                    end else begin
                        for (i=0; i<16; i=i+1) begin
                            // prefill buffer to appropriately delay compute start
                            abufwrites[i] = (i > prefillcnt);
                            wbufwrites[i] = (i > prefillcnt);
                        end
                    end

                    2'b11: begin    // MODE: Computing
                        aWEN <= 1;
                        wWEN <= 1;

                        ///////////////////////////////
                        // Activations Data Movement //
                        ///////////////////////////////

                        //  A MEM
                        //  ______________
                        // |              |
                        // |  INPUT CH 1  | 
                        // |              |
                        // |--------------|
                        // |              |
                        // |  INPUT CH 2  | 
                        // |              |
                        // |--------------|
                        // |              |
                        // |    . . .     |
                        // |              |
                        // |--------------|
                        // |              |
                        // |  INPUT CH n  |
                        // |              |  
                        //  --------------
                        //   
                        //        .------------.
                        //    .------------.20 |
                        //  ___________ 11 | --|
                        // | 0 | 1 | 2 | --|23 |
                        // |---|---|---|14 | --|
                        // | 3 | 4 | 5 | --|26 |
                        // |---|---|---|17 |--- 
                        // | 6 | 7 | 8 |---
                        //  -----------

                        if (peitcnt == 4'hF) begin
                            peitcnt <= 0;

                            if (lcolcnt == 2) begin
                                // End of row in kernel
                                lcolcnt <= 0;
                                if(lrowcnt == 2) begin
                                    // Also end of ch in kernel
                                    lrowcnt <= 0;
                                    lchcnt <= 1;
                                end else begin
                                    lrowcnt <= lrowcnt + 1;
                                end
                            end else begin
                                // increment x position
                                lcolcnt <= lcolcnt + 1;
                            end

                            inpscnt <= inpscnt + 1;
                        end
                        peitcnt <= peitcnt + 1;

                        // Update base if current windows are completed.
                        if (inpscnt == (9 * configs[1]) - 1) begin
                            inpscnt <= 0;
                            basecol <= basecolnext;
                            convcnt <= convcnt + 16;
                            baserow <= baserow + baserowinc;
                            if(configs[2] - (2 + basecolnext) < 5'd16) begin
                                rowendcnt <= configs[2] - (2 + basecolnext);
                            end else begin
                                rowendcnt <= 5'd20; // row won't end this window cycle
                            end
                        end

                        // Calculate address for data needed
                        if (convcnt == 0 && peitcnt == 0) begin
                            // Begin Computing Base
                            base_addr <= 0;
                            a_addr <= 0;
                            basecol <= 0;
                            baserow <= 0;
                        end else begin
                            // Select appropriate address from amem
                            // Assume windows span maximum of 2 rows
                            if (peitcnt >= rowendcnt) begin
                                // Window starts in the next row of input
                                a_addr <= base_addr + peitcnt + 2 + (configs[2]*configs[3])*lchcnt + configs[2]*lrowcnt + lcolcnt;
                                //        |^ - - Kernel Base - - ^|   |^ - - - - - - - location in current kernel - - - - - - - ^|
                                basecolnext <= 0;
                                baserowinc <= 1;
                            end else begin
                                // Window starts on same row and same ch as base address
                                a_addr <= base_addr + peitcnt + (configs[2]*configs[3])*lchcnt + configs[2]*lrowcnt + lcolcnt;
                                //        |^ - Kernel Base - ^|   |^ - - - - - - - location in current kernel - - - - - - - ^|
                                basecolnext <= basecolnext + 1;
                            end
                        end

                        ///////////////////////////
                        // Weights Data Movement //
                        ///////////////////////////                        

                        //  W MEM
                        //  _________________
                        // |                 |
                        // |  KERNEL 1 CH 1  | 
                        // |                 |
                        // |-----------------|
                        // |                 |  <- Addr = (channel-1) * 9
                        // |  KERNEL 1 CH 2  | 
                        // |                 |
                        // |-----------------|
                        // |                 |
                        // |      . . .      |
                        // |                 |
                        // |-----------------|
                        // |                 |
                        // |  KERNEL 1 CH n  |
                        // |                 |
                        // |-----------------|
                        // |                 |  <- Addr = (kernel-1) * 9 * kernel_depth
                        // |  KERNEL 2 CH 1  |
                        // |                 |
                        // |-----------------|
                        // |                 |  <- In General: Addr = (kernel-1)*9*kernel_depth + (channel-1)*9 + position
                        // |      . . .      |
                        // |                 |  <-- Loaded with zeroes there are fewer
                        // |-----------------|      than 16 output channels left to compute
                        // |                 |
                        // |  KERNEL 16 CH n |
                        // |                 |  
                        //  -----------------

                        w_addr <= peitcnt*(9*configs[1]) + (lchcnt * 9) + (lrowcnt * 3) + lcolcnt;
                        //        |^ -  Kernel base  - ^|   |^ -- location in current kernel -- ^|
                        
                        //////////////////////////////
                        // Write to A and W Buffers //
                        //////////////////////////////

                        for (i=0; i<16; i=i+1) begin
                            abufwrites[i] <= (i == peitcnt);
                            wbufwrites[i] <= (i == peitcnt);
                        end
                        abufdin <= (convcnt + perowcnt < (configs[2]-2)*(configs[3]-2)) ? amemQ : 0;
                        wbufdin <= wmemQ;

                    end
                endcase
            end
        end
    end

endmodule