`include "param_ram.vh"

module memory_writeback
(
	input clk,
	input rst,
	
	// from decode_execute
	input [6 : 0] opcode,
	input [2 : 0] func3,
	input wb_reg,
	input [4 : 0] rd_num,
	input [31 : 0] alu_out,
	input [31 : 0] rs2_data,

	// to regfile
	output wb_enable,
	output [4 : 0] wb_rd_num,
	output [31 : 0] wb_rd_data,

	// contoroller
	output done,


	// write
	output [`AWIDTH - 1 : 0] ram_awaddr,
	output [`LWIDTH - 1 : 0] ram_awlen,
	output ram_awvalid,
	input ram_awready,
	output [`DWIDTH - 1 : 0] ram_wdata,
	input ram_wvalid,
	output ram_wready,
	input ram_wlast,
	// read
	output [`AWIDTH - 1 : 0] ram_araddr,
	output [`LWIDTH - 1 : 0] ram_arlen,
	output ram_arvalid,
	input ram_arready,
	input [`DWIDTH - 1 : 0] ram_rdata,
	input ram_rvalid,
	output ram_rready,
	input ram_rlast
);

	wire [31 : 0] dcache_out;

	assign wb_rd_num = rd_num;

	memory memory (
		.clk(clk), .rst(rst),
		.opcode(opcode), .func3(func3), .alu_out(alu_out), .rs2(rs2_data),
		.rdata(dcache_out), .done(done),
		.ram_awaddr(ram_awaddr), .ram_awlen(ram_awlen), .ram_awvalid(ram_awvalid), .ram_awready(ram_awready),
		.ram_wdata(ram_wdata), .ram_wvalid(ram_wvalid), .ram_wready(ram_wready), .ram_wlast(ram_wlast),
		.ram_araddr(ram_araddr), .ram_arlen(ram_arlen), .ram_arvalid(ram_arvalid), .ram_arready(ram_arready),
		.ram_rdata(ram_rdata), .ram_rvalid(ram_rvalid), .ram_rready(ram_rready), .ram_rlast(ram_rlast)
	);

	writeback writeback (
		.opcode(opcode), 
		.alu_out(alu_out), .wb_reg(wb_reg),
		.dcache_out(dcache_out), .done(done),
		.wb_rd_data(wb_rd_data), .wb_enable(wb_enable)
	);


endmodule // memory_writeback
