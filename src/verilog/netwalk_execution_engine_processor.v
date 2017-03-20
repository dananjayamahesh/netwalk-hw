`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:21:16 01/12/2016 
// Design Name: 
// Module Name:    netwalk_execution_engine_processor 
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
module netwalk_execution_engine_core
#(parameter OF_FLOW_TAG_WIDTH=5,ADDR_WIDTH=32,PKT_BUFF_ADDR_WIDTH=9,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6,DPL_PKT_BIT_WIDTH=512)
(
clk,
reset,
glbl_program_en,

pkt_header_in,

exec_action_flag,
exec_action_set,
exec_action_enable,

pkt_header_out,
packet_out_enable,

/*
OF_INGRESS_PORT_ADDR,
OF_META_DATA_ADDR,
OF_DST_MAC_ADDR_ADDR,
OF_SRC_MAC_ADDR_ADDR,
OF_ETHER_TYPE_ADDR,
OF_VLAN_ID_ADDR,
OF_VLAN_PRIORITY_ADDR,
OF_MPLS_LABEL_ADDR,
OF_MPLS_FEC_CLASS_ADDR,
OF_SRC_IPV4_ADDR_ADDR,
OF_DST_IPV4_ADDR_ADDR,
OF_IP_PROTOCOL_ADDR,
OF_IPV4_TOS_ADDR,
OF_TCP_SRC_PORT_ADDR,
OF_TCP_DST_PORT_ADDR,
*/

pkt_addr_in,
//pkt_addr_out
of_flow_tag_in,
of_flow_tag_out
);
input [(ADDR_WIDTH*15)-1:0] pkt_addr_in;
input [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_in;
output reg [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out;

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

parameter SRC_IPV4_ADDR_WIDTH		=32;
parameter DST_IPV4_ADDR_WIDTH		=32;
parameter IPV4_TOS_WIDTH			=IP_DSCP_WIDTH;

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

parameter TCP_SRC_PORT_ADDR		=16;
parameter TCP_DST_PORT_ADDR		=16;
/////////////////////////////////////////////////////
parameter UDP_PORT_WIDTH			=16;
parameter UDP_SRC_PORT_WIDTH		=16;
parameter UDP_DST_PORT_WIDTH		=16;
parameter UDP_LENGTH_WIDTH			=16;
parameter UDP_CHECKSUM_WIDTH		=16;

parameter EGRESS_PORT_OFFSET		=0;
parameter METADATA_OFFSET			=EGRESS_PORT_WIDTH;
parameter DST_MAC_ADDR_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH;
parameter SRC_MAC_ADDR_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+DST_MAC_ADDR_WIDTH;
parameter ETHER_TYPE_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH;
parameter VLAN_ID_OFFSET			=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH;
parameter VLAN_PRIORITY_OFFSET	=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH;
parameter MPLS_LABEL_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH;
parameter MPLS_FEC_CLASS_OFFSET	=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH;
parameter SRC_IPV4_ADDR_OFFSET	=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH;
parameter DST_IPV4_ADDR_OFFSET	=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH;
parameter IP_PROTOCOL_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH+IP_DST_ADDR_WIDTH;
parameter IPV4_TOS_OFFSET			=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH+IP_DST_ADDR_WIDTH+IP_PROTOCOL_WIDTH;
parameter TCP_SRC_PORT_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH+IP_DST_ADDR_WIDTH+IP_PROTOCOL_WIDTH+IP_TOS_WIDTH;
parameter TCP_DST_PORT_OFFSET		=EGRESS_PORT_WIDTH+METADATA_WIDTH+SRC_MAC_ADDR_WIDTH+DST_MAC_ADDR_WIDTH+ETHER_TYPE_WIDTH+VLAN_ID_WIDTH+VLAN_PRIORITY_WIDTH+MPLS_LABEL_WIDTH+MPLS_FEC_CLASS_WIDTH+IP_SRC_ADDR_WIDTH+IP_DST_ADDR_WIDTH+IP_PROTOCOL_WIDTH+IP_TOS_WIDTH+TCP_SRC_PORT_WIDTH;

input clk;
input reset;
input glbl_program_en;

input[DPL_PKT_BIT_WIDTH-1:0]pkt_header_in;

input[ACTION_FLAG_WIDTH-1:0]exec_action_flag;
input[ACTION_SET_WIDTH-1:0]exec_action_set;
input exec_action_enable;

output reg[DPL_PKT_BIT_WIDTH-1:0]pkt_header_out;
output reg packet_out_enable;

/*
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_INGRESS_PORT_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_META_DATA_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_DST_MAC_ADDR_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_SRC_MAC_ADDR_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0] 		OF_ETHER_TYPE_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_VLAN_ID_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_VLAN_PRIORITY_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_MPLS_LABEL_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_MPLS_FEC_CLASS_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_SRC_IPV4_ADDR_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_DST_IPV4_ADDR_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_IP_PROTOCOL_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_IPV4_TOS_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_TCP_SRC_PORT_ADDR;
input[PKT_BUFF_ADDR_WIDTH-1:0]		OF_TCP_DST_PORT_ADDR;
*/

wire[EGRESS_PORT_WIDTH-1:0]	SET_EGRESS_PORT;
wire[METADATA_WIDTH-1:0]		SET_META_DATA;
wire[DST_MAC_ADDR_WIDTH-1:0]	SET_DST_MAC_ADDR;
wire[SRC_MAC_ADDR_WIDTH-1:0]	SET_SRC_MAC_ADDR;
wire[ETHER_TYPE_WIDTH-1:0]		SET_ETHER_TYPE;
wire[VLAN_ID_WIDTH-1:0]			SET_VLAN_ID;
wire[VLAN_PRIORITY_WIDTH-1:0]	SET_VLAN_PRIORITY;
wire[MPLS_LABEL_WIDTH-1:0]		SET_MPLS_LABEL;
wire[MPLS_FEC_WIDTH-1:0]		SET_MPLS_FEC_CLASS;
wire[IP_SRC_ADDR_WIDTH-1:0]	SET_SRC_IPV4_ADDR;
wire[IP_DST_ADDR_WIDTH-1:0]	SET_DST_IPV4_ADDR;
wire[IP_PROTOCOL_WIDTH-1:0]	SET_IP_PROTOCOL;
wire[IP_TOS_WIDTH-1:0]			SET_IPV4_TOS;
wire[TCP_SRC_PORT_WIDTH-1:0]	SET_TCP_SRC_PORT;
wire[TCP_DST_PORT_WIDTH-1:0]	SET_TCP_DST_PORT;


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
output[INGRESS_PORT_WIDTH-1:0]	SET_EGRESS_PORT;
output[METADATA_WIDTH-1:0]		SET_META_DATA;
output[SRC_MAC_ADDR_WIDTH-1:0]	SET_SRC_MAC_ADDR;
output[DST_MAC_ADDR_WIDTH-1:0]	SET_DST_MAC_ADDR;
output[ETHER_TYPE_WIDTH-1:0]		SET_ETHER_TYPE;
output[VLAN_ID_WIDTH-1:0]			SET_VLAN_ID;
output[VLAN_PRIORITY_WIDTH-1:0]	SET_VLAN_PRIORITY;
output[MPLS_LABEL_WIDTH-1:0]		SET_MPLS_LABEL;
output[MPLS_FEC_WIDTH-1:0]		SET_MPLS_FEC_CLASS;
output[IP_SRC_ADDR_WIDTH-1:0]	SET_SRC_IPV4_ADDR;
output[IP_DST_ADDR_WIDTH-1:0]	SET_DST_IPV4_ADDR;
output[IP_PROTOCOL_WIDTH-1:0]	SET_IP_PROTOCOL;
output[IP_TOS_WIDTH-1:0]			SET_IPV4_TOS;
output[TCP_SRC_PORT_WIDTH-1:0]	SET_TCP_SRC_PORT;
output[TCP_DST_PORT_WIDTH-1:0]	SET_TCP_DST_PORT;
*/

assign SET_EGRESS_PORT		=exec_action_set[ACTION_SET_WIDTH-1:(ACTION_SET_WIDTH-METADATA_OFFSET)];
assign SET_META_DATA			=exec_action_set[ACTION_SET_WIDTH-METADATA_OFFSET-1:ACTION_SET_WIDTH-SRC_MAC_ADDR_OFFSET];
assign SET_DST_MAC_ADDR		=exec_action_set[ACTION_SET_WIDTH-DST_MAC_ADDR_OFFSET-1:ACTION_SET_WIDTH-SRC_MAC_ADDR_OFFSET];
assign SET_SRC_MAC_ADDR		=exec_action_set[ACTION_SET_WIDTH-SRC_MAC_ADDR_OFFSET-1:ACTION_SET_WIDTH-ETHER_TYPE_OFFSET];
assign SET_ETHER_TYPE		=exec_action_set[ACTION_SET_WIDTH-ETHER_TYPE_OFFSET-1:ACTION_SET_WIDTH-VLAN_ID_OFFSET];
assign SET_VLAN_ID			=exec_action_set[ACTION_SET_WIDTH-VLAN_ID_OFFSET-1:ACTION_SET_WIDTH-VLAN_PRIORITY_OFFSET];
assign SET_VLAN_PRIORITY	=exec_action_set[ACTION_SET_WIDTH-VLAN_PRIORITY_OFFSET-1:ACTION_SET_WIDTH-MPLS_LABEL_OFFSET];
assign SET_MPLS_LABEL		=exec_action_set[ACTION_SET_WIDTH-MPLS_LABEL_OFFSET-1:ACTION_SET_WIDTH-MPLS_FEC_CLASS_OFFSET];
assign SET_MPLS_FEC_CLASS	=exec_action_set[ACTION_SET_WIDTH-MPLS_FEC_CLASS_OFFSET-1:ACTION_SET_WIDTH-SRC_IPV4_ADDR_OFFSET];
assign SET_SRC_IPV4_ADDR	=exec_action_set[ACTION_SET_WIDTH-SRC_IPV4_ADDR_OFFSET-1:ACTION_SET_WIDTH-DST_IPV4_ADDR_OFFSET];
assign SET_DST_IPV4_ADDR	=exec_action_set[ACTION_SET_WIDTH-DST_IPV4_ADDR_OFFSET-1:ACTION_SET_WIDTH-IP_PROTOCOL_OFFSET];
assign SET_IP_PROTOCOL		=exec_action_set[ACTION_SET_WIDTH-IP_PROTOCOL_OFFSET-1:ACTION_SET_WIDTH-IPV4_TOS_OFFSET];
assign SET_IPV4_TOS			=exec_action_set[ACTION_SET_WIDTH-IPV4_TOS_OFFSET-1:ACTION_SET_WIDTH-TCP_SRC_PORT_OFFSET];
assign SET_TCP_SRC_PORT		=exec_action_set[ACTION_SET_WIDTH-TCP_SRC_PORT_OFFSET-1:ACTION_SET_WIDTH-TCP_DST_PORT_OFFSET];
assign SET_TCP_DST_PORT		=exec_action_set[ACTION_SET_WIDTH-TCP_DST_PORT_OFFSET-1:0];

assign {OF_INGRESS_PORT_ADDR, OF_META_DATA_ADDR, OF_DST_MAC_ADDR_ADDR, OF_SRC_MAC_ADDR_ADDR , OF_ETHER_TYPE_ADDR,OF_VLAN_ID_ADDR,OF_VLAN_PRIORITY_ADDR,OF_MPLS_LABEL_ADDR,OF_MPLS_FEC_CLASS_ADDR,OF_SRC_IPV4_ADDR_ADDR,OF_DST_IPV4_ADDR_ADDR,OF_IP_PROTOCOL_ADDR,OF_IPV4_TOS_ADDR,OF_TCP_SRC_PORT_ADDR,	OF_TCP_DST_PORT_ADDR}=pkt_addr_in;

initial begin
//$monitor("%x \n%x \n %x \n %x \n %x \n %x \n %x \n %x \n %x \n %x \n %x \n %x \n %x \n\n",SET_EGRESS_PORT,SET_META_DATA,SET_SRC_MAC_ADDR,SET_DST_MAC_ADDR,SET_ETHER_TYPE,SET_VLAN_ID,SET_VLAN_PRIORITY,SET_MPLS_LABEL,SET_MPLS_FEC_CLASS,SET_SRC_IPV4_ADDR,SET_DST_IPV4_ADDR,SET_IP_PROTOCOL,SET_IPV4_TOS,SET_TCP_SRC_PORT,SET_TCP_DST_PORT);
end
always@(posedge clk)begin
		if(!reset)begin
		   if(!glbl_program_en)begin
            if(exec_action_enable)begin
				       of_flow_tag_out<=of_flow_tag_in;
				       
						if(exec_action_flag[15] == 1'b1)begin//TCP_DST_PORT
							   packet_out_enable<=1'b0;
						end	
						else begin
					       packet_out_enable<=1'b1;
					   end
					
				    if(exec_action_flag[0] == 1'b1)begin//EGRESS PORT
							//packet_out_enable<=1'b1;
							pkt_header_out[OF_INGRESS_PORT_ADDR -:EGRESS_PORT_WIDTH] <= SET_EGRESS_PORT;
							//pkt_header_out[DPL_PKT_BIT_WIDTH-1:DPL_PKT_BIT_WIDTH-EGRESS_PORT_WIDTH] <= SET_EGRESS_PORT;
							//pkt_header_out[DPL_PKT_BIT_WIDTH-EGRESS_PORT_WIDTH-1:0] <= pkt_header_in[DPL_PKT_BIT_WIDTH-EGRESS_PORT_WIDTH-1:0];
					  end	
					  else begin
					      pkt_header_out[OF_INGRESS_PORT_ADDR -:EGRESS_PORT_WIDTH] <= pkt_header_in[OF_INGRESS_PORT_ADDR -:EGRESS_PORT_WIDTH];
					       //packet_out_enable<=1'b0;
							 //pkt_header_out[DPL_PKT_BIT_WIDTH-1:0] <= pkt_header_in[DPL_PKT_BIT_WIDTH-1:0];
					  end	
					  
					  
						if(exec_action_flag[1] == 1'b1)begin//METADATA
							pkt_header_out[OF_META_DATA_ADDR -:METADATA_WIDTH] <= SET_META_DATA;
						end	
						else begin
					     pkt_header_out[OF_META_DATA_ADDR -:METADATA_WIDTH]  <= pkt_header_in[OF_META_DATA_ADDR -:METADATA_WIDTH] ;
					   end


						if(exec_action_flag[2] == 1'b1)begin//DST_MAC
							pkt_header_out[OF_SRC_MAC_ADDR_ADDR -:DST_MAC_ADDR_WIDTH] <= SET_DST_MAC_ADDR;
						end	
						else begin
					      pkt_header_out[OF_DST_MAC_ADDR_ADDR -:DST_MAC_ADDR_WIDTH] <= pkt_header_in[OF_DST_MAC_ADDR_ADDR -:DST_MAC_ADDR_WIDTH] ;
					   end
						
						if(exec_action_flag[3] == 1'b1)begin//SRC_MAC
							pkt_header_out[OF_SRC_MAC_ADDR_ADDR -:SRC_MAC_ADDR_WIDTH] <= SET_SRC_MAC_ADDR;
						end	
						else begin
					      pkt_header_out[OF_SRC_MAC_ADDR_ADDR -:SRC_MAC_ADDR_WIDTH] <= pkt_header_in[OF_SRC_MAC_ADDR_ADDR -:SRC_MAC_ADDR_WIDTH] ;
					   end
						
						
						if(exec_action_flag[4] == 1'b1)begin//ETHER_TYPE
							pkt_header_out[OF_ETHER_TYPE_ADDR -:ETHER_TYPE_WIDTH] <= SET_ETHER_TYPE;
						end	
						else begin
					      pkt_header_out[OF_ETHER_TYPE_ADDR -:ETHER_TYPE_WIDTH] <= pkt_header_in[OF_ETHER_TYPE_ADDR -:ETHER_TYPE_WIDTH] ;
					   end
						
						if(exec_action_flag[5] == 1'b1)begin//VLAN_ID
							pkt_header_out[OF_VLAN_ID_ADDR -:VLAN_ID_WIDTH] <= SET_VLAN_ID;
						end	
						else begin
					      pkt_header_out[OF_VLAN_ID_ADDR -:VLAN_ID_WIDTH] <= pkt_header_in[OF_VLAN_ID_ADDR -:VLAN_ID_WIDTH] ;
					   end
						
						if(exec_action_flag[6] == 1'b1)begin//VLAN_PRIORITY
							pkt_header_out[OF_VLAN_PRIORITY_ADDR -:VLAN_PRIORITY_WIDTH] <= SET_VLAN_PRIORITY;
						end	
						else begin
					      pkt_header_out[OF_VLAN_PRIORITY_ADDR -:VLAN_PRIORITY_WIDTH] <= pkt_header_in[OF_VLAN_PRIORITY_ADDR -:VLAN_PRIORITY_WIDTH] ;
					   end
						
						if(exec_action_flag[7] == 1'b1)begin//MPLS_LABEL
							pkt_header_out[OF_MPLS_LABEL_ADDR -:MPLS_LABEL_WIDTH] <= SET_MPLS_LABEL;
						end	
						else begin
					      pkt_header_out[OF_MPLS_LABEL_ADDR -:MPLS_LABEL_WIDTH] <= pkt_header_in[OF_MPLS_LABEL_ADDR -:MPLS_LABEL_WIDTH];
					   end
					  
					  if(exec_action_flag[8] == 1'b1)begin//MPLS_FEC_CLASS
							pkt_header_out[OF_MPLS_FEC_CLASS_ADDR -:MPLS_FEC_CLASS_WIDTH] <= SET_MPLS_FEC_CLASS;
						end	
						else begin
					      pkt_header_out[OF_MPLS_FEC_CLASS_ADDR -:MPLS_FEC_CLASS_WIDTH] <= pkt_header_in[OF_MPLS_FEC_CLASS_ADDR -:MPLS_FEC_CLASS_WIDTH];
					   end						
						
						
						if(exec_action_flag[9] == 1'b1)begin//SRC_IPV4_ADDR
							pkt_header_out[OF_SRC_IPV4_ADDR_ADDR -:SRC_IPV4_ADDR_WIDTH] <= SET_SRC_IPV4_ADDR;
						end	
						else begin
					      pkt_header_out[OF_SRC_IPV4_ADDR_ADDR -:SRC_IPV4_ADDR_WIDTH] <= pkt_header_in[OF_SRC_IPV4_ADDR_ADDR -:SRC_IPV4_ADDR_WIDTH];
					   end
						
						
						if(exec_action_flag[10] == 1'b1)begin//DST_IPV4_ADDR
							pkt_header_out[OF_DST_IPV4_ADDR_ADDR -:DST_IPV4_ADDR_WIDTH] <= SET_DST_IPV4_ADDR;
						end	
						else begin
					      pkt_header_out[OF_DST_IPV4_ADDR_ADDR -:DST_IPV4_ADDR_WIDTH] <= pkt_header_in[OF_DST_IPV4_ADDR_ADDR -:DST_IPV4_ADDR_WIDTH];
					   end
						
						
						if(exec_action_flag[11] == 1'b1)begin//IP_PROTOCOL
							pkt_header_out[OF_IP_PROTOCOL_ADDR -:IP_PROTOCOL_WIDTH] <= SET_IP_PROTOCOL;
						end	
						else begin
					      pkt_header_out[OF_IP_PROTOCOL_ADDR -:IP_PROTOCOL_WIDTH] <= pkt_header_in[OF_IP_PROTOCOL_ADDR -:IP_PROTOCOL_WIDTH];
					   end
						
						if(exec_action_flag[12] == 1'b1)begin//IPV4_TOS
							pkt_header_out[OF_IPV4_TOS_ADDR -:IPV4_TOS_WIDTH] <= SET_IPV4_TOS;
						end	
						else begin
					      pkt_header_out[OF_IPV4_TOS_ADDR -:IPV4_TOS_WIDTH] <= pkt_header_in[OF_IPV4_TOS_ADDR -:IPV4_TOS_WIDTH];
					   end
						
						
						if(exec_action_flag[13] == 1'b1)begin//TCP_SRC_PORT
							pkt_header_out[OF_TCP_SRC_PORT_ADDR -:TCP_SRC_PORT_WIDTH] <= SET_TCP_SRC_PORT;
						end	
						else begin
					      pkt_header_out[OF_TCP_SRC_PORT_ADDR -:TCP_SRC_PORT_WIDTH] <= pkt_header_in[OF_TCP_SRC_PORT_ADDR -:TCP_SRC_PORT_WIDTH];
					   end
						
						
						if(exec_action_flag[14] == 1'b1)begin//TCP_DST_PORT
							pkt_header_out[OF_TCP_DST_PORT_ADDR -:TCP_DST_PORT_WIDTH] <= SET_TCP_DST_PORT;
						end	
						else begin
					      pkt_header_out[OF_TCP_DST_PORT_ADDR -:TCP_DST_PORT_WIDTH] <= pkt_header_in[OF_TCP_DST_PORT_ADDR -:TCP_DST_PORT_WIDTH];
					   end
						
					

				end //EXEC_ACTION_ENABLE
				else begin
				      packet_out_enable<=1'b0;
						pkt_header_out<=0;
						of_flow_tag_out<=0;
				end//EXEC
			end//PROG	
		end
		else begin
		            packet_out_enable<=1'b0;
						pkt_header_out<=0;
							of_flow_tag_out<=0;
		end//RESET
end

endmodule
