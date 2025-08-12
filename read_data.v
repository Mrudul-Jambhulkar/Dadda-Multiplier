`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.02.2025 18:49:22
// Design Name: 
// Module Name: read_data
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module read_write_data(
    input wire clk,
    input wire reset_n,
    output wire[15:0] A ,
    output wire[15:0] B , 
    output wire[31:0] Y ,
    output reg [14:0] s_axi_awaddr=15'h1ff0,
    output reg s_axi_awvalid=1'b0,
    input wire s_axi_awready,
    
    output reg [31:0] s_axi_wdata =32'd0,
    output reg s_axi_wvalid=1'b0,
    input wire s_axi_wready,
    
    // Write response channel
  input wire [1:0] s_axi_bresp,
  input wire s_axi_bvalid,
  output reg s_axi_bready = 0,
  output reg [3:0]s_axi_wstrb=4'b1111,
    
    output wire s_axi_aclk,
    output wire s_axi_aresetn,
    
    // Read dddress channel
    output reg [14:0] s_axi_araddr=15'd0,
    output reg s_axi_arvalid=1'b0,
    input wire s_axi_arready,
    
    // Read data channel
    input wire [31:0] s_axi_rdata,
    input wire [1:0] s_axi_rresp,
    input wire s_axi_rvalid,
    output reg s_axi_rready=1'b0,
    output reg [31:0] d_out
);
    assign s_axi_aclk = clk;
    assign s_axi_aresetn = reset_n;
    reg start_write =0 ;
    reg start_read =1 ;
    
    
//    module dadda(
//input [15:0] a, 
//input [15:0] b, 
// output [31:0] y 
//); 
    wire[15:0] a ; wire[15:0] b ; wire[31:0] y;
    reg[15:0] a1 = 0 ; reg[15:0] b1=0 ; reg[31:0] y1=0 ;
    dadda D1(.a(a),.b(b),.y(y));
    assign A = a ;
    assign B =b ;
    assign Y =y ;
    assign a = a1 ;
    assign b = b1 ;

   reg [14:0] counter = 15'd5;
//   s_axi_awaddr = counter ;
    // State definitions
    localparam IDLE = 4'd0, 
               ADDR_PHASE = 4'd1, 
               DATA_PHASE = 4'd2, 
               COMPUTE = 4'd3,
               START_WRITE = 4'd4,
               WAIT_HANDSHAKE = 4'd5,
               WAIT_RESPONSE = 4'd6 ,
               ADDR_UPDATE = 4'd7,
               WAIT_ADDR_PHASE = 4'd8,
               WAIT_LAST = 4'd9  
                ;
 
    reg [3:0] state;
    reg [3:0] wait_addr_phase = 4'd0;
    reg [3:0] wait_last = 4'd0;
    reg [3:0] wait_compute = 4'd0;
    always @(posedge clk) begin
        if (!reset_n) begin
            s_axi_araddr <= 15'd0;
            s_axi_arvalid <= 1'b0;
            s_axi_rready <= 1'b0;
            s_axi_awaddr <= 15'h1ff0; // Start writing from address 0
            s_axi_awvalid <= 1'b0;
            s_axi_wdata <= 32'd0;
            s_axi_wvalid <= 1'b0;
            s_axi_wstrb <= 4'b1111;
            s_axi_bready <= 0;
            wait_addr_phase <= 4'd0;
            wait_compute <= 4'd0;
            a1 <= 16'd0;
            b1 <= 16'd0;
            state<=IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    s_axi_arvalid <= 1'b1;
                    s_axi_rready <= 1'b1;
                    wait_addr_phase <= 4'd0;
                    state <= WAIT_ADDR_PHASE;
                   
                end
                
                WAIT_ADDR_PHASE: begin
                wait_addr_phase <= wait_addr_phase + 4'd1 ;
                if (wait_addr_phase==3) begin state <= ADDR_PHASE ; end
                end
                
                ADDR_PHASE: begin
                    if (s_axi_arready && s_axi_arvalid) begin
                        s_axi_arvalid <= 1'b0;
                         state <= DATA_PHASE;
                    end
                end
                
                DATA_PHASE: begin
                    if (s_axi_rvalid && s_axi_rready) begin
                        d_out <= s_axi_rdata;
//                        s_axi_arvalid <= 1'b0;
                        a1<=s_axi_rdata[31:16];
                        b1<=s_axi_rdata[15:0];
                        s_axi_rready <= 1'b0;
//                        state <= ADDR_UPDATE;
                        $display("DATA: d_out = %d,s_axi_rdata = %d,a=%d,b=%d", d_out,s_axi_rdata,a1,b1);
                         
                        state <= COMPUTE;
                            
                    end
                end
                
                COMPUTE: begin
//                        a1<=d_out[31:16];
//                        b1<=d_out[15:0];
                 wait_compute <= wait_compute + 4'd1 ;
                if (wait_compute==8) begin state <= START_WRITE;  end           
                end
                
                START_WRITE: begin
//                    s_axi_awaddr<= counter ;
                    s_axi_wdata<=y;
                    s_axi_awvalid <= 1; //valid addr wr avail
                    s_axi_wvalid <= 1; //valid wr data avail
                    s_axi_bready<=1 ; //ready to rec resp
                    state<=WAIT_HANDSHAKE ;
                   end
                   
               WAIT_HANDSHAKE: begin
                   if ((s_axi_awready && s_axi_wready && s_axi_wvalid && s_axi_awvalid)) begin
                   s_axi_wvalid <= 0;
                   s_axi_awvalid <= 0;
                   state <= WAIT_RESPONSE; 
                   end 
//                   else begin state <= WAIT_HANDSHAKE; end
                end
                
//                 COMPLETE_HANDSHAKE: begin
//                     s_axi_awvalid <=0;
//			         s_axi_wvalid <=0;
//			         state<=WAIT_RESPONSE;
//                 end
                 WAIT_RESPONSE:begin
                      if (s_axi_bvalid && s_axi_bready) begin
                      s_axi_bready<=0;
                      state<=ADDR_UPDATE; end 
//                      else begin
//                      state<=WAIT_RESPONSE; end
                 end
                 
//                 WAIT_RESPONSE: begin
//                 s_axi_bready<=0;
//                 counter<=counter + 15'd1 ;
//                 state <= ADDR_UPDATE;
//                 end
                 
                ADDR_UPDATE: begin
//                    s_axi_arvalid <= 1'b0;
//                    s_axi_rready <= 1'b0;
                 if (s_axi_araddr >= 15'd16)
                    s_axi_araddr <= 15'd0;
                else
                    s_axi_araddr <= s_axi_araddr + 15'd4;
            
                if (s_axi_awaddr >= 15'h1fff)
                    s_axi_awaddr <= 15'h1ff0;
                else
                    s_axi_awaddr <= s_axi_awaddr + 15'd1;
                    state <= WAIT_LAST;
                end
                
                 WAIT_LAST: begin
                 state <= IDLE;
                 end
                
              
                default: state <= IDLE;
            endcase
        end
    end
    
    
endmodule
