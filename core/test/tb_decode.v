`include "param_alu_op.vh"	
`include "param_src_a_mux.vh"
`include "param_src_b_mux.vh"
`include "param_pc_mux.vh"

module tb_decode ();

	localparam STEP = 10;

	reg [31 : 0] code;
	wire [4 : 0] rs1_num;
	wire [4 : 0] rs2_num;
	wire [4 : 0] rd_num;
	wire [31 : 0] imm;
	wire [`ALU_OP_WIDTH - 1 : 0]  alu_op_sel;
	wire [`SEL_SRC_A_WIDTH - 1 : 0] src_a_sel;
	wire [`SEL_SRC_B_WIDTH - 1 : 0] src_b_sel;
	wire [`SEL_PC_WIDTH - 1 : 0] pc_sel;
	wire wb_reg;


	decode decode (
		.code(code),
		.rs1_num(rs1_num), .rs2_num(rs2_num), 
		.rd_num(rd_num), .imm(imm),
		.alu_op_sel(alu_op_sel),
		.src_a_sel(src_a_sel), .src_b_sel(src_b_sel), .pc_sel(pc_sel),
		.wb_reg(wb_reg)
	);


	initial begin
		code = 32'h0;
		#(STEP * 10)

		// type I
		code = 32'b111100001111_00001_000_00010_0010011;
		#(STEP)
		$display("rs1_num: %b, rs2_num: %b, rd_num: %b, imm: %b, alu_sel: %b, a_sel: %b, b_sel: %b, pc_sel: %b, wb: %b",
			rs1_num, rs2_num, rd_num, imm, alu_op_sel, src_a_sel, src_b_sel, pc_sel, wb_reg);

		// type S
		code = 32'b1111111_00001_00010_000_00000_0100011;
		#(STEP)
		$display("rs1_num: %b, rs2_num: %b, rd_num: %b, imm: %b, alu_sel: %b, a_sel: %b, b_sel: %b, pc_sel: %b, wb: %b",
			rs1_num, rs2_num, rd_num, imm, alu_op_sel, src_a_sel, src_b_sel, pc_sel, wb_reg);

		// type B
		code = 32'b0_010001_00010_00001_000_0101_1_1100011;
		#(STEP)
		$display("rs1_num: %b, rs2_num: %b, rd_num: %b, imm: %b, alu_sel: %b, a_sel: %b, b_sel: %b, pc_sel: %b, wb: %b",
			rs1_num, rs2_num, rd_num, imm, alu_op_sel, src_a_sel, src_b_sel, pc_sel, wb_reg);
		
		// type U
		code = 32'b11110000111100001111_00001_0110111;
		#(STEP)
		$display("rs1_num: %b, rs2_num: %b, rd_num: %b, imm: %b, alu_sel: %b, a_sel: %b, b_sel: %b, pc_sel: %b, wb: %b",
			rs1_num, rs2_num, rd_num, imm, alu_op_sel, src_a_sel, src_b_sel, pc_sel, wb_reg);

		// type J
		code = 32'b1_0000000000_1_00000000_00001_1101111;
		#(STEP)
		$display("rs1_num: %b, rs2_num: %b, rd_num: %b, imm: %b, alu_sel: %b, a_sel: %b, b_sel: %b, pc_sel: %b, wb: %b",
			rs1_num, rs2_num, rd_num, imm, alu_op_sel, src_a_sel, src_b_sel, pc_sel, wb_reg);


		#(STEP * 100) $stop;
	end

endmodule // tb_decode
