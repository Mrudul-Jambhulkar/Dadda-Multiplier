module tb_bram();
reg clk ;
reg start_stop =0 ;

wire [31:0] y;
//module design_1_wrapper
//   (clk_0,
//    start_stop_0,
//    y_0);
//  input clk_0;
//  input start_stop_0;
//  output [31:0]y_0;
always begin #50 clk = ~clk; end

design_1_wrapper DUT_wrapper(
.clk_0(clk),
.start_stop_0(start_stop),
.y_0(y)
);

 initial begin
        clk = 0;
        start_stop = 1;
        #2500
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor($time ," start_stop= %b , y= %d ", 
                  start_stop, y);
    end

endmodule
