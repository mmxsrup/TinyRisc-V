`include "param_ram.vh"

module core (
	input clk,
	input rst,

	input [31 : 0] icache_data,
	input icache_valid,
	output [31 : 0] icache_addr,
	output icache_req,

	input dcache_wvalid,
	input [31 : 0] dcache_rdata,
	input dcache_rvalid,
	output [31 : 0] dcache_addr,
	output dcache_wreq,
	output dcache_rreq,
	output [31 : 0] dcache_wdata,
	output [3 : 0] dcache_byte_enable
);


	// from datapath to control
	wire D_C_memory_done;
	wire [`SEL_PC_WIDTH - 1 : 0] D_C_pc_sel;
	wire D_C_br_taken;
	wire [31 : 0] D_C_ir;
	wire [31 : 0] D_C_next_pc;

	// from control to datapath
	wire C_D_fetch_stall;
	wire [`SEL_PC_WIDTH - 1 : 0] C_D_pc_sel;
	wire C_D_br_taken;
	wire [31 : 0] C_D_next_pc;


	control control (
		.clk(clk), .rst(rst),
		.memory_done_i(D_C_memory_done), .pc_sel_i(D_C_pc_sel),
		.br_taken_i(D_C_br_taken), .ir_i(D_C_ir), .next_pc_i(D_C_next_pc),
		.fetch_stall_o(C_D_fetch_stall), .pc_sel_o(C_D_pc_sel),
		.br_taken_o(C_D_br_taken), .next_pc_o(C_D_next_pc)
	);


	datapath datapath (
		.clk(clk), .rst(rst),
		.c_fetch_stall(C_D_fetch_stall), .c_pc_sel(C_D_pc_sel),
		.c_br_taken(C_D_br_taken), .c_next_pc(C_D_next_pc),
		.memory_done(D_C_memory_done), .pc_sel(D_C_pc_sel), .br_taken(D_C_br_taken),
		.ir(D_C_ir), .next_pc(D_C_next_pc),
		.icache_data(icache_data)	, .icache_valid(icache_valid),
		.icache_addr(icache_addr), .icache_req(icache_req),
		.dcache_wvalid(dcache_wvalid), .dcache_rdata(dcache_rdata), .dcache_rvalid(dcache_rvalid),
		.dcache_addr(dcache_addr), .dcache_wreq(dcache_wreq), .dcache_rreq(dcache_rreq),
		.dcache_wdata(dcache_wdata), .dcache_byte_enable(dcache_byte_enable)
	);


endmodule // core
