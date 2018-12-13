`include "param_alu_op.vh"	
`include "param_src_a_mux.vh"
`include "param_src_b_mux.vh"

module tb_execute ();

	localparam STEP = 10;
	parameter NOP = 32'b00000000_00000000_00000000_00010011;

	reg [31 : 0] pc;

	reg [31 : 0] imm;
	reg [`ALU_OP_WIDTH - 1 : 0]  alu_op_sel;
	reg [`SEL_SRC_A_WIDTH - 1 : 0] src_a_sel;
	reg [`SEL_SRC_B_WIDTH - 1 : 0] src_b_sel;

	reg [31 : 0] rs1_data;
	reg [31 : 0] rs2_data;

	wire [31 : 0] alu_out;

	execute execute (
		.pc(pc),
		.imm(imm), .alu_op_sel(alu_op_sel), .src_a_sel(src_a_sel), .src_b_sel(src_b_sel),
		.rs1_data(rs1_data), .rs2_data(rs2_data),
		.alu_out(alu_out)
	);

	initial begin
		pc = 32'b10000;
		imm = 32'b10;
		alu_op_sel = `ALU_OP_NONE;
		src_a_sel  = `SEL_SRC_A_NONE;
		src_b_sel  = `SEL_SRC_B_NONE;
		rs1_data = 32'b100000000;
		rs2_data = 32'b0101;
		#(STEP * 10)
		
		alu_op_sel = `ALU_OP_ADD;

		for (integer i = 1; i <= 3; i = i + 1) begin
			for (integer j = 1; j <= 4; j = j + 1) begin
				src_a_sel = i; src_b_sel = j;
				#(STEP)
				$display("[ADD] alu_out: %b", alu_out);
			end
		end

		#(STEP * 100) $stop;
	end

endmodule // tb_execute
