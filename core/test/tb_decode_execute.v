`include "param_pc_mux.vh"

module tb_decode_execute ();

	localparam STEP = 10;

	reg [31 : 0] ir;
	reg [31 : 0] pc;

	reg [31 : 0] rs1_data;
	reg [31 : 0] rs2_data;

	wire [4 : 0] rs1_num;
	wire [4 : 0] rs2_num;

	wire wb_reg;
	wire [4 : 0] rd_num;
	wire [31 : 0] rd_data;
	wire [6 : 0] opcode;
	wire [2 : 0] func3;

	wire br_taken;
	wire [`SEL_PC_WIDTH - 1 : 0] pc_sel;


	decode_execute decode_execute (
		.ir(ir), .pc(pc),
		.rs1_data(rs1_data), .rs2_data(rs2_data),
		.rs1_num(rs1_num), .rs2_num(rs2_num),
		.opcode(opcode), .func3(func3),
		.wb_reg(wb_reg), .rd_num(rd_num), .rd_data(rd_data),
		.pc_sel(pc_sel), .br_taken(br_taken)
	);


	initial begin
		pc = 32'h100;
		rs1_data = 32'b1000;
		rs2_data = 32'b0011;
		#(STEP * 10)
		
		// ADD r3, r1, r2
		ir = 32'b0000000_00010_00001_000_00011_0110011;
		#(STEP)
		$display("[ADD]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);

		// XORI r2, r1, imm
		ir = 32'b000000111111_00001_100_00010_0010011;
		#(STEP)
		$display("[XORI]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);

		// LW r2, imm(r1)
		ir = 32'b000000101010_00001_010_00010_0000011;
		#(STEP)
		$display("[LW]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);

		// BNE r1, r2, pc + imm
		ir = 32'b0_000000_00010_00001_001_1010_0_1100011;
		#(STEP)
		$display("[BNE]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);

		// LUI r1, imm
		ir = 32'b10101010101010101010_00001_0110111;
		#(STEP)
		$display("[LUI]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);

		// AUIPC r1, imm
		ir = 32'b10101010101010101010_00001_0010111;
		#(STEP)
		$display("[AUIPC]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);

		// JAL r2, imm
		ir = 32'b0_1010101010_0_00000000_00010_1101111;
		#(STEP)
		$display("[JAL]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);

		// JALR rd, rs1, imm
		ir = 32'b101010101010_00001_000_00010_1100111;
		#(STEP)
		$display("[JALR]rs1:%h, rs2:%h, wb:%b, rd_num:%h, rd_data:%b", rs1_num, rs2_num, wb_reg, rd_num, rd_data);


		#(STEP * 100) $stop;
	end

endmodule // tb_decode_execute
