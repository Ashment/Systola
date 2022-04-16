module ROW_IN_BUF
    #(
        parameter WORDLEN = 8,
        parameter BUFSIZE = 8
    )(
        input clk,
        input rstn,
        input read,
        input write,
        input [WORDLEN-1 : 0] in_dat,
        output [WORDLEN-1 : 0]
    );

    reg [WORDLEN-1 : 0] bufdat [0:BUFSIZE];
    reg [WORDLEN-1 : 0] outdat;
    reg [7:0] curhead;
    reg [7:0] curtail;

    always @ (posedge clk) begin
        if(!rstn) begin
            for(i=0; i<BUFSIZE; i=i+1) begin
               bufdat[i] <= 0; 
            end
            outdat <= 0;
            curhead <= 0;
            curtail <= 0;
        end else begin
            if (read) begin
                outdat <= bufdat[curhead];
                curhead <= curhead + 1;
            end
        end
    end
    
endmodule

module CLK_DIV
    #(parameter DIV_CNT = 16, parameter BITS = 4;
    )(
        input clk,
        input rstn,
        output clkout,
    );

    reg [BITS-1:0] cnt;
    reg clkreg;
    assign clkout = clkreg;

    always @ (posedge clk) begin
        if(!rstn) begin
            clkreg <=  0;
            cnt <= 0;
        end else begin
            if(cnt == DIV_CNT-1) begin
                clkreg <= ~clkreg;
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
endmodule

module ARR_CTRL
    #(
    parameter ROWS = 16,
    parameter COLS = 16
    )(
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
    reg [7:0] amemQ, wmemQ;

    // Instantiate SRAM for weights and activations
    INPMEM amem(.Q(amemQ), .clk(clk), .CEN(1'b0), .WEN(aWEN), .A(a_addr), .D(data_in));
    INPMEM wmem(.Q(wmemQ), .clk(clk), .CEN(1'b0), .WEN(wWEN), .A(w_addr), .D(data_in));

    reg [3:0] cur_conf = 0;
    reg [15:0] a_addr = 0;
    reg [7:0] configs [0:7];

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
    reg [15:0] inpscnt;         // number of inputs in current conv
    reg [7:0] basecol;          // x location of base_addr (L -> R)
    reg [7:0] baserow;          // y location of base_addr (U -> D)
    reg [7:0] basech;           // z location of base_addr (F -> B)

    reg [7:0] perowcnt;         // current PE row of current ARR iteration
    reg [7:0] lchcnt;           // current channel of current kernel
    reg [3:0] lcolcnt;          // current column location of current kernel
    reg [3:0] lrowcnt;          // current row of the current kernel
    reg [3:0] rowendcnt;        // num PE row iters before end of row

    reg [7:0] basecolnext;      // global col at next iter
    reg [7:0] baserownext;      // global row at next iter
    reg basechinc;              // 1 global ch need increment for next iter
    
    always @ (posedge clk) begin
        if(!rstn) begin
            // RESET
            for(i=0; i<4; i=i+1) begin
               configs[i] <= 0; 
            end
            cur_conf <= 0;
            a_addr <= 0;
            aWEN <= 1;
            wWEN <= 1;

            base_addr <= 0;
            convcnt <= 0;
            inpscnt <= 0;
            basecol <= 0;
            baserow <= 0;
            basech <= 0;

            perowcnt <= 0;
            lchcnt <= 0;
            lcolcnt <= 0;
            lrowcnt <= 0;
            perowcutoff <= 0;

            basecolnext <= 0;
            baserowinc <= 0;
            basechinc <= 0;
        end
        else begin
            if(enable) begin
                case (mode)
                    2'b00: begin    // MODE: Config Loading
                        aWEN <= 1;
                        configs[cur_conf] <= data_in;
                    end
                    2'b01: begin    // MODE: Weight Loading
                        aWEN <= 1;
                        
                    end
                    2'b10: begin    // MODE: Data Loading
                        aWEN <= 0; // Enable write to inpmem iff mode = 01
                        a_addr <= a_addr + 1;
                    end
                    2'b11: begin    // MODE: Computing
                        aWEN <= 1;
                        a_addr <= 0;

                        // Send appropriate data to each PE row
                        ////////////////////////
                        // WIP Function Below //
                        ////////////////////////

                    end
                endcase
            end
        end
    end

    // FUNCTIONS
    function automatic [15:0] geta3x3 (
//        input [15:0] base_addr;
//        input [15:0] convcnt;
//        input [7:0] lcolcnt;
        );
        // Get correct address for data to pass to current PE

        ////////// FOR REFERENCE ///////////

        // CONFIGURATIONS:
        // 0: output channels
        // 1: input Channels
        // 2: input width
        // 3: input height
        //
        // Target Address:
        // Convs per row: cr = w - 2
        // Total Convs: (w-2) * (cr-2)

        // wire [15:0] chconvs;        //number of convs per input channel
        // wire [15:0] rowconvs;       //number of convs per row
        // assign chconvs = (configs[2]-2) * (configs[3]-2);
        // assign rowconvs = (configs[2]-2);

        // reg [15:0] base_addr;       // base_addr of current ARR iteration
        // reg [15:0] convcnt;         // total number of convs done
        // reg [7:0] basecol;          // x location of base_addr (L->R)
        // reg [7:0] baserow;          // y location of base_addr (U->D)
        // reg [7:0] basech;           // z location of base_addr (F->B)

        // reg [7:0] perowcnt;         // current PE row of current ARR iteration
        // reg [7:0] lchcnt;           // current channel of current kernel
        // reg [3:0] lcolcnt;          // current column location of current kernel
        // reg [3:0] lrowcnt;          // current row of the current kernel

        // reg [7:0] basecolnext;      // global col at next iter
        // reg baserowinc, basechinc;  // incr global where necessary
        ////////////////////////////////////

        // Assume windows span maximum of 2 rows
        if (perowcnt >= rowendcnt) begin
            if (basecol >= configs[3] - 2) begin
                // Window starts in the NEXT CHANNEL compared to base address
                geta3x3 = (configs[1]*configs[2]) + configs[2]*lrowcnt + (configs[1]*configs[2])*lchcnt + lcolcnt);
                basecolnext = 0;
                baserowinc = 0;
                basechinc = 1;
            end else begin
                // Window starts in the NEXT ROW compared to base address
                geta3x3 = base_addr + (configs[1]*configs[2])*lchcnt + configs[2]*lrowcnt + lcolcnt + 2;
                basecolnext = 0;
                baserowinc = 1;
            end
        end else begin
            // Window starts on same row and same ch as base address
            geta3x3 = base_addr + (configs[1]*configs[2])*lchcnt + configs[2]*lrowcnt + lcolcnt;
            basecolnext = basecolnext + 1;
        end

        // Check if current window is conpleted
        // Update base if current window is completed.
        if (inpscnt >= (9 * configs[1]) - 1) begin
            basecol = basecolnext;
            baserow = baserow + {7'b0, baserowinc};
            basech = basechinc + {15'b0, basechinc};
            rowendcnt = configs[2] - (2 + basecolnext);
        end

        rowendcnt = configs[2] - (2 + basecol);

    endfunction

endmodule