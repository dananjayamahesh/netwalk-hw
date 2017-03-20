`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MAHESH DANANJAYA
// 
// Create Date:    12:15:04 01/14/2016 
// Design Name: 
// Module Name:    netwalk_dataplane_core 
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
module netwalk_dataplane_core
#(parameter OF_FLOW_TAG_WIDTH=5,DPL_PKT_BIT_WIDTH	=608, DPL_MATCH_FIELD_WIDTH=356,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356, TCAM_ADDR_WIDTH=6)
(

clk,
reset,

tcam_program_data,
tcam_program_mask,
tcam_program_addr,
tcam_program_enable,
tcam_delete_enable,

exec_program_data,
exec_program_addr,
exec_program_enable,
exec_delete_enable,

pkt_header_in,
pkt_header_ready,
pkt_header_accept,

pkt_header_out,
pkt_out_enable,

match_f,
match_d,

tcam_addr,

flow_count,
flow_count_valid,
flow_count_addr,

handler_pkt_header,
missed_pkt_en,

of_flow_tag_out,
of_flow_tag_out2

);

parameter PKT_BUFF_ADDR_WIDTH			=10;//9;
//parameter OF_FLOW_TAG_WIDTH			=5;
parameter DPL_PKT_BYTE_WIDTH			=64;
//parameter DPL_PKT_BIT_WIDTH			=608;//512;
//parameter DPL_MATCH_FIELD_WIDTH		=356; 
parameter DPL_PKT_ADDR_WIDTH			=6; 
parameter DPL_PKT_DATA_WIDTH			=8;

//parameter TCAM_ADDR_WIDTH				=6;
parameter TCAM_SIZE=1<<TCAM_ADDR_WIDTH;
parameter DPL_MATCHED_ADDR_WIDTH=TCAM_SIZE;

parameter COUNTER_MEM_SIZE=1<<TCAM_ADDR_WIDTH;	 
parameter METER_COUNTER_SIZE=32;

//parameter ACTION_FLAG_WIDTH			=16;
//parameter ACTION_SET_WIDTH				=356;

parameter PROGRAM_DATA_WIDTH=ACTION_FLAG_WIDTH+ACTION_SET_WIDTH;
parameter PROGRAM_ADDR_WIDTH=TCAM_ADDR_WIDTH;

//WIDTH
parameter INGRESS_PORT_WIDTH		=32;
parameter METADATA_WIDTH			=64;

parameter IP_ENCAP_WIDTH			=160;
parameter ETHER_ENCAP_WIDTH		=112;
parameter UDP_ENCAP_WIDTH			=64;
parameter TCP_ENCAP_WIDTH			=160;
parameter VLAN_ENCAP_WIDTH			=32;
parameter MPLS_ENCAP_WIDTH			=32;

parameter MAC_ADDR_WIDTH				=48;
parameter SRC_MAC_ADDR_WIDTH			=48;
parameter DST_MAC_ADDR_WIDTH			=48;
parameter ETHER_TYPE_WIDTH				=16;

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
parameter IP_TOS_WIDTH				=IP_DSCP_WIDTH;
parameter TCP_PORT_WIDTH			=16;
parameter TCP_SRC_PORT_WIDTH		=16;
parameter TCP_DST_PORT_WIDTH		=16;
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


parameter ADDR_WIDTH=32;
//INPUTS & OUTPUTS
input clk;
input reset;

input [DPL_PKT_BIT_WIDTH-1:0] pkt_header_in;
input pkt_header_ready;
output pkt_header_accept;

input [DPL_MATCH_FIELD_WIDTH-1:0]tcam_program_data;
input [DPL_MATCH_FIELD_WIDTH-1:0]tcam_program_mask;
input [TCAM_ADDR_WIDTH-1:0]tcam_program_addr;
input tcam_program_enable;
input tcam_delete_enable;

input [PROGRAM_DATA_WIDTH-1:0]exec_program_data;
input [PROGRAM_ADDR_WIDTH-1:0]exec_program_addr;
input exec_program_enable;
input exec_delete_enable;

output [DPL_PKT_BIT_WIDTH-1:0] pkt_header_out;
output  pkt_out_enable;

output [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out;
output [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out2;
//NETS CONNECTED
wire[INGRESS_PORT_WIDTH-1:0]	OF_INGRESS_PORT;
wire[METADATA_WIDTH-1:0]		OF_META_DATA;
wire[DST_MAC_ADDR_WIDTH-1:0]	OF_DST_MAC_ADDR;
wire[SRC_MAC_ADDR_WIDTH-1:0]	OF_SRC_MAC_ADDR;
wire[ETHER_TYPE_WIDTH-1:0]		OF_ETHER_TYPE;
wire[VLAN_ID_WIDTH-1:0]			OF_VLAN_ID;
wire[VLAN_PRIORITY_WIDTH-1:0]	OF_VLAN_PRIORITY;
wire[MPLS_LABEL_WIDTH-1:0]		OF_MPLS_LABEL;
wire[MPLS_FEC_WIDTH-1:0]		OF_MPLS_FEC_CLASS;
wire[IP_SRC_ADDR_WIDTH-1:0]	OF_SRC_IPV4_ADDR;
wire[IP_DST_ADDR_WIDTH-1:0]	OF_DST_IPV4_ADDR;
wire[IP_PROTOCOL_WIDTH-1:0]	OF_IP_PROTOCOL;
wire[IP_TOS_WIDTH-1:0]			OF_IPV4_TOS;
wire[TCP_SRC_PORT_WIDTH-1:0]	OF_TCP_SRC_PORT;
wire[TCP_DST_PORT_WIDTH-1:0]	OF_TCP_DST_PORT;
	 //PKT_BUFF_ADDR_WIDTH
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
/*
wire[ADDR_WIDTH-1:0]	TCAM_OF_INGRESS_PORT_ADDR;
wire[ADDR_WIDTH-1:0] TCAM_OF_META_DATA_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_SRC_MAC_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_DST_MAC_ADDR_ADDR;
wire[ADDR_WIDTH-1:0] TCAM_OF_ETHER_TYPE_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_VLAN_ID_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_VLAN_PRIORITY_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_MPLS_LABEL_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_MPLS_FEC_CLASS_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_SRC_IPV4_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_DST_IPV4_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_IP_PROTOCOL_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_IPV4_TOS_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_TCP_SRC_PORT_ADDR;
wire[ADDR_WIDTH-1:0]	TCAM_OF_TCP_DST_PORT_ADDR;

wire[ADDR_WIDTH-1:0]	EXEC_OF_INGRESS_PORT_ADDR;
wire[ADDR_WIDTH-1:0] EXEC_OF_META_DATA_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_SRC_MAC_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_DST_MAC_ADDR_ADDR;
wire[ADDR_WIDTH-1:0] EXEC_OF_ETHER_TYPE_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_VLAN_ID_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_VLAN_PRIORITY_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_MPLS_LABEL_ADDR;
wire[ADDR_WIDTH-1:0]		EXEC_OF_MPLS_FEC_CLASS_ADDR;
wire[ADDR_WIDTH-1:0]EXEC_OF_SRC_IPV4_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]EXEC_OF_DST_IPV4_ADDR_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_IP_PROTOCOL_ADDR;
wire[ADDR_WIDTH-1:0]		EXEC_OF_IPV4_TOS_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_TCP_SRC_PORT_ADDR;
wire[ADDR_WIDTH-1:0]	EXEC_OF_TCP_DST_PORT_ADDR;
*/

wire[DPL_MATCH_FIELD_WIDTH-1:0] OF_MATCH_FIELD_DATA;
wire OF_FLOW_FOUND;


wire sdn_match_field_ready;
wire [DPL_PKT_BIT_WIDTH-1:0]pkt_header_data_buff;

wire[TCAM_SIZE-1:0]of_matched_addr_out;
wire[TCAM_ADDR_WIDTH-1:0]of_matched_decoded_addr_out;
wire of_match_found;
wire of_table_missed;

wire openflow_packet_found;
wire packet_to_switch_found;

wire[TCAM_SIZE-1:0]addr_to_tcam;
wire[TCAM_ADDR_WIDTH-1:0]addr_from_tcam;
wire of_flow_found_buff;
wire of_match_found_;

wire[TCAM_ADDR_WIDTH-1:0]exec_of_match_addr;
wire exec_of_match_found;

wire[ACTION_FLAG_WIDTH-1:0]exec_action_flag;
wire[ACTION_SET_WIDTH-1:0]exec_action_set;
wire exec_action_enable;

wire[DPL_PKT_BIT_WIDTH-1:0] pkt_header_out_classification_core;
wire[DPL_PKT_BIT_WIDTH-1:0] pkt_header_out_tcam_core;
wire[DPL_PKT_BIT_WIDTH-1:0] pkt_header_out_exec_fetch;

wire[METER_COUNTER_SIZE-1:0]meter_count;
wire meter_count_valid;
wire [TCAM_ADDR_WIDTH-1:0]meter_count_addr;

output[METER_COUNTER_SIZE-1:0]flow_count;
output flow_count_valid;
output [TCAM_ADDR_WIDTH-1:0]flow_count_addr;

assign flow_count=meter_count;
assign flow_count_valid=meter_count_valid;
assign flow_count_addr=meter_count_addr;

wire	 meter_read_en;
wire	[TCAM_ADDR_WIDTH-1:0]meter_read_addr;
wire  [METER_COUNTER_SIZE-1:0]meter_read_data;

wire 	[DPL_PKT_BIT_WIDTH-1:0]pkt_header_out_handler;//HANDLER
wire	 of_table_missed_en;//HANDLER
wire 	of_dpl_program_enable;
wire 	[DPL_MATCH_FIELD_WIDTH-1:0]of_dpl_program_data;
wire	[DPL_MATCH_FIELD_WIDTH-1:0]of_dpl_program_mask;
wire	[ACTION_FLAG_WIDTH-1:0]of_dpl_action_flag;
wire 	[ACTION_SET_WIDTH-1:0]of_dpl_action_set;
/////////////////////////////////////////////////////////////

wire glbl_program_en;//GLOBAL PROGRAM ENABLE
assign glbl_program_en=tcam_program_enable | exec_program_enable;

output [DPL_MATCH_FIELD_WIDTH-1:0]match_d;
output match_f;
output [TCAM_ADDR_WIDTH-1:0]tcam_addr;

assign match_d=OF_MATCH_FIELD_DATA;
assign match_f=OF_FLOW_FOUND;
assign tcam_addr=addr_from_tcam;

//ADDRESS OF DYNAMIC FIELD
wire [(ADDR_WIDTH*15)-1:0] pkt_addr;
wire [(ADDR_WIDTH*15)-1:0] pkt_addr_tcam;
wire [(ADDR_WIDTH*15)-1:0] pkt_addr_exec;

wire [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag;
wire [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out_tcam;
wire [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out_exec_fetch;
wire [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out_exec_engine;
wire [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out_handler;

assign of_flow_tag_out   =of_flow_tag_out_exec_engine;
assign of_flow_tag_out2  =of_flow_tag_out_handler;

output 	[DPL_PKT_BIT_WIDTH-1:0]handler_pkt_header;
output	 missed_pkt_en;
assign handler_pkt_header=pkt_header_out_handler;
assign missed_pkt_en=of_table_missed_en;


assign pkt_addr={OF_INGRESS_PORT_ADDR, OF_META_DATA_ADDR, OF_DST_MAC_ADDR_ADDR, OF_SRC_MAC_ADDR_ADDR , OF_ETHER_TYPE_ADDR,OF_VLAN_ID_ADDR,OF_VLAN_PRIORITY_ADDR,OF_MPLS_LABEL_ADDR,OF_MPLS_FEC_CLASS_ADDR,OF_SRC_IPV4_ADDR_ADDR,OF_DST_IPV4_ADDR_ADDR,OF_IP_PROTOCOL_ADDR,OF_IPV4_TOS_ADDR,OF_TCP_SRC_PORT_ADDR,	OF_TCP_DST_PORT_ADDR};

initial begin
	//$monitor("TIME: %g\n OF_MATCH_FIELD_DATA: %x \n OF_FLOW_FOUND: %x \n  OF_FLOW_TAG: %x \n OF_MATCH_FOUND:%b \n  OF_DECODED_ADDR: %x \n ACTION_FLAG: %x \n ACTION_SET: %x \n ACTION_ENABLE:%b %x\n%x\n%x\n\n\n\n",$time,OF_MATCH_FIELD_DATA,OF_FLOW_FOUND, of_flow_tag, of_match_found, of_matched_decoded_addr_out,exec_action_flag,exec_action_set,exec_action_enable,of_flow_tag_out_tcam,of_flow_tag_out_exec_fetch,of_flow_tag_out_exec_engine,);
end

//#(parameter ADDR_WIDTH=32,PKT_BUFF_ADDR_WIDTH=9,OF_FLOW_TAG_WIDTH=5,DPL_PKT_BYTE_WIDTH=64,DPL_PKT_BIT_WIDTH=512,DPL_MATCH_FIELD_WIDTH=356, DPL_PKT_ADDR_WIDTH=6, DPL_PKT_DATA_WIDTH=8)

netwalk_classification_engine 
	#(.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.PKT_BUFF_ADDR_WIDTH(PKT_BUFF_ADDR_WIDTH),.DPL_PKT_BYTE_WIDTH(DPL_PKT_BYTE_WIDTH),.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH),.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH), .DPL_PKT_ADDR_WIDTH(DPL_PKT_ADDR_WIDTH), .DPL_PKT_DATA_WIDTH(DPL_PKT_DATA_WIDTH))
	classification_engine(
		.clk(clk), 
		.reset(reset),
		.glbl_program_en(glbl_program_en),
		
		.pkt_header_ready(pkt_header_ready), 
		.pkt_header_accept(pkt_header_accept), 
		.pkt_header_in(pkt_header_in), 
		.pkt_header_data_buff(pkt_header_data_buff), 
	   .sdn_match_field_ready(sdn_match_field_ready), 
		
		.OF_INGRESS_PORT(OF_INGRESS_PORT),
		.OF_META_DATA(OF_META_DATA),
		.OF_DST_MAC_ADDR(OF_DST_MAC_ADDR),
		.OF_SRC_MAC_ADDR(OF_SRC_MAC_ADDR),		
		.OF_ETHER_TYPE(OF_ETHER_TYPE),
		.OF_VLAN_ID(OF_VLAN_ID),
		.OF_VLAN_PRIORITY(OF_VLAN_PRIORITY),
		.OF_MPLS_LABEL(OF_MPLS_LABEL),
		.OF_MPLS_FEC_CLASS(OF_MPLS_FEC_CLASS),
		.OF_SRC_IPV4_ADDR(OF_SRC_IPV4_ADDR),
		.OF_DST_IPV4_ADDR(OF_DST_IPV4_ADDR),
		.OF_IP_PROTOCOL(OF_IP_PROTOCOL),
		.OF_IPV4_TOS(OF_IPV4_TOS),
		.OF_TCP_SRC_PORT(OF_TCP_SRC_PORT),
		.OF_TCP_DST_PORT(OF_TCP_DST_PORT),
		
		.OF_MATCH_FIELD_DATA(OF_MATCH_FIELD_DATA),
		.OF_FLOW_FOUND(OF_FLOW_FOUND),
		.of_flow_tag(of_flow_tag),
		
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
		.OF_TCP_DST_PORT_ADDR(OF_TCP_DST_PORT_ADDR),
		.pkt_header_out(pkt_header_out_classification_core)
		
		
		
	);
	
	//#(parameter ADDR_WIDTH=32,DPL_PKT_BIT_WIDTH=512,TCAM_ADDR_WIDTH=6,DPL_MATCH_FIELD_WIDTH=356)
	netwalk_tcam_core 
#(.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH),.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
tcam_core
	(
		.clk(clk), 
		.reset(reset),
		.glbl_program_en(glbl_program_en),		
		.tcam_program_data(tcam_program_data), 
		.tcam_program_mask(tcam_program_mask), 
		.tcam_program_addr(tcam_program_addr), 
		.tcam_program_enable(tcam_program_enable), 
		.tcam_delete_enable(tcam_delete_enable), 		
		.pkt_header_in(pkt_header_out_classification_core),		
		.of_match_field_data(OF_MATCH_FIELD_DATA), 		
		.of_flow_found(OF_FLOW_FOUND), 
		.of_matched_addr_out(of_matched_addr_out), 
		.of_matched_decoded_addr_out(of_matched_decoded_addr_out),
		.of_match_found(of_match_found),
		.of_table_missed(of_table_missed),
		.openflow_packet_found(openflow_packet_found),
		.packet_to_switch_found(packet_to_switch_found),
		.pkt_header_out(pkt_header_out_tcam_core),		
		.of_flow_found_buff(of_flow_found_buff),
		.of_match_found_(of_match_found_),
		.addr_to_tcam(addr_to_tcam),
		.addr_from_tcam(addr_from_tcam),
		
		.pkt_addr_in(pkt_addr),
		.pkt_addr_out(pkt_addr_tcam),
		
		.of_flow_tag_in(of_flow_tag),
		.of_flow_tag_out(of_flow_tag_out_tcam)
			
		
	);
	
	netwalk_packet_handler 
	#(.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH),.ACTION_FLAG_WIDTH(ACTION_FLAG_WIDTH),.ACTION_SET_WIDTH(ACTION_SET_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH),.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH))
	handler(
		.clk(clk), 
		.reset(reset), 
		.glbl_program_en(glbl_program_en), 
		.pkt_header_in(pkt_header_out_tcam_core), 
		.of_table_missed(of_table_missed), 
		.openflow_packet_found(openflow_packet_found), 
		.packet_to_switch_found(packet_to_switch_found), 
		.of_dpl_program_enable(of_dpl_program_enable), 
		.of_dpl_program_data(of_dpl_program_data), 
		.of_dpl_program_mask(of_dpl_program_mask), 
		.of_dpl_action_flag(of_dpl_action_flag),
		.of_dpl_action_set(of_dpl_action_set),
		.pkt_header_out(pkt_header_out_handler), 
		.of_table_missed_en(of_table_missed_en), 
		.pkt_addr_in(pkt_addr_tcam), 
		
		.of_flow_tag_in(of_flow_tag_out_tcam),
        .of_flow_tag_out(of_flow_tag_out_handler)
		//.pkt_addr_out(pkt_addr_out)
	);
	//#(parameter DPL_PKT_BIT_WIDTH=512,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6)
		netwalk_flow_meter 
		#(.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.ACTION_FLAG_WIDTH(ACTION_FLAG_WIDTH),.ACTION_SET_WIDTH(ACTION_SET_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
		flow_meter
		(
		.clk(clk), 
		.reset(reset), 
		.glbl_program_en(glbl_program_en), 
		.meter_program_addr(tcam_program_addr), 
		.meter_program_enable(tcam_program_enable), 
		.meter_delete_enable(tcam_delete_enable), 
		.meter_of_match_addr(of_matched_decoded_addr_out), 
		.meter_of_match_found(of_match_found), 
		.meter_count(meter_count), 
		.meter_count_valid(meter_count_valid), 
		.meter_read_en(meter_read_en), 
		.meter_read_addr(meter_read_addr), 
		.meter_read_data(meter_read_data),
		.meter_count_addr(meter_count_addr)
	);

	//#(parameter ADDR_WIDTH=32,DPL_PKT_BIT_WIDTH=512,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6)
		netwalk_execution_engine_action_fetch_unit
	#(.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH),.ACTION_FLAG_WIDTH(ACTION_FLAG_WIDTH),.ACTION_SET_WIDTH(ACTION_SET_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
	exec_engine_front (
		.clk(clk), 
		.reset(reset), 
		.glbl_program_en(glbl_program_en),
		.exec_program_data(exec_program_data), 
		.exec_program_addr(exec_program_addr), 
		.exec_program_enable(exec_program_enable), 
		.exec_delete_enable(exec_delete_enable), 
		.pkt_header_in(pkt_header_out_tcam_core),
		.exec_of_match_addr(of_matched_decoded_addr_out), 
		.exec_of_match_found(of_match_found), 		
		.exec_action_flag(exec_action_flag), 
		.exec_action_set(exec_action_set), 
		.exec_action_enable(exec_action_enable),		
		.pkt_header_out(pkt_header_out_exec_fetch),
		
		.pkt_addr_in(pkt_addr_tcam),
		.pkt_addr_out(pkt_addr_exec),
		
		.of_flow_tag_in(of_flow_tag_out_tcam),
        .of_flow_tag_out(of_flow_tag_out_exec_fetch)	
	);
	
	//#(parameter ADDR_WIDTH=32,PKT_BUFF_ADDR_WIDTH=9,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6,DPL_PKT_BIT_WIDTH=512)
		netwalk_execution_engine_core
#(.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.PKT_BUFF_ADDR_WIDTH(PKT_BUFF_ADDR_WIDTH),.ACTION_FLAG_WIDTH(ACTION_FLAG_WIDTH),.ACTION_SET_WIDTH(ACTION_SET_WIDTH),.TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH),.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH))
		execution_engine_core(
		.clk(clk), 
		.reset(reset), 
		.glbl_program_en(glbl_program_en),
		.pkt_header_in(pkt_header_out_exec_fetch), 
		.exec_action_flag(exec_action_flag), 
		.exec_action_set(exec_action_set), 
		.exec_action_enable(exec_action_enable), 
		.pkt_header_out(pkt_header_out), 
		.packet_out_enable(pkt_out_enable), 
		/*
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
		.OF_TCP_DST_PORT_ADDR(OF_TCP_DST_PORT_ADDR),
		*/
		.pkt_addr_in(pkt_addr_exec),
		
		.of_flow_tag_in(of_flow_tag_out_exec_fetch),
        .of_flow_tag_out(of_flow_tag_out_exec_engine)
	);
	
	
	
	
endmodule
