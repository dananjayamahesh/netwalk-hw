`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NETWALK
// Engineer: MAHESH DANANJAYA
// 
// Create Date:    22:12:39 01/09/2016 
// Design Name: 
// Module Name:    netwalk_tcam_unit 
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
module netwalk_tcam_unit
#(parameter TCAM_UNIT_ADDR=0,DPL_MATCH_FIELD_WIDTH=356,TCAM_ADDR_WIDTH=8)
(
clk,
reset,

tcam_program_data,
tcam_program_mask,
tcam_program_addr,
tcam_unit_sel,
tcam_program_enable,
tcam_delete_enable,

of_match_field_data,
of_matched_addr_out
//of_matched_out

);

input clk;
input reset;
input [DPL_MATCH_FIELD_WIDTH-1:0]tcam_program_data;
input [DPL_MATCH_FIELD_WIDTH-1:0]tcam_program_mask;
input tcam_unit_sel;
input [TCAM_ADDR_WIDTH-1:0]tcam_program_addr;
input tcam_program_enable;
input tcam_delete_enable;

input [DPL_MATCH_FIELD_WIDTH-1:0]of_match_field_data;
output  of_matched_addr_out;

reg [DPL_MATCH_FIELD_WIDTH-1:0]tcam_unit_data;
reg [DPL_MATCH_FIELD_WIDTH-1:0]tcam_unit_mask;
integer i;
reg [DPL_MATCH_FIELD_WIDTH-1:0]of_matched_out;

assign of_matched_addr_out= & of_matched_out;

always@(posedge clk)begin
		if(!reset)begin
			if(tcam_program_enable)begin
			   if(tcam_unit_sel)begin
				   if(tcam_delete_enable)begin
					    	tcam_unit_data<=0;
							tcam_unit_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
					end
					else begin
					tcam_unit_data<=tcam_program_data;
					tcam_unit_mask<=tcam_program_mask;
					end
				end
			end
		   else begin
              	for(i=0;i<DPL_MATCH_FIELD_WIDTH;i=i+1)begin
					     if(tcam_unit_mask[i] == 1'b1)begin
						     of_matched_out[i] = ~(tcam_unit_data[i] ^ of_match_field_data[i]);
						  end						  
						  else begin
								of_matched_out[i] = 1'b1;
						  end
					end
			end
		end 
		else begin
		     tcam_unit_data<=0;
			  tcam_unit_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
			  of_matched_out=0;
		end

end
endmodule

