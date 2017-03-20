`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:59 01/11/2016 
// Design Name: 
// Module Name:    tcam_decoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module netwalk_decoder
#(parameter DECODER_IN_WIDTH=8)
(
clk,
reset,
decoder_in,
decoder_out
);

parameter DECODER_OUT_WIDTH=1<<DECODER_IN_WIDTH;
input clk;
input reset;
input [DECODER_IN_WIDTH-1:0]decoder_in;
output reg [DECODER_OUT_WIDTH-1:0]decoder_out;

always@(*)begin
	if(!reset)begin
	 	       decoder_out <= (1 << decoder_in);
	  end
	else begin
	  decoder_out <= 0;
	end	
end
endmodule
