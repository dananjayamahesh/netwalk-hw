`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MAHESH DANANJAYA
// 
// Create Date:    23:34:30 01/14/2016 
// Design Name: 
// Module Name:    netwalk_packet_handler 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module netwalk_packet_handler
#(parameter OF_FLOW_TAG_WIDTH=5,ADDR_WIDTH=32,DPL_PKT_BIT_WIDTH=512,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6,DPL_MATCH_FIELD_WIDTH=356)
(
clk,
reset,
glbl_program_en,

pkt_header_in,
of_table_missed,

openflow_packet_found,
packet_to_switch_found,

of_dpl_program_enable,
of_dpl_program_data,
of_dpl_program_mask,
of_dpl_action_flag,
of_dpl_action_set,

pkt_header_out,
of_table_missed_en,

pkt_addr_in,
of_flow_tag_in,
of_flow_tag_out
//pkt_addr_out
);


input clk;
input reset;
input glbl_program_en;

input [DPL_PKT_BIT_WIDTH-1:0] pkt_header_in;
input of_table_missed;
input openflow_packet_found;
input packet_to_switch_found;

output reg [DPL_PKT_BIT_WIDTH-1:0]pkt_header_out;
output reg of_table_missed_en;

output reg of_dpl_program_enable;
output reg [DPL_MATCH_FIELD_WIDTH-1:0]of_dpl_program_data;
output reg [DPL_MATCH_FIELD_WIDTH-1:0]of_dpl_program_mask;
output reg [ACTION_FLAG_WIDTH-1:0]of_dpl_action_flag;
output reg [ACTION_SET_WIDTH-1:0]of_dpl_action_set;

input [(ADDR_WIDTH*15)-1:0] pkt_addr_in;

input [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_in;
output reg [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out;
//output reg [(ADDR_WIDTH*15)-1:0] pkt_addr_out;

wire[ADDR_WIDTH-1:0]	OF_INGRESS_PORT_ADDR;
wire[ADDR_WIDTH-1:0] OF_META_DATA_ADDR;
wire[ADDR_WIDTH-1:0]	OF_DST_MAC_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]	OF_SRC_MAC_ADDR_ADDR;
wire[ADDR_WIDTH-1:0] OF_ETHER_TYPE_ADDR;
wire[ADDR_WIDTH-1:0]			OF_VLAN_ID_ADDR;
wire[ADDR_WIDTH-1:0]	OF_VLAN_PRIORITY_ADDR;
wire[ADDR_WIDTH-1:0]	OF_MPLS_LABEL_ADDR;
wire[ADDR_WIDTH-1:0]		OF_MPLS_FEC_CLASS_ADDR;
wire[ADDR_WIDTH-1:0]OF_SRC_IPV4_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]OF_DST_IPV4_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]	OF_IP_PROTOCOL_ADDR;
wire[ADDR_WIDTH-1:0]		OF_IPV4_TOS_ADDR;
wire[ADDR_WIDTH-1:0]	OF_TCP_SRC_PORT_ADDR;
wire[ADDR_WIDTH-1:0]	OF_TCP_DST_PORT_ADDR;

assign {OF_INGRESS_PORT_ADDR, OF_META_DATA_ADDR, OF_DST_MAC_ADDR_ADDR, OF_SRC_MAC_ADDR_ADDR , OF_ETHER_TYPE_ADDR,OF_VLAN_ID_ADDR,OF_VLAN_PRIORITY_ADDR,OF_MPLS_LABEL_ADDR,OF_MPLS_FEC_CLASS_ADDR,OF_SRC_IPV4_ADDR_ADDR,OF_DST_IPV4_ADDR_ADDR,OF_IP_PROTOCOL_ADDR,OF_IPV4_TOS_ADDR,OF_TCP_SRC_PORT_ADDR,	OF_TCP_DST_PORT_ADDR}=pkt_addr_in;

reg [DPL_PKT_BIT_WIDTH-1:0] pkt_header_in_reg;
reg of_table_missed_reg;
reg openflow_packet_found_reg;
reg packet_to_switch_found_reg;

reg [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_in_reg=0;

reg [(ADDR_WIDTH*15)-1:0] pkt_addr_in_reg;

always@(posedge clk)begin
	if(!reset)begin
	      if(!glbl_program_en)begin
			  pkt_header_in_reg<=pkt_header_in;
			  of_table_missed_reg<=of_table_missed;
			  openflow_packet_found_reg<=openflow_packet_found;
			  packet_to_switch_found_reg<=packet_to_switch_found;	
			  of_flow_tag_in_reg<=of_flow_tag_in;		  
				//pkt_addr_out<=pkt_addr_in_reg;	
				//pkt_header_out<=pkt_header_in_reg;
				
			end
			else begin
			     
			end
	end
	else begin
		
				pkt_header_in_reg<=0;
			  of_table_missed_reg<=0;
			  openflow_packet_found_reg<=0;
			  packet_to_switch_found_reg<=0;
			   of_flow_tag_in_reg<=0;				  
			  //pkt_addr_out<=0;
			  //pkt_header_out<=0;
	end
end

always@(posedge clk)begin
	if(!reset)begin
	   if(!glbl_program_en)begin
	      if(of_table_missed_reg)begin
		       if(packet_to_switch_found_reg)begin
				        if(openflow_packet_found_reg)begin
						       of_dpl_program_enable<=1;
						  end
						  else  begin
						     of_dpl_program_enable<=0;							  
						  end
				 end
				 else begin
				         of_dpl_program_enable<=0;
				 end
				 
				 pkt_header_out<= pkt_header_in_reg;
				 of_table_missed_en<=of_table_missed_reg;
				  of_flow_tag_out<=of_flow_tag_in_reg;					 
		 end
		 else begin
					of_dpl_program_enable<=0;
					pkt_header_out<= 0;
					of_table_missed_en<=of_table_missed_reg;
					of_flow_tag_out<=0;
		 end
		 
		end//GLBL_PROGRAM END 
	end//RESET END
	else begin
					of_dpl_program_enable<=0;
					pkt_header_out<= 0;
					of_table_missed_en<=0;
					of_flow_tag_out<=0;
	end
end
endmodule
