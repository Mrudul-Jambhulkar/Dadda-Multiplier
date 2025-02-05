module controller (
    input clk,              
    input start_stop,          
    input [31:0] douta,        
    output reg [15:0] a,       
    output reg [15:0] b,                
    output reg [2:0] addra  , 
	output en ,
	output [0:0] wea 
);

    reg [2:0] counter = 3'b000;       
	
    always @(posedge clk) begin
        if (start_stop) begin
            addra <= counter;
				b <= douta[31:16];
				a <= douta[15:0];  
        end
            if (counter < 5) begin
                counter <= counter + 1'b1;
            end else begin
                counter <= 0;  
            end
    end

	 
	assign en=1;
	assign wea=0;
	
endmodule
