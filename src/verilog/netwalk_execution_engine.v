`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:41 01/12/2016 
// Design Name: 
// Module Name:    netwalk_execution_engine 
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
module netwalk_execution_engine_action_fetch_unit
#(parameter OF_FLOW_TAG_WIDTH=5,ADDR_WIDTH=32,DPL_PKT_BIT_WIDTH=512,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6)
(
clk,
reset,
glbl_program_en,

exec_program_data,
exec_program_addr,
exec_program_enable,
exec_delete_enable,

pkt_header_in,

exec_of_match_addr,
exec_of_match_found,

exec_action_flag,
exec_action_set,
exec_action_enable,

pkt_header_out,

pkt_addr_in,
pkt_addr_out,

of_flow_tag_in,
of_flow_tag_out

);
	input [(ADDR_WIDTH*15)-1:0] pkt_addr_in;
output reg [(ADDR_WIDTH*15)-1:0] pkt_addr_out;
input [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_in;
output reg [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out;
 
parameter ACTION_MEM_SIZE=1<<TCAM_ADDR_WIDTH;	 
parameter PROGRAM_DATA_WIDTH=ACTION_FLAG_WIDTH+ACTION_SET_WIDTH;
parameter PROGRAM_ADDR_WIDTH=TCAM_ADDR_WIDTH;
parameter  ACTION_MEM_ADDR_WIDTH=TCAM_ADDR_WIDTH;

input clk;
input reset;
input glbl_program_en;

input [PROGRAM_DATA_WIDTH-1:0]exec_program_data;
input [PROGRAM_ADDR_WIDTH-1:0]exec_program_addr;
input exec_program_enable;
input exec_delete_enable;

input [TCAM_ADDR_WIDTH-1:0]exec_of_match_addr;
input exec_of_match_found;

output reg[ACTION_FLAG_WIDTH-1:0]exec_action_flag;
output reg[ACTION_SET_WIDTH-1:0]exec_action_set;
output reg exec_action_enable;

input [DPL_PKT_BIT_WIDTH-1:0] pkt_header_in;
output reg[DPL_PKT_BIT_WIDTH-1:0] pkt_header_out;

reg [ACTION_FLAG_WIDTH-1:0] action_flag_mem[0:ACTION_MEM_SIZE-1];
reg [ACTION_SET_WIDTH-1:0]  action_set_mem[0:ACTION_MEM_SIZE-1];

wire [ACTION_FLAG_WIDTH-1:0] exec_program_action_flag;
wire [ACTION_SET_WIDTH-1:0]  exec_program_action_set;

assign exec_program_action_flag=exec_program_data[PROGRAM_DATA_WIDTH-1:PROGRAM_DATA_WIDTH-ACTION_FLAG_WIDTH];
assign exec_program_action_set =exec_program_data[ACTION_SET_WIDTH-1:0];
integer i;

initial begin
//$display("ACTION FLAG: %b \nACTION_SET:%x");
end
always@(posedge clk)begin
	if(!reset)begin
			 if(exec_program_enable)begin
			      if(exec_delete_enable)begin
					   action_flag_mem[exec_program_addr]<=0;
						action_set_mem[exec_program_addr]<=0;
					end
					else begin
					   action_flag_mem[exec_program_addr]<=exec_program_action_flag;
						action_set_mem[exec_program_addr]<=exec_program_action_set;
						$display("Comes Here");
					end
			 end
			 else begin
			    if(exec_of_match_found)begin
			         exec_action_flag<=action_flag_mem[exec_of_match_addr];
						exec_action_set<=action_set_mem[exec_of_match_addr];	
						exec_action_enable<=1'b1;						
						pkt_header_out<=pkt_header_in;
						pkt_addr_out<=pkt_addr_in;
						of_flow_tag_out<=of_flow_tag_in;
				end 
                 else begin
                  exec_action_flag<=0;
						exec_action_set<=0;	
						exec_action_enable<=1'b0;
						pkt_header_out<=0;
						pkt_addr_out<=0;
						of_flow_tag_out<=0;
				end
			 end
	end//
	else begin
	    for(i=0;i<ACTION_MEM_SIZE;i=i+1)begin
		       action_flag_mem[i]<=0;
				 action_set_mem [i]<=0;
		 end
		 
		   exec_action_flag<=0;
			exec_action_set<=0;	
		   exec_action_enable<=1'b0;
			pkt_header_out<=0;
			pkt_addr_out<=0;
			of_flow_tag_out<=0;
	end

end

endmodule
