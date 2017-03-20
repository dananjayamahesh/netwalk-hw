`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MAHESH DANANJAYA
// 
// Create Date:    12:48:01 02/03/2016 
// Design Name: 
// Module Name:    netwalk_flow_counter 
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
module netwalk_flow_meter
#(parameter OF_FLOW_TAG_WIDTH=5,DPL_PKT_BIT_WIDTH=512,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356,TCAM_ADDR_WIDTH=6)
(
clk,
reset,
glbl_program_en,

meter_program_addr,
meter_program_enable,
meter_delete_enable,

meter_of_match_addr,
meter_of_match_found,

meter_count,
meter_count_valid,
meter_count_addr,

meter_read_en,
meter_read_addr,
meter_read_data

);

parameter COUNTER_MEM_SIZE=1<<TCAM_ADDR_WIDTH;	 
parameter PROGRAM_DATA_WIDTH=ACTION_FLAG_WIDTH+ACTION_SET_WIDTH;
parameter PROGRAM_ADDR_WIDTH=TCAM_ADDR_WIDTH;
parameter  ACTION_MEM_ADDR_WIDTH=TCAM_ADDR_WIDTH;
parameter METER_COUNTER_SIZE=32;

input clk;
input reset;
input glbl_program_en;

input [PROGRAM_ADDR_WIDTH-1:0]meter_program_addr;
input meter_program_enable;
input meter_delete_enable;

input [TCAM_ADDR_WIDTH-1:0]meter_of_match_addr;
input meter_of_match_found;

output reg[METER_COUNTER_SIZE-1:0]meter_count;
output reg meter_count_valid;
output reg [TCAM_ADDR_WIDTH-1:0]meter_count_addr;

input 	 meter_read_en;
input 	[TCAM_ADDR_WIDTH-1:0]meter_read_addr;
output reg[METER_COUNTER_SIZE-1:0]meter_read_data;

reg [METER_COUNTER_SIZE-1:0] counter [0:COUNTER_MEM_SIZE-1];
reg[METER_COUNTER_SIZE-1:0]meter_count_reg;
reg meter_count_valid_reg;
reg [TCAM_ADDR_WIDTH-1:0]meter_count_addr_reg;

integer i;

always@(meter_read_addr,meter_read_en)begin
		if(meter_read_en)begin
			meter_read_data<=counter[meter_read_addr];
		end
		else begin
			meter_read_data<=32'b0;
		end  
end

initial begin
			for(i=0;i<COUNTER_MEM_SIZE;i=i+1)begin
		       counter[i]<=32'b0;
			end

end
always@(posedge clk)begin
	if(!reset)begin
		if(meter_program_enable)begin
			if(meter_delete_enable)begin
				counter[meter_program_addr]<=32'b0;
			end
			else begin
			    counter[meter_program_addr]<=32'b0;
			end//METER_DELETE_ENABLE
		end
		else begin
		    				  meter_count_valid<=	 meter_count_valid_reg;
                              meter_count<= meter_count_reg;
                                meter_count_addr<=meter_count_addr_reg;
		    if(meter_of_match_found)begin
			    counter[meter_of_match_addr]<=counter[meter_of_match_addr]+1;
				 meter_count_valid_reg<=	meter_of_match_found;
				 meter_count_reg<= counter[meter_of_match_addr]+1;
				 meter_count_addr_reg<=meter_of_match_addr;

			 end
          else begin
             meter_count_valid_reg<=	1'b0;
				 meter_count_reg<= 32'b0;
				 meter_count_addr_reg<=0;
			 end
			  
		end//METER_PROGRAM_ENABLE
	end//RESET
	else begin
	    for(i=0;i<COUNTER_MEM_SIZE;i=i+1)begin
		       counter[i]<=32'b0;
			end
		       meter_count_valid_reg<=	1'b0;
				 meter_count_reg<= 32'b0;
				  meter_count_addr_reg<=0;
	end
end//ALWAYS_END

endmodule
