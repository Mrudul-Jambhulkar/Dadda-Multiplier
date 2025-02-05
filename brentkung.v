module brentkung(
input [31:0] a , 
input [31:0] b ,
input cin ,
output reg [31:0] sum, 
output reg cout
);

reg [31:0] G_0 ,P_0 ;
reg [15:0] G_1 , P_1 ;
reg [7:0]  G_2 , P_2;
reg [3:0]  G_3 , P_3 ;
reg [1:0] G_4 , P_4 ;
reg G_5 , P_5 ;
reg [32:0] carry;
reg [5:0] G ;
reg [5:0] P;

integer i ;
integer j = 0 ;

always @(*) begin

for(i=0; i<32; i=i+1) begin
	G_0[i] = a[i] & b[i];
	P_0[i] = a[i] ^ b[i];
end

for (i=0 ; i<16 ; i=i+1) begin
	P_1[i] = P_0[2*i+1] & P_0[2*i];
	G_1[i] = G_0[2*i+1] |  ( P_0[2*i+1] & G_0[2*i] ) ;
end

for (i=0 ; i<8 ; i=i+1) begin
	P_2[i] = P_1[2*i+1] & P_1[2*i];
	G_2[i] = G_1[2*i+1] |  ( P_1[2*i+1] & G_1[2*i] ) ;
end

for (i=0 ; i<4 ; i=i+1) begin
	P_3[i] = P_2[2*i+1] & P_2[2*i];
	G_3[i] = G_2[2*i+1] |  ( P_2[2*i+1] & G_2[2*i] ) ;
end


for (i=0 ; i<2 ; i=i+1) begin
	P_4[i] = P_3[2*i+1] & P_3[2*i];
	G_4[i] = G_3[2*i+1] |  ( P_3[2*i+1] & G_3[2*i] ) ;
end

P_5 = P_4[1] & P_4[0];
G_5 = G_4[1] |  ( P_4[1] & G_4[0] ) ;
carry[0]= cin ;

G[5:0] = {G_5,G_4[0],G_3[0],G_2[0],G_1[0],G_0[0]} ;
P[5:0] = {P_5,P_4[0],P_3[0],P_2[0],P_1[0],P_0[0]} ;

j=0;

for (i=1 ; i<33 ; i=2*i) begin
	carry[i] = G[j] | (P[j] & carry[0]) ;
	j = j+1 ;
end

cout = carry[32] ;

carry[3] = G_0[2] | (P_0[2] & carry[2]) ; 
carry[5] = G_0[4] | (P_0[4] & carry[4]) ;  
carry[6] = G_1[2] | (P_1[2] & carry[4]) ; 
carry[7] = G_0[6] | (P_0[6] & carry[6]) ; 
carry[9] = G_0[8] | (P_0[8] & carry[8]) ;
carry[10] = G_1[4] | (P_1[4] & carry[8]) ;
carry[12] = G_2[2] | (P_2[2] & carry[8]) ;
carry[11] = G_0[10] | (P_0[10] & carry[10]) ;
carry[13] = G_0[12] | (P_0[12] & carry[12]) ;
carry[14] = G_1[6] | (P_1[6] & carry[12]) ;
carry[17] = G_0[16] | (P_0[16] & carry[16]) ;
carry[18] = G_1[8] | (P_1[8] & carry[16]) ;
carry[20] = G_2[4] | (P_2[4] & carry[16]) ;
carry[24] = G_3[2] | (P_3[2] & carry[16]) ;
carry[15] = G_0[14] | (P_0[14] & carry[14]) ;
carry[19] = G_0[18] | (P_0[18] & carry[18]) ;
carry[21] = G_0[20] | (P_0[20] & carry[20]) ;
carry[22] = G_1[10] | (P_1[10] & carry[20]) ;
carry[25] = G_0[24] | (P_0[24] & carry[24]) ;
carry[26] = G_1[12] | (P_1[12] & carry[24]) ;
carry[28] = G_2[6] | (P_2[6] & carry[24]) ;
carry[23] = G_0[22] | (P_0[22] & carry[22]) ;
carry[27] = G_0[26] | (P_0[26] & carry[26]) ;
carry[29] = G_0[28] | (P_0[28] & carry[28]) ;
carry[30] = G_1[14] | (P_1[14] & carry[28]) ;
carry[31] = G_0[30] | (P_0[30] & carry[30]) ;

sum = a^b^carry[31:0] ;

end

endmodule
