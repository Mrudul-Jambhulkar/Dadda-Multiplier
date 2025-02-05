`timescale 1us/1ns
module tb() ;
//module dadda(
//input [15:0] a, 
//input [15:0] b, 
// output [31:0] y
//);

reg [15:0] a  ;
reg [15:0] b ;
wire [31:0] y ;
dadda DUT(
.a(a) ,
.b(b) ,
.y(y)
);

initial begin
$monitor($time , " a=%d,b=%d,y=%d",a,b,y);
		 a= 7 ; b=3 ; 
		 #0.2; a= 7 ; b=20 ; 
		 #0.2; a= 50 ; b=2 ; 
		 #0.2 ;a = 5180 ; b = 439 ;
		  #0.2 ;a = 886 ; b = 993 ;
		  #0.2 ;a = 6000 ; b = 6000 ;

end

endmodule
