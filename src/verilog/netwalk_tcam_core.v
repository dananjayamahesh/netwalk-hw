`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:28:02 01/09/2016 
// Design Name: 
// Module Name:    netwalk_tcam_core 
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
module netwalk_tcam_core
#(parameter OF_FLOW_TAG_WIDTH=5,ADDR_WIDTH=32,DPL_PKT_BIT_WIDTH=512,TCAM_ADDR_WIDTH=6,DPL_MATCH_FIELD_WIDTH=356)
(
clk,
reset,
glbl_program_en,

tcam_program_data,
tcam_program_mask,
tcam_program_addr,
tcam_program_enable,
tcam_delete_enable,

pkt_header_in,

of_match_field_data,
of_flow_found,

of_matched_addr_out,
of_matched_decoded_addr_out,
of_match_found,
of_table_missed ,

openflow_packet_found,
packet_to_switch_found,

pkt_header_out,

of_flow_found_buff,
of_match_found_,
addr_to_tcam,
addr_from_tcam,

pkt_addr_in,//ADDRESS OF FIELDS
pkt_addr_out,

of_flow_tag_in,
of_flow_tag_out

);

input [(ADDR_WIDTH*15)-1:0] pkt_addr_in;
output reg[(ADDR_WIDTH*15)-1:0] pkt_addr_out;
input [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_in;
output reg [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out;

parameter TCAM_SIZE=1<<TCAM_ADDR_WIDTH;
parameter DPL_MATCHED_ADDR_WIDTH=TCAM_SIZE;

parameter EGRESS_PORT_WIDTH		=32;
parameter METADATA_WIDTH			=64;
parameter MAC_ADDR_WIDTH			=48;
parameter SRC_MAC_ADDR_WIDTH		=48;
parameter DST_MAC_ADDR_WIDTH		=48;
parameter ETHER_TYPE_WIDTH			=16;

parameter VLAN_TPID_WIDTH			=16;
parameter VLAN_PRIORITY_WIDTH		=3;
parameter VLAN_CFI_WIDTH			=1;
parameter VLAN_ID_WIDTH				=12;

parameter MPLS_LABEL_WIDTH			=20;
parameter MPLS_COS_WIDTH			=3;
parameter MPLS_S_WIDTH				=1;
parameter MPLS_TTL_WIDTH			=8;

parameter MPLS_FEC_WIDTH			=3;
parameter MPLS_FEC_CLASS_WIDTH	=3;

parameter IP_VERSION_WIDTH			=4;
parameter IP_IHL_WIDTH				=4;
parameter IP_DSCP_WIDTH				=6;
parameter IP_ECN_WIDTH				=2;
parameter IP_LENGTH_WIDTH			=16;
parameter IP_ID_WIDTH				=16;
parameter IP_FLAG_WIDTH				=3;
parameter IP_FRAGOFF_WIDTH			=13;
parameter IP_TTL_WIDTH				=8;
parameter IP_PROTOCOL_WIDTH		=8;
parameter IP_CHECKSUM_WIDTH		=16;
parameter IP_ADDR_WIDTH				=32;
parameter IP_SRC_ADDR_WIDTH		=32;
parameter IP_DST_ADDR_WIDTH		=32;

//parameter IP_TOS_WIDTH=IP_DSCP_WIDTH+IP_ECN_WIDTH;
parameter IP_TOS_WIDTH=IP_DSCP_WIDTH;
parameter TCP_PORT_WIDTH			=16;
parameter TCP_SRC_PORT_WIDTH			=16;
parameter TCP_DST_PORT_WIDTH			=16;
parameter TCP_SEQN_WIDTH			=32;
parameter TCP_ACKN_WIDTH			=32;
parameter TCP_DTOFF_WIDTH			=4;
parameter TCP_RESV_WIDTH			=3;
parameter TCP_NS_WIDTH				=1;
parameter TCP_CWR_WIDTH				=1;
parameter TCP_ECE_WIDTH				=1;
parameter TCP_UGR_WIDTH				=1;
parameter TCP_ACK_WIDTH				=1;
parameter TCP_PSH_WIDTH				=1;
parameter TCP_RST_WIDTH				=1;
parameter TCP_SYN_WIDTH				=1;
parameter TCP_FIN_WIDTH				=1;
parameter TCP_WINSIZE_WIDTH		=16;
parameter TCP_CHECKSUM_WIDTH		=16;
parameter TCP_URGPNT_WIDTH			=16;

parameter UDP_PORT_WIDTH			=16;
parameter UDP_SRC_PORT_WIDTH		=16;
parameter UDP_DST_PORT_WIDTH		=16;
parameter UDP_LENGTH_WIDTH			=16;
parameter UDP_CHECKSUM_WIDTH		=16;
parameter SRC_IPV4_ADDR_OFFSET	=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH;
parameter DST_IPV4_ADDR_OFFSET	=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH;
parameter TCP_SRC_PORT_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH+IP_DST_ADDR_WIDTH+IP_PROTOCOL_WIDTH+IP_TOS_WIDTH;
parameter TCP_DST_PORT_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH+IP_DST_ADDR_WIDTH+IP_PROTOCOL_WIDTH+IP_TOS_WIDTH+TCP_SRC_PORT_WIDTH;


parameter OPENFLOW_SRC_PORT 		= 16'h6633;
parameter SWICTH_IP_ADDR    		=32'h00000000;
parameter SWICTH_MAC_ADDR			=48'h000000000000;

input clk;
input reset;
input glbl_program_en;

input [DPL_MATCH_FIELD_WIDTH-1:0]tcam_program_data;
input [DPL_MATCH_FIELD_WIDTH-1:0]tcam_program_mask;
input [TCAM_ADDR_WIDTH-1:0]tcam_program_addr;
input tcam_program_enable;
input tcam_delete_enable;
input [DPL_MATCH_FIELD_WIDTH-1:0]of_match_field_data;
input of_flow_found;

input [DPL_PKT_BIT_WIDTH-1:0] pkt_header_in;
output reg[DPL_PKT_BIT_WIDTH-1:0] pkt_header_out;

output [TCAM_SIZE-1:0]of_matched_addr_out;
output [TCAM_ADDR_WIDTH-1:0]of_matched_decoded_addr_out;
output of_match_found;
output of_table_missed;

output reg openflow_packet_found;
output reg packet_to_switch_found;

wire [TCAM_SIZE-1:0]tcam_addr;

wire	[IP_ADDR_WIDTH-1:0] ip_dst_addr;
wire 	[TCP_PORT_WIDTH-1:0] src_port;
wire	[IP_ADDR_WIDTH-1:0] ip_src_addr;
wire 	[TCP_PORT_WIDTH-1:0] dst_port;


output [TCAM_SIZE-1:0]addr_to_tcam;
output [TCAM_ADDR_WIDTH-1:0]addr_from_tcam;
output reg of_flow_found_buff;
output of_match_found_;

assign of_match_found_=(| of_matched_addr_out);
assign of_match_found= (of_flow_found_buff)?of_match_found_:1'b0;
assign of_table_missed=(of_flow_found_buff & (!of_match_found_));

assign addr_to_tcam=tcam_addr;
assign addr_from_tcam=of_matched_decoded_addr_out;

assign ip_dst_addr=of_match_field_data[DST_IPV4_ADDR_OFFSET-1:DST_IPV4_ADDR_OFFSET-IP_ADDR_WIDTH];
assign ip_src_addr=of_match_field_data[SRC_IPV4_ADDR_OFFSET-1:SRC_IPV4_ADDR_OFFSET-IP_ADDR_WIDTH];
assign src_port=of_match_field_data[TCP_SRC_PORT_OFFSET-1:TCP_SRC_PORT_OFFSET-TCP_PORT_WIDTH];
assign dst_port=of_match_field_data[TCP_DST_PORT_OFFSET-1:TCP_DST_PORT_OFFSET-TCP_PORT_WIDTH];

always@(posedge clk)begin
 if(!reset)begin
    if(!glbl_program_en)begin
     of_flow_found_buff<=of_flow_found;
	 pkt_header_out<=pkt_header_in;
	 pkt_addr_out<=pkt_addr_in;
	 of_flow_tag_out<=of_flow_tag_in;
	 end
 end
 else begin
    of_flow_found_buff<=1'b0;
	  pkt_header_out<=0;
	  pkt_addr_out<=0;
	  of_flow_tag_out<=0;
 end

end

always@(posedge clk)begin
		if(!reset)begin
		   if(!glbl_program_en)begin
           if(src_port==OPENFLOW_SRC_PORT)begin
			       openflow_packet_found=1;
			  end else begin
			       openflow_packet_found=0;
			  end
			  
			  if(ip_dst_addr==SWICTH_IP_ADDR)begin
			       packet_to_switch_found=1;
			  end else begin
			       packet_to_switch_found=0;
			  end
			end//GLBL
		end
		else begin
            openflow_packet_found=0;
				packet_to_switch_found=0;
		end
end

netwalk_decoder
#(.DECODER_IN_WIDTH(TCAM_ADDR_WIDTH))  decoder
	(
		.clk(clk), 
		.reset(reset), 
		.decoder_in(tcam_program_addr), 
		.decoder_out(tcam_addr)
	);

genvar i;
generate 
for(i=0;i<TCAM_SIZE;i=i+1)begin:tcam_unit_generate
netwalk_tcam_unit
#(.TCAM_UNIT_ADDR(0),.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
	tcam_unit
	(
		.clk(clk), 
		.reset(reset), 
		.tcam_program_data(tcam_program_data), 
		.tcam_program_mask(tcam_program_mask), 
		.tcam_program_addr(tcam_program_addr), 
		.tcam_unit_sel(tcam_addr[i]),
		.tcam_program_enable(tcam_program_enable), 
		.tcam_delete_enable(tcam_delete_enable),
		.of_match_field_data(of_match_field_data), 
		.of_matched_addr_out(of_matched_addr_out[i])
		//.of_matched_out()
	);

end 
endgenerate

	netwalk_encoder
	#(.ENCODER_OUT_WIDTH(TCAM_ADDR_WIDTH))encoder
	(
		.clk(clk), 
		.reset(reset), 
		.encoder_in(of_matched_addr_out), 
		.encoder_out(of_matched_decoded_addr_out)
	);

endmodule
