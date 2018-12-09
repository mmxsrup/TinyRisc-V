`include "param_src_a_mux.vh"

module src_a_mux
(
	// from controller
	input [31 : 0] pc,
	// from regfile
	input [31 : 0] rs1_data,
	// from decoder
	input [31 : 0] imm,
	input [`SEL_SRC_A_WIDTH - 1 : 0] select,

	// to alu
	output reg [31 : 0] alu_src_a
);
	
	always @(*) begin
		case (select)
			`SEL_SRC_A_PC  : alu_src_a = pc;
			`SEL_SRC_A_RS1 : alu_src_a = rs1_data;
			`SEL_SRC_A_IMM : alu_src_a = imm;
			default : alu_src_a = 32'b0;
		endcase
	end // always @(*)


endmodule // src_a_mux
