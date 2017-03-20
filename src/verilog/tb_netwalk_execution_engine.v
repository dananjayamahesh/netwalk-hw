`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:30:07 01/12/2016
// Design Name:   netwalk_execution_engine
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_execution_engine.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_execution_engine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module tb_netwalk_execution_engine_action_fetch;
parameter ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6;
parameter PROGRAM_DATA_WIDTH= ACTION_FLAG_WIDTH + ACTION_SET_WIDTH;
	// Inputs
	reg clk;
	reg reset;
	reg [PROGRAM_DATA_WIDTH-1:0] exec_program_data;
	reg [TCAM_ADDR_WIDTH-1:0] exec_program_addr;
	reg exec_program_enable;
	reg exec_delete_enable;
	reg [TCAM_ADDR_WIDTH-1:0] exec_of_match_addr;
	reg exec_of_match_found;
	
	// Outputs
	wire [ACTION_FLAG_WIDTH-1:0] exec_action_flag;
	wire [ACTION_SET_WIDTH-1:0] exec_action_set;
	wire exec_action_enable;
	
	integer read_program_file;
	integer read_program_data;
	integer read_file;
	integer read_data;	
	
	integer output_file;
	integer output_data;	
	
	integer i=0;


	// Instantiate the Unit Under Test (UUT)
	netwalk_execution_engine_action_fetch_unit
	#(.ACTION_FLAG_WIDTH(ACTION_FLAG_WIDTH),.ACTION_SET_WIDTH(ACTION_SET_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
	exec_engine (
		.clk(clk), 
		.reset(reset), 
		.exec_program_data(exec_program_data), 
		.exec_program_addr(exec_program_addr), 
		.exec_program_enable(exec_program_enable), 
		.exec_delete_enable(exec_delete_enable), 
		.pkt_header_in(),
		.exec_of_match_addr(exec_of_match_addr), 
		.exec_of_match_found(exec_of_match_found), 
		
		.exec_action_flag(exec_action_flag), 
		.exec_action_set(exec_action_set), 
		.exec_action_enable(exec_action_enable),
		
		.pkt_header_out()
	);

	initial begin
		// Initialize Inputs
		
			read_program_file =		$fopen("input/exec_engine_program_input.txt","r");	
			output_file =		$fopen("output/exec_engine_output.txt","w+");
			read_file =		$fopen("input/exec_engine_input.txt","r");	
			output_file =		$fopen("output/exec_engine_output.txt","w+");
		
		clk = 0;
		reset = 0;
		exec_program_data = 0;
		exec_program_addr = 0;
		exec_program_enable = 0;
		exec_delete_enable = 0;
		
		exec_of_match_addr = 0;
		exec_of_match_found = 0;
		// Wait 100 ns for global reset to finish
		#100;
				reset=1;
		#30;
		reset=0;
     	#40;
		
      exec_program_enable=1'b1;
			for(i=0;i<5;i=i+1)begin
		     read_program_data = $fscanf(read_program_file, "%x", exec_program_data);
			  		exec_program_addr = i;
		    #40;
		 end
		     exec_program_enable=1'b0;
			  exec_of_match_found=1'b1;
			  #40;
			exec_of_match_addr=1;
			 #40;
			exec_of_match_addr=2;
		   #40;
			exec_of_match_addr=3;
			#40;
        
		  exec_of_match_found=1'b0;
		  #40;
		// Add stimulus here

end
	always begin
		#5 clk =~clk;
	end
      
endmodule

