`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:55:42 01/10/2016
// Design Name:   netwalk_tcam_unit
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_tcam_unit.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_tcam_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_tcam_unit_test_logic;
	parameter TCAM_UNIT_ADDR=0,DPL_MATCH_FIELD_WIDTH=16,TCAM_ADDR_WIDTH=10;
	// Inputs
	reg clk;
	reg reset;
	reg [DPL_MATCH_FIELD_WIDTH-1:0] tcam_program_data;
	reg [DPL_MATCH_FIELD_WIDTH-1:0] tcam_program_mask;
	reg [9:0] tcam_program_addr;
	reg tcam_program_enable;
	reg [DPL_MATCH_FIELD_WIDTH-1:0] of_match_field_data;

	// Outputs
	wire of_matched_addr_out;
	wire [DPL_MATCH_FIELD_WIDTH-1:0] of_matched_out;
	

	// Instantiate the Unit Under Test (UUT)
	tcam_unit_test_logic
#(.TCAM_UNIT_ADDR(TCAM_UNIT_ADDR),.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
	tcam_unit_test_logic0 (
		.clk(clk), 
		.reset(reset), 
		.tcam_program_data(tcam_program_data), 
		.tcam_program_mask(tcam_program_mask), 
		.tcam_program_addr(tcam_program_addr), 
		.tcam_program_enable(tcam_program_enable), 
		.of_match_field_data(of_match_field_data), 
		.of_matched_addr_out(of_matched_addr_out),
		.of_matched_out(of_matched_out)
		
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		tcam_program_data = 0;
		tcam_program_mask = 0;
		tcam_program_addr = 0;
		tcam_program_enable = 0;
		of_match_field_data = 0;

		// Wait 100 ns for global reset to finish
		#40;
		tcam_program_data=16'b0101010101010101;
		tcam_program_mask=16'b1111111111111111;
		tcam_program_addr = 10'b00000000;
		tcam_program_enable=1'b1;
		#40;
			tcam_program_enable=1'b0;
		#40;
		 of_match_field_data=16'b1111000011110000;
		 #40;
		 of_match_field_data=16'b0101010101010101;
        #100;/*
		   of_match_field_data=356'h0000007600000076c205634dc205634d0000c203633e00008847000000024302a0280702a0a00404000000000;
		  #40;
		   of_match_field_data=356'h00000062000000623c970e813c970e8144c10018fe63a30c0800000000000302a0000b02a0000404000000000;
		  #40;
		
		   tcam_program_data=356'h0000003c0000003cffffffffffffffffffff0018fe63a30c08060000000000000000000000000000000000000;
		   tcam_program_mask=356'h11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
		   tcam_program_addr = 10'b00000000;
		    tcam_program_enable=1'b1;
		
		#40;
		  tcam_program_enable=1'b0;
		 of_match_field_data=356'h0000007200000072005056a5005056a5644d0050569a78c7080000000000002b61934c2b61934844006a506a5;
		 #40;
		 of_match_field_data=356'h0000003c0000003cffffffffffffffffffff0018fe63a30c08060000000000000000000000000000000000000;
        #40;
		   of_match_field_data=356'h0000007600000076c205634dc205634d0000c203633e00008847000000024302a0280702a0a00404000000000;
		  #40;
		   of_match_field_data=356'h00000062000000623c970e813c970e8144c10018fe63a30c0800000000000302a0000b02a0000404000000000;
		  #40;
		#40;
		
		*/
		// Add stimulus here
        $finish;
	end
	
	always begin
	#5 clk=~clk;
	end
      
endmodule

