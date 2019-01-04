`include "param_ram.vh"

module core (
	input clk,
	input rst,


	// write
	output [`AWIDTH - 1 : 0] i_ram_awaddr,
	output [`LWIDTH - 1 : 0] i_ram_awlen,
	output i_ram_awvalid,
	input i_ram_awready,
	output [`DWIDTH - 1 : 0] i_ram_wdata,
	input i_ram_wvalid,
	output i_ram_wready,
	input i_ram_wlast,
	// read
	output [`AWIDTH - 1 : 0] i_ram_araddr,
	output [`LWIDTH - 1 : 0] i_ram_arlen,
	output i_ram_arvalid,
	input i_ram_arready,
	input [`DWIDTH - 1 : 0] i_ram_rdata,
	input i_ram_rvalid,
	output i_ram_rready,
	input i_ram_rlast,


	// write
	output [`AWIDTH - 1 : 0] d_ram_awaddr,
	output [`LWIDTH - 1 : 0] d_ram_awlen,
	output d_ram_awvalid,
	input d_ram_awready,
	output [`DWIDTH - 1 : 0] d_ram_wdata,
	input d_ram_wvalid,
	output d_ram_wready,
	input d_ram_wlast,
	// read
	output [`AWIDTH - 1 : 0] d_ram_araddr,
	output [`LWIDTH - 1 : 0] d_ram_arlen,
	output d_ram_arvalid,
	input d_ram_arready,
	input [`DWIDTH - 1 : 0] d_ram_rdata,
	input d_ram_rvalid,
	output d_ram_rready,
	input d_ram_rlast
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
		.i_ram_awaddr(i_ram_awaddr), .i_ram_awlen(i_ram_awlen), .i_ram_awvalid(i_ram_awvalid), .i_ram_awready(i_ram_awready),
		.i_ram_wdata(i_ram_wdata), .i_ram_wvalid(i_ram_wvalid), .i_ram_wready(i_ram_wready), .i_ram_wlast(i_ram_wlast),
		.i_ram_araddr(i_ram_araddr), .i_ram_arlen(i_ram_arlen), .i_ram_arvalid(i_ram_arvalid), .i_ram_arready(i_ram_arready),
		.i_ram_rdata(i_ram_rdata), .i_ram_rvalid(i_ram_rvalid), .i_ram_rready(i_ram_rready), .i_ram_rlast(i_ram_rlast),
		.d_ram_awaddr(d_ram_awaddr), .d_ram_awlen(d_ram_awlen), .d_ram_awvalid(d_ram_awvalid), .d_ram_awready(d_ram_awready),
		.d_ram_wdata(d_ram_wdata), .d_ram_wvalid(d_ram_wvalid), .d_ram_wready(d_ram_wready), .d_ram_wlast(d_ram_wlast),
		.d_ram_araddr(d_ram_araddr), .d_ram_arlen(d_ram_arlen), .d_ram_arvalid(d_ram_arvalid), .d_ram_arready(d_ram_arready),
		.d_ram_rdata(d_ram_rdata), .d_ram_rvalid(d_ram_rvalid), .d_ram_rready(d_ram_rready), .d_ram_rlast(d_ram_rlast)
	);


endmodule // core
