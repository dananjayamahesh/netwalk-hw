`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:    MAHESH DANANJAYA
//
// Create Date:   19:02:48 01/14/2016
// Design Name:   netwalk_dataplane_core
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_dataplane_core.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_dataplane_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module tb_netwalk_dataplane_core;
	// Inputs
parameter PKT_BUFF_ADDR_WIDTH			=9;
parameter OF_FLOW_TAG_WIDTH			=5;
parameter DPL_PKT_BYTE_WIDTH			=64;
parameter DPL_PKT_BIT_WIDTH			=608;//512;
parameter DPL_MATCH_FIELD_WIDTH		=356; 
parameter DPL_PKT_ADDR_WIDTH			=6; 
parameter DPL_PKT_DATA_WIDTH			=8;

parameter TCAM_ADDR_WIDTH				=6;

parameter ACTION_FLAG_WIDTH			=16;
parameter ACTION_SET_WIDTH				=356;

	reg clk;
	reg reset;
	reg [355:0] tcam_program_data;
	reg [355:0] tcam_program_mask;
	reg [5:0] tcam_program_addr;
	reg tcam_program_enable;
	reg tcam_delete_enable;
	reg [371:0] exec_program_data;
	reg [5:0] exec_program_addr;
	reg exec_program_enable;
	reg exec_delete_enable;
	reg [607:0] pkt_header_in;
	reg pkt_header_ready;

	// Outputs
	wire pkt_header_accept;
	wire [607:0] pkt_header_out;
	wire pkt_out_enable;
	wire [355:0]match_d;
	wire[TCAM_ADDR_WIDTH-1:0]tcam_addr;
	
	wire match_f;
	
	wire flow_count_valid;
	wire [31:0]flow_count;
	
	wire	[DPL_PKT_BIT_WIDTH-1:0]handler_pkt_header;
	wire  missed_pkt_en;
	
	integer read_header_file;
	integer read_header_data;
	
	integer read_tcam_program_file;
	integer read_tcam_program_data;
	
	integer read_exec_program_file;
	integer read_exec_program_data;
	
	
	
	integer output_file;
	integer output_data;
	
	integer i=0;

	// Instantiate the Unit Under Test (UUT)
	netwalk_dataplane_core
#(.DPL_PKT_BIT_WIDTH(DPL_PKT_BIT_WIDTH), .DPL_MATCH_FIELD_WIDTH(DPL_MATCH_FIELD_WIDTH),.ACTION_FLAG_WIDTH(ACTION_FLAG_WIDTH),.ACTION_SET_WIDTH(ACTION_SET_WIDTH), .TCAM_ADDR_WIDTH(TCAM_ADDR_WIDTH))
	 uut(
		.clk(clk), 
		.reset(reset), 
		.tcam_program_data(tcam_program_data), 
		.tcam_program_mask(tcam_program_mask), 
		.tcam_program_addr(tcam_program_addr), 
		.tcam_program_enable(tcam_program_enable), 
		.tcam_delete_enable(tcam_delete_enable), 
		.exec_program_data(exec_program_data), 
		.exec_program_addr(exec_program_addr), 
		.exec_program_enable(exec_program_enable), 
		.exec_delete_enable(exec_delete_enable), 
		.pkt_header_in(pkt_header_in), 
		.pkt_header_ready(pkt_header_ready), 
		.pkt_header_accept(pkt_header_accept), 
		.pkt_header_out(pkt_header_out), 
		.pkt_out_enable(pkt_out_enable),
		
		.match_d(match_d),
		.match_f(match_f),
		.tcam_addr(tcam_addr),
		
		.flow_count(flow_count),
      .flow_count_valid(flow_count_valid),
		
		.handler_pkt_header(handler_pkt_header),
		.missed_pkt_en(missed_pkt_en)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		tcam_program_data = 0;
		tcam_program_mask = 0;
		tcam_program_addr = 0;
		tcam_program_enable = 0;
		tcam_delete_enable = 0;
		exec_program_data = 0;
		exec_program_addr = 0;
		exec_program_enable = 0;
		exec_delete_enable = 0;
		pkt_header_in = 0;
		pkt_header_ready = 0;
			
			//read_header_file =		$fopen("input/pkt_header.txt","r");				
			//read_tcam_program_file =		$fopen("input/tcam_input.txt","r");	
			//read_exec_program_file =		$fopen("input/exec_engine_program_input.txt","r");	
      	//output_file =		$fopen("output/output.txt","w+");
		// Wait 100 ns for global reset to finish
		#20;
        reset=1;
	  #10;
		  reset=0;
		  #10;
		  //for(i=0;i<5;i=i+1)begin
		       tcam_program_enable=1;
				 exec_program_enable=1;
				 // read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
				 tcam_program_data=356'h00000072ffffffffffffffff005056a5644d0050569a0007080000000000002b61934c2b61934844006a506a5;
				  tcam_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
				  tcam_program_addr=0;
				  exec_program_addr=0;
				   //read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
				      exec_program_data=356'h0001000000210000000000000000005056a5644d0050569a0007080000000000002b61934c2b61934844006a506a5;
				        #10;
				   
				    tcam_program_enable=1;
                                   exec_program_enable=1;
                                    //read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                     tcam_program_data=356'h00000072ffffffffffffffff005056a5644d0050569a88c7080000000000002b61934c2b61934844006a506a5;
                                    tcam_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                    tcam_program_addr=1;
                                    exec_program_addr=1;
                                    exec_program_data=356'h0001000000010000000000000000005056a5644d0050569a88c7080000000000002b61934c2b61934844006a506a5;
                                      #10;
                                     //read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
                                     
                                      tcam_program_enable=1;
                                                     exec_program_enable=1;
                                                     // read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                                     tcam_program_data=356'h0000003cffffffffffffffffffffffffffff0018fe63a30c08060000000000000000000000000000000000000;
                                                      tcam_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                                      tcam_program_addr=2;
                                                      exec_program_addr=2;
                                                     
                                                        exec_program_data=356'h0001000000030000000000000000ffffffffffff0018fe63a30c08060000000000000000000000000000000000000;
                                                          #10;
                                                      // read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
                                                       
                                                        tcam_program_enable=1;
                                                                       exec_program_enable=1;
                                                                       // read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                                                        tcam_program_data=356'h00000072ffffffffffffffff005056a5644d0050569a78c7080000000000002b61934c2b61934844006a506a5;
                                                                        tcam_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                                                        tcam_program_addr=3;
                                                                        exec_program_addr=3;
                                                                        xec_program_data=356'h0001000000040000000000000000005056a5644d0050569a78c7080000000000002b61934c2b61934844006a506a5;
                                                                         #10;
                                                                        // read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
                                                                         
                                                                          tcam_program_enable=1;
                                                                                         exec_program_enable=1;
                                                                                          //read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                                                                          tcam_program_data=356'h00000062ffffffffffffffff3c970e8144c10018fe63a30c0800000000000302a0000b02a0000404000000000;
                                                                                          tcam_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                                                                          tcam_program_addr=4;
                                                                                          exec_program_addr=4;
                                                                                          xec_program_data=356'h00010000006200000000000000003c970e8144c10018fe63a30c0800000000000302a0000b02a0000404000000000;
                                                                                          #10;
                                                                                          // read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);				
				#10;		  
		 // end
		  #10;
		   tcam_program_enable=0;
				 exec_program_enable=0;
				 #10;
				 		  for(i=0;i<4;i=i+1)begin
								pkt_header_ready=1;
								read_header_data = $fscanf(read_header_file, "%x", pkt_header_in);
				   		#10;		  
		              end
		 tcam_program_enable=1;
				 exec_program_enable=1;
				  tcam_program_data = 356'h0000007600000076005056a5005056a5644d0050569a0007080000000000002b61934c2b61934844006a506a5;
				  tcam_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
				  tcam_program_addr=5;
				  exec_program_addr=5;
				   exec_program_data= 372'h00010000007600000076005056a5005056a5644d0050569a0007080000000000002b61934c2b61934844006a506a5;
					#10 ;
				
             tcam_program_enable=0;
				 exec_program_enable=0;					
						  for(i=4;i<5;i=i+1)begin
								pkt_header_ready=1;
								read_header_data = $fscanf(read_header_file, "%x", pkt_header_in);
				   		#10;		  
		              end
				#10; 
		// Add stimulus here

	    end
	
	always begin
	#5 clk=~clk;
	end
      
endmodule

