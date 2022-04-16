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

        input config_load,
        input data_load,
        input [7:0] data_in,

        output valid,
        output fire,
        output done);

    integer i;

    reg aWEN, wWEN;
    reg [7:0] Dbuf;
    wire [7:0] amemQ, wmemQ;

    // Instantiate SRAM for weights and activations
    INPMEM amem(.Q(amemQ), .clk(clk), .CEN(1'b0), .WEN(aWEN), .A(a_addr), .D(Dbuf));
    INPMEM wmem(.Q(wmemQ), .clk(clk), .CEN(1'b0), .WEN(wWEN), .A(w_addr), .D(Dbuf));

    reg [3:0] cur_conf;
    reg [7:0] configs [0:7];
    reg [15:0] a_addr, w_addr;

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

    wire [15:0] chconvs;        //number of convs per input channel
    wire [15:0] rowconvs;       //number of convs per row
    assign chconvs = (configs[2]-2) * (configs[3]-2);
    assign rowconvs = (configs[2]-2);

    reg [15:0] base_addr;       // base_addr of current ARR iteration
    reg [15:0] convcnt;         // total number of convs done
    reg [15:0] inpscnt;         // number of inputs sent in the current cycle
    reg [7:0] basecol;          // x location of base_addr (L -> R)
    reg [7:0] baserow;          // y location of base_addr (U -> D)
    reg [7:0] basecolnext;      // global col at next iter
    reg basechinc;              // If ch need increase at next iter

    reg [7:0] perowcnt;         // current PE row of current ARR iteration
    reg [7:0] lchcnt;           // current channel of current kernel
    reg [3:0] lcolcnt;          // current column location of current kernel
    reg [3:0] lrowcnt;          // current row of the current kernel
    reg [3:0] rowendcnt;        // num PE row iters before end of row
    
    always @ (posedge clk) begin
        if(!rstn) begin

            ///////////
            // RESET //
            ///////////

            aWEN <= 1;
            wWEN <= 1;
            Dbuf <= 0;

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

            perowcnt <= 0;
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

                    2'b11: begin    // MODE: Computing
                        aWEN <= 1;
                        wWEN <= 1;

                        //////////////////////////////
                        // Input Data Orchestration //
                        //////////////////////////////

                        if(convcnt == 0) begin
                            base_addr <= 0;
                            a_addr <= 0;
                            basecol <= 0;
                            baserow <= 0;
                        end else begin
                            // Select appropriate data from amem
                            // Assume windows span maximum of 2 rows
                            if (perowcnt >= rowendcnt) begin
                                // Window starts in the next row of input
                                a_addr <= base_addr + perowcnt + 2 + (configs[2]*configs[3])*lchcnt + configs[2]*lrowcnt + lcolcnt;
                                //        |^ - - Kernel Base - - ^|   |^ - - - - - - - location in current kernel - - - - - - - ^|
                                basecolnext <= 0;
                                baserowinc <= 1;
                            end else begin
                                // Window starts on same row and same ch as base address
                                a_addr <= base_addr + perowcnt + (configs[2]*configs[3])*lchcnt + configs[2]*lrowcnt + lcolcnt;
                                //        |^ - Kernel Base - ^|   |^ - - - - - - - location in current kernel - - - - - - - ^|
                                basecolnext <= basecolnext + 1;
                            end

                            // Update base if current windows are completed.
                            if (inpscnt >= (9 * configs[1]) - 1) begin
                                basecol <= basecolnext;
                                baserow <= baserow + {7'b0, baserowinc};
                                rowendcnt <= configs[2] - (2 + basecolnext);
                            end
                        end
                    end
                endcase
            end
        end
    end

endmodule