`include "param_alu_op.vh"	
`include "param_src_a_mux.vh"
`include "param_src_b_mux.vh"
`include "param_pc_mux.vh"

module decode_execute ( // decode and execute
	// from fetch
	input [31 : 0] ir,
	input [31 : 0] pc,

	// from regfile
	input [31 : 0] rs1_data,
	input [31 : 0] rs2_data,

	// from csr_file
	input [31 : 0] csr_rdata,

	// to regfile
	output [4 : 0] rs1_num,
	output [4 : 0] rs2_num,

	// to memory_writeback
	output [6 : 0] opcode,
	output [2 : 0] func3,
	output wb_reg, // write back to reg
	output [4 : 0] rd_num,
	output [31 : 0] rd_data,

	// to fetch
	output [31 : 0] imm,
	output [`SEL_PC_WIDTH - 1 : 0] pc_sel,
	output br_taken,

	// to csr_file
	output [11 : 0] csr_addr,
	output [31 : 0] csr_wdata,
	output wb_csr
);
	
	parameter OP_BRANCH = 7'b1100011;

	wire [31 : 0] imm_w;
	wire [31 : 0] alu_out;
	wire [6 : 0] opcode;
	wire [`ALU_OP_WIDTH - 1 : 0]  alu_op_sel;
	wire [`SEL_SRC_A_WIDTH - 1 : 0] src_a_sel;
	wire [`SEL_SRC_B_WIDTH - 1 : 0] src_b_sel;

	assign opcode = ir[6 : 0];
	assign func3  = ir[14 : 12];

	assign br_taken = (opcode == OP_BRANCH && alu_out == 32'b1) ? 1 : 0;
	assign rd_data = (opcode == 7'b1110011) ? csr_rdata : alu_out;
	assign imm = imm_w;

	assign csr_addr = ir[31 : 20];

	decode decode (
		.code(ir), .rs1_data(rs1_data), .csr_rdata(csr_rdata),
		.rs1_num(rs1_num), .rs2_num(rs2_num), .rd_num(rd_num), .imm(imm_w),
		.alu_op_sel(alu_op_sel),
		.src_a_sel(src_a_sel), .src_b_sel(src_b_sel), .pc_sel(pc_sel),
		.wb_reg(wb_reg),
		.csr_wdata(csr_wdata), .wb_csr(wb_csr)
	);

	execute execute (
		.pc(pc), .imm(imm_w),
		.alu_op_sel(alu_op_sel), .src_a_sel(src_a_sel), .src_b_sel(src_b_sel),
		.rs1_data(rs1_data), .rs2_data(rs2_data),
		.alu_out(alu_out)
	);


endmodule // decode_execute
