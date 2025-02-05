module fullAdder(
    input a,     
    input b,
	input cin,
    output reg s,  
    output reg c 
    );
	always @(*) begin
	{c,s} = a + b + cin ;
	end
  
endmodule

