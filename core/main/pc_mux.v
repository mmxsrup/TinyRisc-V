`include "param_pc_mux.vh"

module pc_mux (
	input [31 : 0] pc,	
	input [31 : 0] rs1, // from decoder
	input [31 : 0] imm, // from decoder
	input [`PC_SEL_WIDTH - 1 : 0] pc_sel, // from decode
	input taken, // from br_cond
	input stall, // from controller
	output reg [31 : 0] next_pc
);


	always @(*) begin
		if (stall) begin // stall
			next_pc = pc;
		end else if (taken) begin // branch is taken
			next_pc = pc + imm;
		end else begin
			case (pc_sel)
				`PC_SEL_JAL  : next_pc = pc + imm; // jump and link
				`PC_SEL_JALR : next_pc = rs1 + imm; // jump and link register
				`PC_SEL_ADD4 : next_pc = pc + 32'h4; // +4
				`PC_SEL_NONE : next_pc = 32'h0;
			endcase // pc_sel
		end
	end // always @(*)
	
endmodule // pc_mux
