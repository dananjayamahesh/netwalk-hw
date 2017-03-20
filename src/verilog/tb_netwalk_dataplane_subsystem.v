`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:56:05 02/06/2016
// Design Name:   netwalk_dataplane_subsystem
// Module Name:   H:/FYP/NETWALK/NETWALK_DATA_PLANE/NETWALK_DATA_PLANE/tb_netwalk_dataplane_subsystem.v
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

module tb_netwalk_dataplane_subsystem;

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
	reg ingress_pcie_full_o;
	reg egress_pcie_clk_i;
	reg egress_pcie_rd_i;

	// Outputs
	wire [127:0] egress_pcie_data_o;
	wire egress_pcie_empty_o;
	wire egress_pcie_valid_o;

	// Instantiate the Unit Under Test (UUT)
	netwalk_dataplane_subsystem uut (
		.dpl_clk(dpl_clk), 
		.dpl_reset(dpl_reset), 
		.dpl_program_addr(dpl_program_addr), 
		.dpl_program_data(dpl_program_data), 
		.dpl_program_mask(dpl_program_mask), 
		.dpl_exec_data(dpl_exec_data), 
		.dpl_program_enable(dpl_program_enable), 
		.dpl_delete_enable(dpl_delete_enable), 
		.ingress_pcie_clk_i(ingress_pcie_clk_i), 
		.ingress_pcie_rst_i(ingress_pcie_rst_i), 
		.ingress_pcie_data_i(ingress_pcie_data_i), 
		.ingress_pcie_wr_en_i(ingress_pcie_wr_en_i), 
		.ingress_pcie_full_o(ingress_pcie_full_o), 
		.egress_pcie_clk_i(egress_pcie_clk_i), 
		.egress_pcie_data_o(egress_pcie_data_o), 
		.egress_pcie_rd_i(egress_pcie_rd_i), 
		.egress_pcie_empty_o(egress_pcie_empty_o), 
		.egress_pcie_valid_o(egress_pcie_valid_o)
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
		ingress_pcie_full_o = 0;
		egress_pcie_clk_i = 0;
		egress_pcie_rd_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

