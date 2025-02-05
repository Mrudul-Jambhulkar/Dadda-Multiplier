module halfAdder(
    input a,
    input b,
    output reg s,  
    output reg c   
    );
    
    always @(*) begin
        s = a ^ b;  // Sum
        c = a & b;  // Carry
    end

endmodule
