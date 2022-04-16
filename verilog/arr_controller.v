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
    input fire,

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

    // Instantiate input mem
    INPMEM inpmem(.Q, .clk, .CEN, .WEN, .A, .D);

    integer i;
    reg inpWEN;
    reg inpCEN;

    reg [3:0] cur_conf = 0;
    reg [15:0] cur_addr = 0;
    reg [7:0] configs [0:7];

    /////////////////////////
    // CONFIGURATIONS:
    // 0: operation
    // 1: input Channels
    // 2: input width
    // 3: input height
    //
    // Target Address:
    // Convs per row: cr = w - 2
    // Total Convs: (w-2) * (cr-2)
    /////////////////////////

    wire [15:0] totconvs;
    wire [15:0] rowconvs;
    assign totconvs = (configs[2]-2) * (configs[3]-2);
    assign rowconvs = (configs[2]-2);
    reg [15:0] convcnt;
    reg [7:0] windowcnt;

    always @ (posedge clk) begin
        if(!rstn) begin
            // RESET
            for(i=0; i<4; i=i+1) begin
               configs[i] <= 0; 
            end
            cur_conf <= 0;
            cur_addr <= 0;
            inpCEN <= 0; // Mem always on
            inpWEN <= 1;

            convcnt <= 0;
            windowcnt <= 0;
        end
        else begin
            if(enable) begin
                case (mode)
                    2'b00: begin    // MODE: Config Loading
                        inpWEN <= 1;
                        configs[cur_conf] <= data_in;
                    end
                    2'b01: begin    // MODE: Weight Loading
                        inpWEN <= 1;
                    end
                    2'b10: begin    // MODE: Data Loading
                        inpWEN <= 0; // Enable write to inpmem iff mode = 01
                        cur_addr <= cur_addr + 1;
                    end
                    2'b11: begin    // MODE: Computing
                        inpWEN <= 1;
                        cur_addr <= 0;

                        // Send appropriate data to each PE row
                        

                    end
                    default: begin
                        inpWEN <= 1;
                    end
                endcase
            end
        end
    end


endmodule