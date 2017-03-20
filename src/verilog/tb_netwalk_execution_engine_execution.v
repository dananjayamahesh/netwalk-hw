`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:22:18 01/12/2016
// Design Name:   netwalk_execution_engine_execution
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_execution_engine_execution.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_execution_engine_execution
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_netwalk_execution_engine_execution;

	// Inputs
	reg clk;
	reg reset;
	reg [3:0] exec_action_flag;
	reg [355:0] exec_action_set;
	reg exec_action_enable;

	// Outputs
	wire [511:0] pkt_header_out;
	wire packet_out_enable;

	// Instantiate the Unit Under Test (UUT)
	netwalk_execution_engine_execution uut (
		.clk(clk), 
		.reset(reset), 
		.exec_action_flag(exec_action_flag), 
		.exec_action_set(exec_action_set), 
		.exec_action_enable(exec_action_enable), 
		.pkt_header_out(pkt_header_out), 
		.packet_out_enable(packet_out_enable)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		exec_action_flag = 0;
		exec_action_set = 0;
		exec_action_enable = 0;

		// Wait 100 ns for global reset to finish
		#100;
		exec_action_flag = 4'b0001;
		exec_action_set = 356'h0000007200000072005056a5005056a5644d0050569a0007080000000000002b61934c2b61934844006a506a5;
		exec_action_enable = 1;
		#40;
		
		exec_action_flag = 4'b0010;
		exec_action_set = 356'h0000007200000072005056a5005056a5644d0050569a88c7080000000000002b61934c2b61934844006a506a5;
      exec_action_enable = 1;
		#40;
        
		// Add stimulus here

	end
	
	always begin
	#5 clk = ~clk;
	end
      
endmodule

