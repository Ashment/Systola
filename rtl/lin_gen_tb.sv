`timescale 1ns/1ps

module PE_TB;
    reg clk, rstn, fire;
    reg [7:0] w [0:3];
    wire [11:0] o [0:3];
    reg [7:0] a [0:3];
    reg [7:0] cnt;

    integer i;

    always begin
        #10;
        clk = ~clk;
    end

    always_ff @ (posedge clk) begin
        cnt <= cnt + 1'b1;
    end

    PE_Lin_gen dut(.clk(clk), .rstn(rstn), .fire(fire), 
        .in_w(w), .in_a(a[0]), .outs(o));

    initial begin
        $dumpfile("lin_gen_tb.vcd");
        clk <= 0;
        rstn <= 0;
        a[0] <= 1;
        fire <= 1;
            //for (i=0; i<4; i=i+1) begin
                //	w[i] <= i;
            //end
        w[0] <= 0;
        w[1] <= 1;
        w[2] <= 2;
        w[3] <= 3;

        $display("Initialized");

        #25;
        rstn <= 1;

        for (i=0; i<8; i=i+1) begin
            @(posedge clk);
            $display("i=%d\tout=%d,%d,%d,%d",i,o[0],o[1],o[2],o[3]);

            a[0] <= a[0] + 1;
        end
        
        #5;
        a[0] <= 0;
        fire <= 0;

        for (i=0; i<8; i=i+1) begin
            @(posedge clk);
            $display("i=%d\tout=%d,%d,%d,%d",i,o[0],o[1],o[2],o[3]);
        end

        $dumpvars(0, PE_TB);
        $dumpall;
        $dumpflush;
        $finish;
    end
endmodule


