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
	output done
);

	wire [6 : 0] opcode;
	wire [2 : 0] func3;
	wire [31 : 0] dcache_out;

	assign wb_rd_num = rd_num;

	memory memory (
		.clk(clk), .rst(rst),
		.opcode(opcode), .func3(func3), .alu_out(alu_out), .rs2(rs2_data),
		.rdata(dcache_out), .done(done)
	);

	writeback writeback (
		.opcode(opcode), 
		.alu_out(alu_out), .wb_reg(wb_reg),
		.dcache_out(dcache_out), .done(done),
		.wb_rd_data(wb_rd_data), .wb_enable(wb_enable)
	);


endmodule // memory_writeback
