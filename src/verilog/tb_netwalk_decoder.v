`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:18:24 01/11/2016
// Design Name:   netwalk_decoder
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_decoder.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_netwalk_decoder;
parameter DECODER_IN_WIDTH=4;
parameter DECODER_OUT_WIDTH=1<<DECODER_IN_WIDTH;
	// Inputs
	reg clk;
	reg reset;
	reg [DECODER_IN_WIDTH-1:0] decoder_in;

	// Outputs
	wire [DECODER_OUT_WIDTH-1:0] decoder_out;

	// Instantiate the Unit Under Test (UUT)
	netwalk_decoder
#(.DECODER_IN_WIDTH(DECODER_IN_WIDTH))  decoder
	(
		.clk(clk), 
		.reset(reset), 
		.decoder_in(decoder_in), 
		.decoder_out(decoder_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		decoder_in = 0;
		// Wait 100 ns for global reset to finish
		#100; 
   decoder_in=4'b0000;
	#20;
   decoder_in=4'b0001;
	#20;
	decoder_in=4'b0111;
	#40;
	
		// Add stimulus here

	end
	
	always begin
	#5 clk=~clk;
	end
      
endmodule

