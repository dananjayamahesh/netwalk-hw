`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:54:19 01/11/2016
// Design Name:   netwalk_encoder
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_encoder.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_encoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_netwalk_encoder;

parameter ENCODER_OUT_WIDTH=6;
parameter ENCODER_IN_WIDTH=1<<ENCODER_OUT_WIDTH;
	// Inputs
	reg clk;
	reg reset;
	reg [ENCODER_IN_WIDTH-1:0] encoder_in;
	reg encoder_enable;

	// Outputs
	wire [ENCODER_OUT_WIDTH-1:0] encoder_out;

	// Instantiate the Unit Under Test (UUT)
	netwalk_encoder
	#(.ENCODER_OUT_WIDTH(ENCODER_OUT_WIDTH))encoder
	(
		.clk(clk), 
		.reset(reset), 
		.encoder_in(encoder_in), 
		//.encoder_enable(encoder_enable),
		.encoder_out(encoder_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		encoder_in = 0;
		encoder_in=1'b0;

		// Wait 100 ns for global reset to finish
		#40;
		encoder_enable=1;
		#20;
     encoder_in=64'b0000000000000000000000000000000000000000000000000000000000000001;
	#20;
   encoder_in=64'b1000000000000000000000000000000000000000000000000000000000000000;
	#20;
	encoder_in=64'b0000000000000000000000000000000000000000000000000000000000001000;
	#20;
   encoder_in=64'b0000000000000000000000000000000000000000000010000000000000000000;
	#20;
   encoder_in=64'b0000000000000000000001000000000000000000000000000000000000000000;
	#20;
	encoder_in=64'b0100000000000000000000000000000000000000000000000000000000000000;
	#20;
		// Add stimulus here

	end
	
	always begin
	#5 clk=~clk;
	end
      
endmodule

