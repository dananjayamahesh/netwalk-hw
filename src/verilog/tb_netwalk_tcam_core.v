`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:08:00 01/11/2016
// Design Name:   netwalk_tcam_core
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_tcam_core.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_tcam_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module tb_netwalk_tcam_core;
   parameter TCAM_SIZE=64,TCAM_ADDR_WIDTH=8,DPL_MATCH_FIELD_WIDTH=356;
	// Inputs
	reg clk;
	reg reset;
	reg [DPL_MATCH_FIELD_WIDTH-1:0] tcam_program_data;
	reg [DPL_MATCH_FIELD_WIDTH-1:0]  tcam_program_mask;
	reg [TCAM_ADDR_WIDTH-1:0] tcam_program_addr;
	reg tcam_program_enable;
	reg tcam_delete_enable;
	reg of_flow_found;
	reg [DPL_MATCH_FIELD_WIDTH-1:0]  of_match_field_data;
	// Outputs
	wire of_match_found;
	wire [TCAM_SIZE-1:0] of_matched_addr_out;
	wire [TCAM_ADDR_WIDTH-1:0] of_matched_decoded_addr_out;
	wire of_table_missed;
	wire of_flow_found_buff;
	wire of_match_found_;
	
wire [TCAM_SIZE-1:0]addr_to_tcam;
wire [TCAM_ADDR_WIDTH-1:0]addr_from_tcam;
	
	integer read_file;
	integer read_data;	
	integer read_field_file;
	integer read_field_data;	
	integer output_file;
	integer output_data;	
	integer output_bit_file;
	integer output_bit_data;
	integer i=0;

	// Instantiate the Unit Under Test (UUT)
	netwalk_tcam_core 
#(.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
tcam_core
	(
		.clk(clk), 
		.reset(reset), 
		.tcam_program_data(tcam_program_data), 
		.tcam_program_mask(tcam_program_mask), 
		.tcam_program_addr(tcam_program_addr), 
		.tcam_program_enable(tcam_program_enable), 
		.tcam_delete_enable(tcam_delete_enable), 
		
		.pkt_header_in(),
		
		.of_match_field_data(of_match_field_data), 		
		.of_flow_found(of_flow_found), 
		.of_matched_addr_out(of_matched_addr_out), 
		.of_matched_decoded_addr_out(of_matched_decoded_addr_out),
		.of_match_found(of_match_found),
		.of_table_missed(of_table_missed),
		.pkt_header_out(),
		
		.of_flow_found_buff(of_flow_found_buff),
		.of_match_found_(of_match_found_),
		.addr_to_tcam(addr_to_tcam),
		.addr_from_tcam(addr_from_tcam)
	);

	initial begin
		// Initialize Inputs
			read_file =		$fopen("input/tcam_input.txt","r");	
			read_field_file =		$fopen("input/of_field_input.txt","r");	
	output_file =		$fopen("output/tcam_core_output.txt","w+");
	output_bit_file =		$fopen("output/tcam_core_bit_output.txt","w+");
		clk = 0;
		reset = 0;
		tcam_program_data = 0;
		tcam_program_mask = 0;
		tcam_program_addr = 0;
		tcam_program_enable = 0;
		tcam_delete_enable = 0;
		of_match_field_data = 0;
		of_flow_found=0;
		reset=1;
		#30;
		reset=0;
     	#40;
		tcam_program_mask=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
      tcam_program_enable=1'b1;
			for(i=0;i<5;i=i+1)begin
		     read_data = $fscanf(read_file, "%x", tcam_program_data);
			  		tcam_program_addr = i;
					#40;
		   end
		#40;
			tcam_program_enable=1'b0;
			of_flow_found=1;
		#40;		
		for(i=0;i<5;i=i+1)begin
		read_field_data = $fscanf(read_field_file, "%x", of_match_field_data);
		 #40;
		 end
		 #40;
		 tcam_program_enable=1;
		 tcam_delete_enable=1;
		 #100;		 
		 $fclose(output_file);
       $finish;
        
		// Add stimulus here

	end
	
	always begin
	#5 clk= ~clk;
	end
	
	always@(posedge clk)begin
	//$fdisplay(output_file,"TCAM_PROGRAM_DATA: %x \nTCAM_PROGRAM_MASK: %x \nSDN_MATCH_FIELD_DATA:%x \nOF_MATCHED_OUT: %x \nOF_MATCHED_ADDR_OUT: %b \n",tcam_program_data,tcam_program_mask,of_match_field_data,of_matched_out,of_matched_addr_out);
       $fdisplay(output_file,"%x \n%x \n%b \n%b \n%x \n%b \n%b \n%b \n%b \n%b \n%b \n",tcam_program_data,tcam_program_mask,tcam_program_addr,tcam_program_enable,of_match_field_data,of_matched_addr_out,of_matched_decoded_addr_out,of_match_found,of_table_missed,addr_to_tcam,addr_from_tcam);
   $fdisplay(output_bit_file,"%b \n%b \n%b \n%b \n%b \n%b \n%b \n%b \n%b \n%b \n%b \n",tcam_program_data,tcam_program_mask,tcam_program_addr,tcam_program_enable,of_match_field_data,of_matched_addr_out,of_matched_decoded_addr_out, of_match_found,of_table_missed,addr_to_tcam,addr_from_tcam);

	end
      
endmodule

