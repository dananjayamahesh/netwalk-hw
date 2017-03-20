`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:20:59 01/07/2016
// Design Name:   netwalk_classification_engine
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/netwalk_classification_engine_tb.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_classification_engine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module netwalk_classification_engine_tb;

parameter PKT_BUFF_ADDR_WIDTH=9,OF_FLOW_TAG_WIDTH=5,DPL_PKT_BYTE_WIDTH=64,DPL_PKT_BIT_WIDTH=512,DPL_MATCH_FIELD_WIDTH=356, DPL_PKT_ADDR_WIDTH=6, DPL_PKT_DATA_WIDTH=8;


parameter INGRESS_PORT_WIDTH		=32;
parameter METADATA_WIDTH			=64;

parameter IP_ENCAP_WIDTH			=160;
parameter ETHER_ENCAP_WIDTH		=112;
parameter UDP_ENCAP_WIDTH			=64;
parameter TCP_ENCAP_WIDTH			=160;
parameter VLAN_ENCAP_WIDTH			=32;
parameter MPLS_ENCAP_WIDTH			=32;
parameter MAC_ADDR_WIDTH			=48;
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
parameter IP_SRC_ADDR_WIDTH				=32;
parameter IP_DST_ADDR_WIDTH				=32;

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

parameter UDP_PORT_LENGTH			=16;
parameter UDP_SRC_PORT_LENGTH			=16;
parameter UDP_DST_PORT_LENGTH			=16;
parameter UDP_LENGTH_WIDTH			=16;
parameter UDP_CHECKSUM_LENGTH		=16;

//parameter DPL_MATCH_FIELD_WIDTH	=356;

//parameter PKT_BUFF_ADDR_WIDTH=9;

	// Inputs
	reg clk;
	reg reset;
	reg pkt_header_ready;
	reg pkt_header_finish;
	reg [511:0] pkt_header_in;
	wire [511:0] pkt_header_out;
	/*reg pkt_header_finish_accept;
	
	reg [7:0] pkt_header_data;

	// Outputs
		wire sdn_match_field_ready;
	wire pkt_header_accept;
	wire pkt_header_ready_accept;
	wire [511:0] pkt_header_data_buff;
	wire [5:0] pkt_header_addr;
	wire pkt_header_read_enable;
	wire [355:0] sdn_match_field_data;

	wire sdn_match_field_accept;
	
wire [INGRESS_PORT_WIDTH-1:0]	sdn_ingress_port;
wire [METADATA_WIDTH-1:0]		sdn_meta_data;
wire [SRC_MAC_ADDR_WIDTH-1:0]	sdn_src_mac_addr;
wire [DST_MAC_ADDR_WIDTH-1:0]	sdn_dst_mac_addr;
wire [ETHER_TYPE_WIDTH-1:0]		sdn_ether_type;
wire [VLAN_ID_WIDTH-1:0]			sdn_vlan_id;
wire [VLAN_PRIORITY_WIDTH-1:0]	sdn_vlan_priority;
wire [MPLS_LABEL_WIDTH-1:0]		sdn_mpls_label;
wire [MPLS_FEC_WIDTH-1:0]		sdn_mpls_fec_class;
wire [IP_SRC_ADDR_WIDTH-1:0]	sdn_src_ipv4_addr;
wire [IP_DST_ADDR_WIDTH-1:0]	sdn_dst_ipv4_addr;
wire [IP_PROTOCOL_WIDTH-1:0]	sdn_ipv4_protocol;
wire [IP_TOS_WIDTH-1:0]			sdn_ipv4_tos;
wire [TCP_SRC_PORT_WIDTH-1:0]	sdn_tcp_src_port;
wire [TCP_DST_PORT_WIDTH-1:0]	sdn_tcp_dst_port;
*/

wire[INGRESS_PORT_WIDTH-1:0]	OF_INGRESS_PORT;
wire[METADATA_WIDTH-1:0]		OF_META_DATA;
wire[SRC_MAC_ADDR_WIDTH-1:0]	OF_SRC_MAC_ADDR;
wire[DST_MAC_ADDR_WIDTH-1:0]	OF_DST_MAC_ADDR;
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

wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_INGRESS_PORT_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]OF_META_DATA_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_DST_MAC_ADDR_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_SRC_MAC_ADDR_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0] OF_ETHER_TYPE_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]			OF_VLAN_ID_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_VLAN_PRIORITY_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_MPLS_LABEL_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]		OF_MPLS_FEC_CLASS_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]OF_SRC_IPV4_ADDR_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]OF_DST_IPV4_ADDR_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_IP_PROTOCOL_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]		OF_IPV4_TOS_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_TCP_SRC_PORT_ADDR;
wire[PKT_BUFF_ADDR_WIDTH-1:0]	OF_TCP_DST_PORT_ADDR;

wire [DPL_MATCH_FIELD_WIDTH-1:0] OF_MATCH_FIELD_DATA;
wire OF_FLOW_FOUND;
wire [4:0] of_flow_tag;
	
	integer read_file;
	integer read_data;
	
	integer output_file;
	integer output_data;
	
	// Instantiate the Unit Under Test (UUT)
	netwalk_classification_engine 
	#(.PKT_BUFF_ADDR_WIDTH(PKT_BUFF_ADDR_WIDTH),.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.DPL_PKT_BYTE_WIDTH(DPL_PKT_BYTE_WIDTH),.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH),.DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH), .DPL_PKT_ADDR_WIDTH(DPL_PKT_ADDR_WIDTH), .DPL_PKT_DATA_WIDTH(DPL_PKT_DATA_WIDTH))
	classification_engine(
		.clk(clk), 
		.reset(reset), 
		.pkt_header_ready(pkt_header_ready), 
		.pkt_header_accept(pkt_header_accept), 
		.pkt_header_in(pkt_header_in), 
		.pkt_header_data_buff(pkt_header_data_buff), 
	   .sdn_match_field_ready(sdn_match_field_ready), 
		.OF_INGRESS_PORT(OF_INGRESS_PORT),
		.OF_META_DATA(OF_META_DATA),
		.OF_SRC_MAC_ADDR(OF_SRC_MAC_ADDR),
		.OF_DST_MAC_ADDR(OF_DST_MAC_ADDR),
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
		.pkt_header_out(pkt_header_out)
		
	);

	initial begin
	
	read_file =		$fopen("input/pkt_header.txt","r");	
	output_file =		$fopen("output/output.txt","w+");
	
		// Initialize Inputs
		clk = 0;
		reset = 0;
		pkt_header_ready = 0;
		//pkt_header_finish = 0;
		//pkt_header_finish_accept = 0;
		pkt_header_in = 0;
		//pkt_header_data = 0;

		// Wait 100 ns for global reset to finish
		#35;
		pkt_header_ready = 1;		
		read_data = $fscanf(read_file, "%x", pkt_header_in);
		#10;
		pkt_header_ready = 1;
		read_data = $fscanf(read_file, "%x", pkt_header_in);
		#10;
		read_data = $fscanf(read_file, "%x", pkt_header_in);
		pkt_header_ready = 1;
		#10;
		read_data = $fscanf(read_file, "%x", pkt_header_in);
		pkt_header_ready = 1;		
		#40;		
		#100;
		$fclose(output_file);
		// Add stimulus here
	end
	
	always begin
	#5 clk=~clk;
	end
	 integer i;
	 initial begin
	 i=0;
	 end
	 
	always@(posedge clk)begin
	if(pkt_header_ready==1'b1)begin
	   if(i<1)begin
		  i=i+1;
		end
		else begin
		  i=0;
		  pkt_header_ready=0;
		end
	end
	
	end
	
	always@(OF_MATCH_FIELD_DATA)begin
	
	$fdisplay(output_file,"%x\n%b",OF_MATCH_FIELD_DATA,OF_FLOW_FOUND);
	end
	
      
endmodule

