`include "param_src_b_mux.vh"

module src_b_mux
(
	// from regfile
	input [31 : 0] rs2_data,
	// from decoder
	input [31 : 0] imm,
	input [`SEL_SRC_B_WIDTH - 1 : 0] select,

	// to alu
	output reg [31 : 0] alu_src_b
);
	
	always @(*) begin
		case (select)
			`SEL_SRC_B_RS2    : alu_src_b = rs2_data;
			`SEL_SRC_B_IMM    : alu_src_b = imm;
			`SEL_SRC_B_0      : alu_src_b = 32'h0;
			`SEL_SRC_B_4     : alu_src_b = 32'h4;
			default : alu_src_b = 32'b0;
		endcase
	end // always @(*)

endmodule // src_b_mux
