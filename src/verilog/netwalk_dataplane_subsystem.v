`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2016 01:30:18 AM
// Design Name: 
// Module Name: netwalk_dataplane_subsystem
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

module netwalk_dataplane_subsystem
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

ingress_pcie_clk_i,
ingress_pcie_rst_i,
ingress_pcie_data_i,
ingress_pcie_wr_en_i,
ingress_pcie_full_o,

egress_pcie_clk_i,
egress_pcie_data_o,
egress_pcie_rd_i,
egress_pcie_empty_o,
//egress_pcie_valid_o,

test_dpl_rd,
test_dpl_in_empty,
test_dpl_pkt_hdr_in,
test_dpl_pkt_header_ready,

test_dpl_fifo_data,
test_dpl_pkt_hdr_out,
test_dpl_pkt_header_out_enable,

test_egress_dpl_wr_en_i,
test_egress_dpl_data_i

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
          
         input ingress_pcie_clk_i;
         input ingress_pcie_rst_i;
        input [127:0]ingress_pcie_data_i;
         input ingress_pcie_wr_en_i;
         output ingress_pcie_full_o;
         
         input egress_pcie_clk_i;
          output [127:0]egress_pcie_data_o;
          input egress_pcie_rd_i;
          output egress_pcie_empty_o;
         // output egress_pcie_valid_o;
          
          //(*mark_debug ="true"*) 
         output [DPL_PKT_BIT_WIDTH-1:0] test_dpl_pkt_hdr_in;
         assign test_dpl_pkt_hdr_in=dpl_pkt_header_in;
         
        output test_dpl_pkt_header_ready;
         assign test_dpl_pkt_header_ready=dpl_pkt_header_ready;
         
        output test_dpl_in_empty;
         assign test_dpl_in_empty=ingress_dpl_empty_o;
         
         output test_dpl_rd;
        assign test_dpl_rd=ingress_dpl_rd_i;
        
        output [511:0]test_dpl_fifo_data;
        assign test_dpl_fifo_data=ingress_dpl_data_o;
        
         output [DPL_PKT_BIT_WIDTH-1:0] test_dpl_pkt_hdr_out;
                assign test_dpl_pkt_hdr_out=dpl_pkt_header_out;
                
                output test_dpl_pkt_header_out_enable;
                assign test_dpl_pkt_header_out_enable=dpl_pkt_header_out_enable;

        reg [DPL_PKT_BIT_WIDTH-1:0] dpl_pkt_header_in;
        reg dpl_pkt_header_ready;
        wire dpl_pkt_header_accept;
               
         wire [DPL_PKT_BIT_WIDTH-1:0] dpl_pkt_header_out;//=0;//EDIT LOOP
         wire  dpl_pkt_header_out_enable;//=0;//EDIT LOOP
          wire dpl_of_table_missed;
                  
          wire [OF_FLOW_TAG_WIDTH-1:0] dpl_flow_tag; 
          wire [TCAM_ADDR_WIDTH-1:0]dpl_flow_addr;
          wire [METER_COUNTER_SIZE-1:0]dpl_flow_count;   
            
          wire [511:0]ingress_dpl_data_o;
          reg ingress_dpl_rd_i;
       // wire ingress_dpl_rd_i;//FOR DEBUGGING
          
          wire ingress_dpl_empty_o;
          wire ingress_dpl_valid_o;          
           //wire egress_dpl_clk_i;
           //wire egress_dpl_rst_i;
           reg [511:0]egress_dpl_data_i;
          reg egress_dpl_wr_en_i;
           wire egress_dpl_full_o;
           
          output   [511:0]test_egress_dpl_data_i;
          output test_egress_dpl_wr_en_i;
          
          assign test_egress_dpl_data_i=egress_dpl_data_i;
          assign test_egress_dpl_wr_en_i=egress_dpl_wr_en_i;
           
        initial begin 
                $monitor("%g %x %x %x %x %x %x %x %x %x %x %x %x\n",$time,ingress_pcie_rst_i,ingress_pcie_clk_i,dpl_clk,ingress_pcie_data_i,ingress_pcie_wr_en_i,ingress_dpl_rd_i,ingress_dpl_valid_o,ingress_dpl_data_o, ingress_pcie_full_o, ingress_dpl_empty_o, dpl_pkt_header_in, dpl_pkt_header_ready );
                end
                                                                                                                                                                                                                                                            
         /*initial begin
         $display("SUBSYSTEM: %g %x %x %x %b\n", $time,ingress_pcie_data_i, ingress_pcie_wr_en_i,dpl_pkt_header_in , ingress_dpl_empty_o);
          end          
         */
       
    	netwalk_dataplane_core_wrapper dataplane_core (
           .dpl_clk(dpl_clk), 
           .dpl_reset(dpl_reset), 
           .dpl_program_addr(dpl_program_addr), 
           .dpl_program_data(dpl_program_data), 
           .dpl_program_mask(dpl_program_mask), 
           .dpl_exec_data(dpl_exec_data), 
           .dpl_program_enable(dpl_program_enable), 
           .dpl_delete_enable(dpl_delete_enable), 
           .dpl_pkt_header_in(dpl_pkt_header_in), 
           .dpl_pkt_header_ready(dpl_pkt_header_ready), 
           .dpl_pkt_header_accept(dpl_pkt_header_accept), 
           .dpl_pkt_header_out(dpl_pkt_header_out), 
           .dpl_pkt_header_out_enable(dpl_pkt_header_out_enable), 
           .dpl_of_table_missed(dpl_of_table_missed),
           .dpl_flow_tag(dpl_flow_tag),
           .dpl_flow_count(dpl_flow_count),
           .dpl_flow_addr(dpl_flow_addr)
       ); 
           
    
       fifo_generator_1 ingress_pkt_buffer (
         .rst(ingress_pcie_rst_i),        // input wire rst
         .wr_clk(ingress_pcie_clk_i),     // input wire wr_clk
         .rd_clk(dpl_clk),                // input wire rd_clk
         .din(ingress_pcie_data_i),        // input wire [127 : 0] din
         .wr_en(ingress_pcie_wr_en_i),    // input wire wr_en
         .rd_en(ingress_dpl_rd_i),
         //.valid(ingress_dpl_valid_o),                      // input wire rd_en
         .dout(ingress_dpl_data_o),                   // output wire [511 : 0] dout
         .full(ingress_pcie_full_o),                    // output wire full
         .empty(ingress_dpl_empty_o)                   // output wire empty
       );
    
    reg ingress_dpl_empty_o_reg=1;
   /* 
 always@(posedge dpl_clk)begin
          if(!dpl_reset)begin
          ingress_dpl_empty_o_reg<=ingress_dpl_empty_o;
             end
           else begin
             ingress_dpl_empty_o_reg<=1'b0;
          end
        end  
          
 */
 //ETHERNET PKT READER  
reg[1:0]rstate=2'b00;

always@(posedge dpl_clk)begin
    if(!dpl_reset)begin
           case(rstate)
           2'b00: begin
           
                    dpl_pkt_header_in<=0;
                    dpl_pkt_header_ready<=1'b0;  
                     ingress_dpl_rd_i<=#1 1'b0;
                     
                    if(!ingress_dpl_empty_o)begin
                        ingress_dpl_rd_i<=#1 1'b1;
                        rstate<= #1 2'b01;
                     end   
                  end
            2'b01: begin
                          ingress_dpl_rd_i<=#1 1'b0;
                          rstate<= #1 2'b10;
                    end          
            2'b10: begin
                          dpl_pkt_header_in<={32'h00000000,64'h0000000000000000,ingress_dpl_data_o};
                          dpl_pkt_header_ready<=1'b1;  
                                 ingress_dpl_rd_i<=#1 1'b0;
                          rstate<= #1 2'b00;    
                   end          
           endcase
    end
    else begin        
            ingress_dpl_rd_i<=#1 1'b0;
             rstate<= #1 2'b00; 
               dpl_pkt_header_in<= 0;
               dpl_pkt_header_ready<=1'b0;  
    end
end
/*
always@(posedge dpl_clk)begin
   if(!dpl_reset)begin
        if(!ingress_dpl_empty_o)begin
          ingress_dpl_rd_i<=1'b1;
          end
          else begin
          ingress_dpl_rd_i<=1'b0;
          end
   end
    else begin
          ingress_dpl_rd_i<=1'b0;
   end
 end  

 //assign ingress_dpl_rd_i  = !ingress_dpl_empty_o;
 reg ingress_dpl_rd_i_reg=0;
 
 always@(posedge dpl_clk)begin
    if(!dpl_reset)begin
         ingress_dpl_rd_i_reg<=ingress_dpl_rd_i;
    end
     else begin
           ingress_dpl_rd_i<=1'b0;
    end
  end  
 
 //assign #2 ingress_dpl_rd_i=(!ingress_dpl_empty_o);
 //assign #1 in_buff_empty
    
always@(posedge dpl_clk)begin
    if(!dpl_reset)begin
          if(ingress_dpl_rd_i_reg)begin            
              dpl_pkt_header_in<={32'h00000000,64'h0000000000000000,ingress_dpl_data_o};
              dpl_pkt_header_ready<=1'b1;
          end
          else begin
                    dpl_pkt_header_in<={32'b0,64'b0,512'b0};
                        dpl_pkt_header_ready<=1'b0;
          end
    end 
    else begin
           dpl_pkt_header_in<={32'b0,64'b0,512'b0};
           dpl_pkt_header_ready<=1'b0;
    end
end
*/
   fifo_generator_2 egress_pkt_buffer(
         .rst(dpl_reset),        // input wire rst
         .wr_clk(dpl_clk),  // input wire wr_clk
         .rd_clk(egress_pcie_clk_i),  // input wire rd_clk
         .din(egress_dpl_data_i),        // input wire [511 : 0] din
         .wr_en(egress_dpl_wr_en_i),    // input wire wr_en
         .rd_en(egress_pcie_rd_i),    // input wire rd_en
        // .valid(egress_pcie_valid_o),
         .dout(egress_pcie_data_o),      // output wire [127 : 0] dout
         .full(egress_dpl_full_o),      // output wire full
         .empty(egress_pcie_empty_o)    // output wire empty
       );


//LOOP BACK CORE PATH WHEN LOOPING
 /*always@(posedge dpl_clk)begin
         if(!dpl_reset)begin  
            if(dpl_pkt_header_ready)begin
              dpl_pkt_header_out<=dpl_pkt_header_in;
              dpl_pkt_header_out_enable<=dpl_pkt_header_ready;
            end 
            else begin
                    dpl_pkt_header_out<=0;
                          dpl_pkt_header_out_enable<=0;            
            end
         end 
         else begin
                dpl_pkt_header_out<=0;
                  dpl_pkt_header_out_enable<=0;
         end       
 end 
    */ 
 
 reg  [1:0] egr_state=2'b00;
 reg [511:0] dpl_pkt_buff=0;
          
always@(posedge dpl_clk)begin
    if(!dpl_reset)begin
           case(egr_state)
             2'b00: begin
                       if(dpl_pkt_header_out_enable)begin
                           egress_dpl_wr_en_i<=1'b1;
                           //egress_dpl_data_i<={32'hffffffff,367'b0,dpl_of_table_missed,2'b0,dpl_flow_addr,3'b0,dpl_flow_tag,dpl_flow_count,32'hffffffff};
                           egress_dpl_data_i<={32'hcccccccc,367'b0,dpl_of_table_missed,2'b0,dpl_flow_addr,3'b0,dpl_flow_tag,dpl_flow_count,dpl_pkt_header_out[607:576],32'hcccccccc}; 
                           dpl_pkt_buff <= dpl_pkt_header_out[511:0]; 
                           egr_state<= 2'b01;
                       end   
                       else begin
                            egress_dpl_wr_en_i<=1'b0;
                           egress_dpl_data_i<=0;                       
                       end          
                    end
              2'b01: begin
                            egress_dpl_wr_en_i<=1'b1;
                            egress_dpl_data_i<=  dpl_pkt_buff; 
                             egr_state<= 2'b10;             
                      end 
              2'b10: begin
                            egress_dpl_wr_en_i<=1'b0;
                            egress_dpl_data_i<= 0; 
                            egr_state<= 2'b00;  
                     end                         
              default: begin
                              egress_dpl_wr_en_i<=1'b0;
                                egress_dpl_data_i<=0;
                      end        
           endcase     
    end
    else begin
                    egress_dpl_wr_en_i<=1'b0;
                    egress_dpl_data_i<=0;
    end
end    
//Latest Working
/*   Commented on 3/15
always@(posedge dpl_clk)begin
  if(!dpl_reset)begin
        if(dpl_pkt_header_out_enable)begin
               egress_dpl_wr_en_i<=1'b1;
               egress_dpl_data_i<=dpl_pkt_header_out[511:0];
        end
        else begin
            egress_dpl_wr_en_i<=1'b0;
            egress_dpl_data_i<=0;
        end    
  end
  else begin
                egress_dpl_wr_en_i<=1'b0;
                egress_dpl_data_i<=0;
  end
end
*/ 
endmodule
