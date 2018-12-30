`include "param_alu_op.vh"	
`include "param_src_a_mux.vh"
`include "param_src_b_mux.vh"

module execute (
	// from controller
	input [31 : 0] pc,

	// from decoder
	input [31 : 0] imm,
	input [`ALU_OP_WIDTH - 1 : 0]  alu_op_sel,
	input [`SEL_SRC_A_WIDTH - 1 : 0] src_a_sel,
	input [`SEL_SRC_B_WIDTH - 1 : 0] src_b_sel,

	// from regfile (decode_execute)
	input [31 : 0] rs1_data,
	input [31 : 0] rs2_data,

	// to write back
	output [31 : 0] alu_out
);
	

	wire [31 : 0] alu_src_a;
	wire [31 : 0] alu_src_b;


	src_a_mux src_a_mux (
		.pc(pc),
		.rs1_data(rs1_data),
		.imm(imm),
		.select(src_a_sel),
		.alu_src_a(alu_src_a)
	);

	src_b_mux src_b_mux (
		.rs2_data(rs2_data),
		.imm(imm),
		.select(src_b_sel),
		.alu_src_b(alu_src_b)
	);

	alu alu (
		.operator(alu_op_sel),
		.imm(imm), .operand1(alu_src_a), .operand2(alu_src_b),
		.out(alu_out)
	);


endmodule // execute
