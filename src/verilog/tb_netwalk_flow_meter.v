`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:24:47 02/03/2016
// Design Name:   netwalk_flow_meter
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_flow_meter.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_flow_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_netwalk_flow_meter;

	// Inputs
	reg clk;
	reg reset;
	reg glbl_program_en;
	reg [5:0] meter_program_addr;
	reg meter_program_enable;
	reg meter_delete_enable;
	reg [5:0] meter_of_match_addr;
	reg meter_of_match_found;
	reg meter_read_en;
	reg [5:0] meter_read_addr;

	// Outputs
	wire [31:0] meter_count;
	wire meter_count_valid;
	wire [31:0] meter_read_data;

integer i;
	// Instantiate the Unit Under Test (UUT)
	netwalk_flow_meter uut (
		.clk(clk), 
		.reset(reset), 
		.glbl_program_en(glbl_program_en), 
		.meter_program_addr(meter_program_addr), 
		.meter_program_enable(meter_program_enable), 
		.meter_delete_enable(meter_delete_enable), 
		.meter_of_match_addr(meter_of_match_addr), 
		.meter_of_match_found(meter_of_match_found), 
		.meter_count(meter_count), 
		.meter_count_valid(meter_count_valid), 
		.meter_read_en(meter_read_en), 
		.meter_read_addr(meter_read_addr), 
		.meter_read_data(meter_read_data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		glbl_program_en = 0;
		meter_program_addr = 0;
		meter_program_enable = 0;
		meter_delete_enable = 0;
		
		meter_of_match_addr = 0;
		meter_of_match_found = 0;
		meter_read_en = 0;
		meter_read_addr = 0;
       reset=1;
		 #10;
		 reset=0;
		// Wait 100 ns for global reset to finish
		#100;  
		meter_program_addr = 0;
		meter_program_enable = 1;
		meter_delete_enable = 0;
		#10;
		meter_program_addr = 1;
		#10;
		meter_program_addr = 2;
		#10;
		meter_program_enable =0;
		meter_delete_enable = 0;
		#40;
		for(i=0;i<10;i=i+1)begin
		meter_of_match_addr = 0;
		meter_of_match_found = 1;
		#10;
		
		end
		meter_of_match_found = 0;
		#40;
		// Add stimulus here
	end	
	always begin
		#5 clk=~clk;
	end
      
endmodule

