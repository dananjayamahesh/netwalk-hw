`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:00:07 01/13/2016
// Design Name:   netwalk_execution_engine_core
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_execution_engine_core.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_execution_engine_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_netwalk_execution_engine_core;

	// Inputs
	reg clk;
	reg reset;
	reg[371:0] exec_in;
	reg[511:0] pkt_header_in;
	wire [15:0] exec_action_flag;
	wire [355:0] exec_action_set;
	reg exec_action_enable;
	reg [8:0] OF_INGRESS_PORT_ADDR;
	reg [8:0] OF_META_DATA_ADDR;
	reg [8:0] OF_DST_MAC_ADDR_ADDR;
	reg [8:0] OF_SRC_MAC_ADDR_ADDR;
	reg [8:0] OF_ETHER_TYPE_ADDR;
	reg [8:0] OF_VLAN_ID_ADDR;
	reg [8:0] OF_VLAN_PRIORITY_ADDR;
	reg [8:0] OF_MPLS_LABEL_ADDR;
	reg [8:0] OF_MPLS_FEC_CLASS_ADDR;
	reg [8:0] OF_SRC_IPV4_ADDR_ADDR;
	reg [8:0] OF_DST_IPV4_ADDR_ADDR;
	reg [8:0] OF_IP_PROTOCOL_ADDR;
	reg [8:0] OF_IPV4_TOS_ADDR;
	reg [8:0] OF_TCP_SRC_PORT_ADDR;
	reg [8:0] OF_TCP_DST_PORT_ADDR;
	
assign exec_action_flag=exec_in[371:356];
assign exec_action_set=exec_in[511:0];
	// Outputs
	
	wire [511:0] pkt_header_out;
	wire packet_out_enable;
	
	integer read_program_file;
	integer read_program_data;
	integer read_file;
	integer read_data;	
	

integer i;
	// Instantiate the Unit Under Test (UUT)
	netwalk_execution_engine_core uut (
		.clk(clk), 
		.reset(reset), 
		.pkt_header_in(pkt_header_in), 
		.exec_action_flag(exec_action_flag), 
		.exec_action_set(exec_action_set), 
		.exec_action_enable(exec_action_enable), 
		.pkt_header_out(pkt_header_out), 
		.packet_out_enable(packet_out_enable), 
		.OF_INGRESS_PORT_ADDR(OF_INGRESS_PORT_ADDR), 
		.OF_META_DATA_ADDR(OF_META_DATA_ADDR), 
		.OF_DST_MAC_ADDR_ADDR(OF_DST_MAC_ADDR_ADDR), 
		.OF_SRC_MAC_ADDR_ADDR(OF_SRC_MAC_ADDR_ADDR), 
		.OF_ETHER_TYPE_ADDR(OF_ETHER_TYPE_ADDR), 
		.OF_VLAN_ID_ADDR(OF_VLAN_ID_ADDR), 
		.OF_VLAN_PRIORITY_ADDR(OF_VLAN_PRIORITY_ADDR), 
		.OF_MPLS_LABEL_ADDR(OF_MPLS_LABEL_ADDR), 
		.OF_MPLS_FEC_CLASS_ADDR(OF_MPLS_FEC_CLASS_ADDR), 
		.OF_SRC_IPV4_ADDR_ADDR(OF_SRC_IPV4_ADDR_ADDR), 
		.OF_DST_IPV4_ADDR_ADDR(OF_DST_IPV4_ADDR_ADDR), 
		.OF_IP_PROTOCOL_ADDR(OF_IP_PROTOCOL_ADDR), 
		.OF_IPV4_TOS_ADDR(OF_IPV4_TOS_ADDR), 
		.OF_TCP_SRC_PORT_ADDR(OF_TCP_SRC_PORT_ADDR), 
		.OF_TCP_DST_PORT_ADDR(OF_TCP_DST_PORT_ADDR)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		pkt_header_in = 0;
	//	exec_action_flag = 0;
	//	exec_action_set = 0;
		exec_action_enable = 0;
		OF_INGRESS_PORT_ADDR = 0;
		OF_META_DATA_ADDR = 0;
		OF_DST_MAC_ADDR_ADDR = 0;
		OF_SRC_MAC_ADDR_ADDR = 0;
		OF_ETHER_TYPE_ADDR = 0;
		OF_VLAN_ID_ADDR = 0;
		OF_VLAN_PRIORITY_ADDR = 0;
		OF_MPLS_LABEL_ADDR = 0;
		OF_MPLS_FEC_CLASS_ADDR = 0;
		OF_SRC_IPV4_ADDR_ADDR = 0;
		OF_DST_IPV4_ADDR_ADDR = 0;
		OF_IP_PROTOCOL_ADDR = 0;
		OF_IPV4_TOS_ADDR = 0;
		OF_TCP_SRC_PORT_ADDR = 0;
		OF_TCP_DST_PORT_ADDR = 0;
		
		read_program_file =		$fopen("input/pkt_header.txt","r");	
		read_file =		      $fopen("input/exec_engine_program_input.txt","r");
		#100;
				reset=1;
		#30;
		reset=0;
     	#40;
		exec_action_enable=1'b1;
    	for(i=0;i<4;i=i+1)begin
		     read_program_data = $fscanf(read_program_file, "%x", pkt_header_in);
			  read_data= $fscanf(read_file, "%x", exec_in);
			    // exec_program_addr = i;
		    #10;
		 end
	end
	
	always begin
	#5 clk= ~clk;
	end
      
endmodule

