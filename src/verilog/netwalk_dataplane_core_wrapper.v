`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2016 11:01:03 PM
// Design Name: 
// Module Name: netwalk_dataplane_core_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module netwalk_dataplane_core_wrapper
#(parameter OF_FLOW_TAG_WIDTH=5,DPL_PKT_BIT_WIDTH	=608, DPL_MATCH_FIELD_WIDTH=356,ACTION_FLAG_WIDTH=16,ACTION_SET_WIDTH=356, TCAM_ADDR_WIDTH=6)
(

dpl_clk,
dpl_reset,

dpl_program_addr,
dpl_program_data,
dpl_program_mask,
dpl_exec_data,
dpl_program_enable,
dpl_delete_enable,

dpl_pkt_header_in,
dpl_pkt_header_ready,
dpl_pkt_header_accept,

dpl_pkt_header_out,
dpl_pkt_header_out_enable,
dpl_of_table_missed,
//dpl_pkt_count,
dpl_flow_tag,

dpl_flow_addr,
dpl_flow_count

);
    
    parameter PROGRAM_DATA_WIDTH=ACTION_FLAG_WIDTH+ACTION_SET_WIDTH;
    parameter PROGRAM_ADDR_WIDTH=TCAM_ADDR_WIDTH;
    parameter METER_COUNTER_SIZE=32;

    input dpl_clk;
    input dpl_reset;
    
       input [DPL_MATCH_FIELD_WIDTH-1:0]dpl_program_data;
       input [DPL_MATCH_FIELD_WIDTH-1:0]dpl_program_mask;
       input [TCAM_ADDR_WIDTH-1:0]dpl_program_addr;
       input [PROGRAM_DATA_WIDTH-1:0]dpl_exec_data;
       input dpl_program_enable;
       input dpl_delete_enable;
    
    input [DPL_PKT_BIT_WIDTH-1:0] dpl_pkt_header_in;
    input dpl_pkt_header_ready;
    output dpl_pkt_header_accept;
    
     output [DPL_PKT_BIT_WIDTH-1:0] dpl_pkt_header_out;
     output  dpl_pkt_header_out_enable;
     output dpl_of_table_missed;
     
    output [OF_FLOW_TAG_WIDTH-1:0] dpl_flow_tag;  
    
    output [TCAM_ADDR_WIDTH-1:0]dpl_flow_addr; 
    output [METER_COUNTER_SIZE-1:0]dpl_flow_count;       
    
    wire [DPL_PKT_BIT_WIDTH-1:0] pkt_header_out;
    wire  pkt_out_enable;
    wire [DPL_PKT_BIT_WIDTH-1:0]handler_pkt_header;
    wire missed_pkt_en;    
    wire [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out;
    wire [OF_FLOW_TAG_WIDTH-1:0] of_flow_tag_out2;  
      
    wire [METER_COUNTER_SIZE-1:0]flow_count;
    wire flow_count_valid;   
    wire [TCAM_ADDR_WIDTH-1:0]flow_count_addr; 
    wire [DPL_MATCH_FIELD_WIDTH-1:0]match_d;
    wire match_f;
    wire [TCAM_ADDR_WIDTH-1:0]tcam_addr;
    
     assign dpl_pkt_header_out= (pkt_out_enable)? pkt_header_out:((missed_pkt_en)? handler_pkt_header : 0) ;//pkt_header_out;//
     assign dpl_pkt_header_out_enable   =  pkt_out_enable | missed_pkt_en ; //pkt_out_enable; //
     assign dpl_flow_tag = (pkt_out_enable)? of_flow_tag_out:((missed_pkt_en)? of_flow_tag_out2 : 0) ;//of_flow_tag_out;//
     assign dpl_of_table_missed=missed_pkt_en;
     assign dpl_flow_addr=flow_count_addr;
     assign dpl_flow_count=flow_count;
      
netwalk_dataplane_core
    #(.OF_FLOW_TAG_WIDTH(OF_FLOW_TAG_WIDTH),.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH), .DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH),.ACTION_FLAG_WIDTH(ACTION_FLAG_WIDTH),.ACTION_SET_WIDTH(ACTION_SET_WIDTH), .TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
         dataplane_core(
            .clk(dpl_clk), 
            .reset(dpl_reset), 
            .tcam_program_data(dpl_program_data), 
            .tcam_program_mask(dpl_program_mask), 
            .tcam_program_addr(dpl_program_addr), 
            .tcam_program_enable(dpl_program_enable), 
            .tcam_delete_enable(dpl_delete_enable), 
            .exec_program_data(dpl_exec_data), 
            .exec_program_addr(dpl_program_addr), 
            .exec_program_enable(dpl_program_enable), 
            .exec_delete_enable(dpl_delete_enable), 
            .pkt_header_in(dpl_pkt_header_in), 
            .pkt_header_ready(dpl_pkt_header_ready), 
            .pkt_header_accept(dpl_pkt_header_accept), 
            
            .pkt_header_out(pkt_header_out), 
            .pkt_out_enable(pkt_out_enable),
            
            .handler_pkt_header(handler_pkt_header),
            .missed_pkt_en(missed_pkt_en),
                      
             .of_flow_tag_out(of_flow_tag_out),
            .of_flow_tag_out2(of_flow_tag_out2),
            
            .match_d(match_d),
            .match_f(match_f),
            .tcam_addr(tcam_addr),
            
            .flow_count(flow_count),
            .flow_count_valid(flow_count_valid),
            .flow_count_addr(flow_count_addr)
            
          
        );


endmodule
