`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:	MAHESH DANANJAYA
//
// Create Date:   14:45:28 02/04/2016
// Design Name:   netwalk_packet_handler
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_packet_handler.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_packet_handler
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_netwalk_packet_handler;

	// Inputs
	reg clk;
	reg reset;
	reg glbl_program_en;
	reg [511:0] pkt_header_in;
	reg of_table_missed;
	reg openflow_packet_found;
	reg packet_to_switch_found;
	reg [479:0] pkt_addr_in;

	// Outputs
	wire of_dpl_program_enable;
	wire [355:0] of_dpl_program_data;
	wire [355:0] of_dpl_program_mask;
	wire [511:0] pkt_header_out;
	wire missed_pkt_enable;
	wire [479:0] pkt_addr_out;

	// Instantiate the Unit Under Test (UUT)
	netwalk_packet_handler uut (
		.clk(clk), 
		.reset(reset), 
		.glbl_program_en(glbl_program_en), 
		.pkt_header_in(pkt_header_in), 
		.of_table_missed(of_table_missed), 
		.openflow_packet_found(openflow_packet_found), 
		.packet_to_switch_found(packet_to_switch_found), 
		.of_dpl_program_enable(of_dpl_program_enable), 
		.of_dpl_program_data(of_dpl_program_data), 
		.of_dpl_program_mask(of_dpl_program_mask), 
		.pkt_header_out(pkt_header_out), 
		.of_table_missed_en(missed_pkt_enable), 
		.pkt_addr_in(pkt_addr_in)//, 
		//.pkt_addr_out(pkt_addr_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		glbl_program_en = 0;
		pkt_header_in = 0;
		of_table_missed = 0;
		openflow_packet_found = 0;
		packet_to_switch_found = 0;
		pkt_addr_in = 0;
		// Wait 100 ns for global reset to finish
		#100;        
		// Add stimulus here
		pkt_addr_in<= 480'h2;
		pkt_header_in<= 608'h00000072ffffffffffffffff005056a5644d0050569a78c7080045000064310e000040116a260ad864d30ad864d206a506a5005000000003000000000bb800000000ffffffffffff00000000;
		of_table_missed<=1;
		#30;
		pkt_header_in<= 608'h00000072ffffffffffffffff005056a5644d0050569a78c7080045000064310e000040116a260ad864d30ad864d206a506a5005000000003000000000bb800000000ffffffffffff00000000;
		of_table_missed<=0;
		#20;
		pkt_addr_in<= 480'h1;
		#20;

	end
	
	always #5 clk=~clk;
      
endmodule

