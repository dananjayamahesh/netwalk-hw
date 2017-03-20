`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:31:59 02/07/2016
// Design Name:   netwalk_dataplane_subsystem
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_dataplane_subystem.v
// Project Name:  NETWALK_DATA_PLANE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: netwalk_dataplane_subsystem
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_netwalk_dataplane_subystem;


	// Inputs
	reg dpl_clk;
	reg dpl_reset;
	reg [5:0] dpl_program_addr;
	reg [355:0] dpl_program_data;
	reg [355:0] dpl_program_mask;
	reg [371:0] dpl_exec_data;
	reg dpl_program_enable;
	reg dpl_delete_enable;
	reg ingress_pcie_clk_i;
	reg ingress_pcie_rst_i;
	reg [127:0] ingress_pcie_data_i;
	reg ingress_pcie_wr_en_i;
	wire ingress_pcie_full_o;
	reg egress_pcie_clk_i;
	reg egress_pcie_rd_i;

	// Outputs
	wire [127:0] egress_pcie_data_o;
	wire egress_pcie_empty_o;
	///wire egress_pcie_valid_o;
	
	 wire [607:0] test_dpl_pkt_hdr_in;
	 wire test_dpl_pkt_header_ready;
           //assign test_dpl_pkt_hdr_in=dpl_pkt_header_in;
            
            wire test_dpl_in_empty;
           // assign test_dpl_in_empty=ingress_dpl_empty_o;
            
            wire test_dpl_rd;
            wire [511:0]test_dpl_fifo_data;
            wire [511:0] test_dpl_pkt_hdr_out;
            wire test_dpl_pkt_header_out_enable;
            
             wire  [511:0]test_egress_dpl_data_i;
             wire test_egress_dpl_wr_en_i;
           //assign test_dpl_rd=ingress_dpl_rd_i;

	// Instantiate the Unit Under Test (UUT)
	netwalk_dataplane_subsystem u1(
		.dpl_clk(dpl_clk), 
		.dpl_reset(dpl_reset), 
		.dpl_program_addr(dpl_program_addr), 
		.dpl_program_data(dpl_program_data), 
		.dpl_program_mask(dpl_program_mask), 
		.dpl_exec_data(dpl_exec_data), 
		.dpl_program_enable(dpl_program_enable), 
		.dpl_delete_enable(dpl_delete_enable), 
		.ingress_pcie_clk_i(dpl_clk), 
		.ingress_pcie_rst_i(dpl_reset), 
		.ingress_pcie_data_i(ingress_pcie_data_i), 
		.ingress_pcie_wr_en_i(ingress_pcie_wr_en_i), 
		.ingress_pcie_full_o(ingress_pcie_full_o), 
		.egress_pcie_clk_i(dpl_clk), 
		.egress_pcie_data_o(egress_pcie_data_o), 
		.egress_pcie_rd_i(egress_pcie_rd_i), 
		.egress_pcie_empty_o(egress_pcie_empty_o), 
		//.egress_pcie_valid_o(egress_pcie_valid_o),
		.test_dpl_pkt_hdr_in(test_dpl_pkt_hdr_in),
		.test_dpl_in_empty(test_dpl_in_empty),
		.test_dpl_rd(test_dpl_rd),
		.test_dpl_fifo_data(test_dpl_fifo_data),
		.test_dpl_pkt_hdr_out(test_dpl_pkt_hdr_out),
		.test_egress_dpl_data_i(test_egress_dpl_data_i),
		.test_egress_dpl_wr_en_i(test_egress_dpl_wr_en_i),
		.test_dpl_pkt_header_ready(test_dpl_pkt_header_ready),
		.test_dpl_pkt_header_out_enable(test_dpl_pkt_header_out_enable)
	);


	initial begin
		// Initialize Inputs
		dpl_clk = 0;
		dpl_reset = 0;
		dpl_program_addr = 0;
		dpl_program_data = 0;
		dpl_program_mask = 0;
		dpl_exec_data = 0;
		dpl_program_enable = 0;
		dpl_delete_enable = 0;
		ingress_pcie_clk_i = 0;
		ingress_pcie_rst_i = 0;
		ingress_pcie_data_i = 0;
		ingress_pcie_wr_en_i = 0;
		//ingress_pcie_full_o = 0;
		egress_pcie_clk_i = 0;
		egress_pcie_rd_i = 0;

		// Wait 100 ns for global reset to finish
		#100;        
		// Add stimulus here
       #20;
    dpl_reset=1;
  #10;
      dpl_reset=0;
      #10;
      //for(i=0;i<5;i=i+1)begin
           dpl_program_enable=1;
            // dpl_program_enable=1;
             // read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
             dpl_program_data=356'h000000000000000000000000005056a5644d0050569a0007080000000000002b61934c2b61934844006a506a5;
              dpl_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
              dpl_program_addr=0;
              //exec_program_addr=0;
               //read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
                  dpl_exec_data=372'h0001000000210000000000000000005056a5644d0050569a0007080000000000002b61934c2b61934844006a506a5;
                    #10;
               
                dpl_program_enable=1;
                              // exec_program_enable=1;
                                //read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                 dpl_program_data=356'h000000000000000000000000005056a5644d0050569a88c7080000000000002b61934c2b61934844006a506a5;
                                dpl_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                dpl_program_addr=1;
                               // exec_program_addr=1;
                                dpl_exec_data=372'h0001000000010000000000000000005056a5644d0050569a88c7080000000000002b61934c2b61934844006a506a5;
                                  #10;
                                 //read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
                                 
                                  dpl_program_enable=1;
                                                 //exec_program_enable=1;
                                                 // read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                                 dpl_program_data=356'h0000000000000000000000000018fe63a30c08060000000000000000000000000000000000000;
                                                 dpl_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                                 dpl_program_addr=2;
                                                 // exec_program_addr=2;
                                                 
                                                   dpl_exec_data=372'h0001000000030000000000000000ffffffffffff0018fe63a30c08060000000000000000000000000000000000000;
                                                      #10;
                                                  // read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
                                                   
                                                                  dpl_program_enable=1;
                                                                   //exec_program_enable=1;
                                                                   // read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                                                    dpl_program_data=356'h000000000000000000000000005056a5644d0050569a78c7080000000000002b61934c2b61934844006a506a5;
                                                                    dpl_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                                                    dpl_program_addr=3;
                                                                    //exec_program_addr=3;
                                                                    dpl_exec_data=372'h0001000000040000000000000000005056a5644d0050569a78c7080000000000002b61934c2b61934844006a506a5;
                                                                     #10;
                                                                    // read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);
                                                                     
																												dpl_program_enable=1;
                                                                                     //dpl_program_enable=1;
                                                                                      //read_tcam_program_data = $fscanf(read_tcam_program_file, "%x", tcam_program_data);
                                                                                      dpl_program_data=356'h0000000000000000000000003c970e8144c10018fe63a30c0800000000000302a0000b02a0000404000000000;
                                                                                      dpl_program_mask<=356'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; 
                                                                                      dpl_program_addr=4;
                                                                                      //exec_program_addr=4;
                                                                                      dpl_exec_data=372'h00010000006200000000000000003c970e8144c10018fe63a30c0800000000000302a0000b02a0000404000000000;
                                                                                      #10;
                                                                                      // read_exec_program_data = $fscanf(read_exec_program_file, "%x", exec_program_data);                
            #10;          
     // end
      #10;
      #5;
       dpl_program_enable=0;
            // exec_program_enable=0;
             #10;
             ingress_pcie_data_i=128'h005056a5644d0050569a78c708004500;
             ingress_pcie_wr_en_i=1'b1;
             #10;
             ingress_pcie_data_i=128'h0064310e000040116a260ad864d30ad8;
                          ingress_pcie_wr_en_i=1'b1;
                          #10;
                          ingress_pcie_data_i=128'h64d206a506a500500000000300000000;
                                       ingress_pcie_wr_en_i=1'b1;
                                       #10;
                                       ingress_pcie_data_i=128'h0bb800000000ffffffffffff00000000;
                                                    ingress_pcie_wr_en_i=1'b1;
                                                    #10;
                                                   //#10;
                                                     ingress_pcie_wr_en_i=1'b0;
                                                     #10;
                                                     #100;
                                               ingress_pcie_data_i=128'h005056a5644d0050569a78c708004500;
                                                     ingress_pcie_wr_en_i=1'b1;
                                                     #10;
                                                     ingress_pcie_data_i=128'h0064310e000040116a260ad864d30ad8;
                                                                  ingress_pcie_wr_en_i=1'b1;
                                                                  #10;
                                                                  ingress_pcie_data_i=128'h64d206a506a500500000000300000000;
                                                                               ingress_pcie_wr_en_i=1'b1;
                                                                               #10;
                                                                               ingress_pcie_data_i=128'h0bb800000000ffffffffffff00000000;
                                                                                            ingress_pcie_wr_en_i=1'b1;
                                                                                            #10;
                                                                                           //#10;
                                                                                             ingress_pcie_wr_en_i=1'b0;
                                                                                             #10;
                                                                                             #100;                                                     
                                                     
                                                    // egress_pcie_rd_i=1'b1;
                                                     #100;
         
             #10; 
                 
     end
                 
                 always begin
                 #5 dpl_clk=~dpl_clk;
                 end
                   
                   
                   always@(posedge dpl_clk)begin
                    
                       egress_pcie_rd_i<= (!egress_pcie_empty_o);
                   end
 endmodule