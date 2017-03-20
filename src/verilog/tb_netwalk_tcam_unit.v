`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:Mahesh Dananjaya
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
module tb_netwalk_tcam_unit;
	parameter TCAM_UNIT_ADDR=0,DPL_MATCH_FIELD_WIDTH=356,TCAM_ADDR_WIDTH=6;
	// Inputs
	reg clk;
	reg reset;
	reg [DPL_MATCH_FIELD_WIDTH-1:0] tcam_program_data;
	reg [DPL_MATCH_FIELD_WIDTH-1:0] tcam_program_mask;
	reg [TCAM_ADDR_WIDTH-1:0] tcam_program_addr;
	reg tcam_unit_sel;
	reg tcam_program_enable;
	reg tcam_delete_enable;
	reg [DPL_MATCH_FIELD_WIDTH-1:0] of_match_field_data;

	// Outputs
	wire of_matched_addr_out;
	wire [DPL_MATCH_FIELD_WIDTH-1:0] of_matched_out;
	
	integer read_file;
	integer read_data;
	
	integer output_file;
	integer output_data;
	
	integer output_bit_file;
	integer output_bit_data;
	integer i=0;

	// Instantiate the Unit Under Test (UUT)
	netwalk_tcam_unit
#(.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
	tcam_unit0 (
		.clk(clk), 
		.reset(reset), 
		.tcam_program_data(tcam_program_data), 
		.tcam_program_mask(tcam_program_mask), 
		.tcam_program_addr(tcam_program_addr), 
		.tcam_program_enable(tcam_program_enable), 
		.tcam_unit_sel(tcam_unit_sel),
		.tcam_delete_enable(tcam_delete_enable),
		.of_match_field_data(of_match_field_data), 
		.of_matched_addr_out(of_matched_addr_out),
		.of_matched_out(of_matched_out)		
	);

	initial begin
	
	read_file =		$fopen("input/tcam_input.txt","r");	
	output_file =		$fopen("output/tcam_output.txt","w+");
	output_bit_file =		$fopen("output/tcam_bit_output.txt","w+");
		// Initialize Inputs
		clk = 0;
		reset = 0;
		tcam_program_data = 0;
		tcam_program_mask = 0;
		tcam_program_addr = 0;
		tcam_program_enable = 0;
		tcam_delete_enable	=0;
		of_match_field_data = 0;
		tcam_unit_sel=1'b1;
		

		// Wait 100 ns for global reset to finish
		/*#40;
		tcam_program_data=356'h0000007200000072005056a5005056a5644d0050569a78c7080000000000002b61934c2b61934844006a506a5;
		tcam_program_mask=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
		tcam_program_addr = 10'b000000;
		tcam_program_enable=1'b1;
		tcam_unit_sel=1'b1;
		#40;
			tcam_program_enable=1'b0;
				tcam_unit_sel=1'b1;
		#40;
		*/
		for(i=0;i<5;i=i+1)begin
		read_data = $fscanf(read_file, "%x", of_match_field_data);
		 #40;
		 end
		 #40;
		 tcam_program_enable=1;
		 tcam_delete_enable=1;
		 #100;		 
		 $fclose(output_file);
       $finish;
	end
	
	always begin
	#5 clk=~clk;
	end
	
	always@(posedge clk)begin
	//$fdisplay(output_file,"TCAM_PROGRAM_DATA: %x \nTCAM_PROGRAM_MASK: %x \nSDN_MATCH_FIELD_DATA:%x \nOF_MATCHED_OUT: %x \nOF_MATCHED_ADDR_OUT: %b \n",tcam_program_data,tcam_program_mask,of_match_field_data,of_matched_out,of_matched_addr_out);
   $fdisplay(output_file,"%x \n%x \n%x \n%x \n%b \n",tcam_program_data,tcam_program_mask,of_match_field_data,of_matched_out,of_matched_addr_out);
   $fdisplay(output_bit_file,"%b \n%b \n%b \n%b \n%b \n",tcam_program_data,tcam_program_mask,of_match_field_data,of_matched_out,of_matched_addr_out);

	end
      
endmodule

