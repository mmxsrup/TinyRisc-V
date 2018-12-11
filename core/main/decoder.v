`include "param_alu_op.vh"	
`include "param_src_a_mux.vh"
`include "param_src_b_mux.vh"

module decoder
(
	// from fetch
	input wire [31 : 0] code,
	
	// to alu etc..
	output wire [4 : 0] rs1_num,
	output wire [4 : 0] rs2_num,
	output wire [4 : 0] rd_num,
	output reg  [31 : 0] imm,

	// to alu
	output reg [`ALU_OP_WIDTH - 1 : 0]  alu_op_sel,
	// to src_a_mux
	output reg [`SEL_SRC_A_WIDTH - 1 : 0] src_a_sel,
	// to src_b_mux
	output reg [`SEL_SRC_B_WIDTH - 1 : 0] src_b_sel,
	// to write back
	output wr_reg
);
	
	parameter TYPE_WIDTH = 3;
	parameter TYPE_NONE = 3'b000;
	parameter TYPE_R = 3'b001;
	parameter TYPE_I = 3'b010;
	parameter TYPE_S = 3'b011;
	parameter TYPE_B = 3'b100;
	parameter TYPE_U = 3'b101;
	parameter TYPE_J = 3'b110;


	reg [TYPE_WIDTH - 1 : 0] type;
	wire [6 : 0] opcode;
	wire [2 : 0] func3;
	wire [6 : 0] func7;

	assign opcode = code[6 : 0];
	assign func3 = code[14 : 12];
	assign func7 = code[31 : 25];


	// generate ir type
	always @(*) begin
		case (code[6 : 5])
			2'b00 : begin
				if (code[4 : 2] == 3'b000 || code[4 : 2] == 3'b100 || code[4 : 2] == 3'b011) type = TYPE_I;
				else if (code[4 : 2] == 3'b101) type = TYPE_U;
				else type = TYPE_NONE;
			end
			2'b01: begin
				if (code[4 : 2] == 3'b100) type = TYPE_R;
				else if (code[4 : 2] == 3'b000) type = TYPE_S;
				else if (code[4 : 2] == 3'b101) type = TYPE_U;
				else type = TYPE_NONE;
			end
			2'b11: begin
				if (code[4 : 0] == 5'b10011 || code[4 : 0] == 5'b00111) type = TYPE_I;
				else if (code[4 : 0] == 5'b00011) type = TYPE_B;
				else if (code[4 : 0] == 5'b01111) type = TYPE_J;
				else type = TYPE_NONE;
			end
			default: type = TYPE_NONE;
		endcase
	end // always @(*)


	// generate imm value
	always @(*) begin
		case (type)
			TYPE_I : imm = { {21{code[31]}}, code[30 : 20] };
			TYPE_S : imm = { {21{code[31]}}, code[30 : 25], code[11 : 7] };
			TYPE_B : imm = { {20{code[12]}}, code[7], code[30 : 25], code[11 : 8], 1'b0 };
			TYPE_U : imm = { code[31 : 12], 12'b0 };
			TYPE_J : imm = { {12{code[31]}}, code[19 : 12], code[20], code[30 : 21], 1'b0 };
			default : imm = 32'b0;
		endcase
	end // always @(*)


	// generate source and dest regisiter number
	assign rs1_num = (type == TYPE_U || type == TYPE_J) ? 5'b0 : code[19 : 15];
	assign rs2_num = (type == TYPE_I || type == TYPE_U || type == TYPE_J) ? 5'b0 : code[24 : 20];
	assign rd_num  = (type == TYPE_S || type == TYPE_B) ? 5'b0 : code[11 : 7];
	

	// generate alu_op_sel
	always @(*) begin
		case (opcode)
			7'b0010011, 7'b0110011 : begin // OP, OP-IMM
				case (func3)
					3'b000 : alu_op_sel = `ALU_OP_ADD;
					3'b010 : alu_op_sel = `ALU_OP_SLT;
					3'b011 : alu_op_sel = `ALU_OP_SLTU;
					3'b100 : alu_op_sel = `ALU_OP_XOR;
					3'b110 : alu_op_sel = `ALU_OP_OR;
					3'b111 : alu_op_sel = `ALU_OP_AND;
					3'b001 : alu_op_sel = `ALU_OP_SLL;
					3'b101 : begin
						case (func7)
							7'b0100000 : alu_op_sel = `ALU_OP_SRL;
							7'b0000000 : alu_op_sel = `ALU_OP_SRA;
							default : alu_op_sel = `ALU_OP_NONE;
						endcase // func7
					end
				endcase // func3
			end
			7'b1100011 : begin // BRANCH
				case (func3)
					3'b000 : alu_op_sel = `ALU_OP_SEQ;
					3'b001 : alu_op_sel = `ALU_OP_SNE;
					3'b100 : alu_op_sel = `ALU_OP_SLT;
					3'b101 : alu_op_sel = `ALU_OP_SGE;
					3'b110 : alu_op_sel = `ALU_OP_SLTU;
					3'b111 : alu_op_sel = `ALU_OP_SGEU;
					default : alu_op_sel = `ALU_OP_NONE;
				endcase // func3
			end
			7'b0100011, 7'b0000011 : begin // STORE, LOAD
				alu_op_sel = `ALU_OP_ADD;
			end
			7'b0110111, 7'b0010111, 7'b1101111, 7'b1100111 : begin // LUI, AUIPC, JAL, JALR
				alu_op_sel = `ALU_OP_ADD;
			end
			default : alu_op_sel = `ALU_OP_NONE;
		endcase // opcode
	end


	// generate src_a_sel
	always @(*) begin
		case (type)
			TYPE_I, TYPE_R, TYPE_S : begin
				if (opcode == 7'b1100111) src_a_sel = `SEL_SRC_A_PC; // JALR
				else src_a_sel = `SEL_SRC_A_RS1;
			end
			TYPE_R, TYPE_S : src_a_sel = `SEL_SRC_A_RS1;
			TYPE_B : src_a_sel = `SEL_SRC_A_NONE;
			TYPE_U : begin
				case (opcode)
					7'b0110111 : src_a_sel = `SEL_SRC_A_IMM; // LUI
					7'b0010111 : src_a_sel = `SEL_SRC_A_PC; // AUIPC
					default  : src_a_sel = `SEL_SRC_A_NONE;
				endcase
			end
			TYPE_J : src_a_sel = `SEL_SRC_A_PC;
			default : src_a_sel = `SEL_SRC_A_NONE;
		endcase // type
	end // always @(*)


	// generate src_b_sel
	always @(*) begin
		case (type)
			TYPE_I : begin
				if (opcode == 7'b1100111) src_b_sel = `SEL_SRC_B_4; // JALR
				else src_b_sel = `SEL_SRC_B_IMM;
			end
			TYPE_S : src_b_sel = `SEL_SRC_B_IMM;
			TYPE_R, TYPE_B : src_b_sel = `SEL_SRC_B_RS2;
			TYPE_U : begin
				case (opcode)
					7'b0110111 : src_b_sel = `SEL_SRC_B_0; // LUI
					7'b0010111 : src_b_sel = `SEL_SRC_B_IMM; // AUIPC
					default  : src_b_sel = `SEL_SRC_B_NONE;
				endcase
			end
			TYPE_J : src_b_sel = `SEL_SRC_B_4;
			default : src_b_sel = `SEL_SRC_B_NONE;
		endcase // type
	end // always @(*)


	// generate write back signal
	assign wr_reg = (type == TYPE_I || type == TYPE_R || type == TYPE_U || type == TYPE_J) ? 1 : 0;


endmodule // decoder