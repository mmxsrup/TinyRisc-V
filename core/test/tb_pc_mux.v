`include "param_pc_mux.vh"

module tb_pc_mux ();

	localparam STEP = 10;

	reg [31 : 0] pc;	
	reg [31 : 0] rs1;
	reg [31 : 0] imm;
	reg [`PC_SEL_WIDTH - 1 : 0] pc_sel;
	reg taken;
	reg stall;
	wire [31 : 0] next_pc;
	
	pc_mux pc_mux(
		.pc(pc),
		.rs1(rs1), .imm(imm),
		.pc_sel(pc_sel), .taken(taken), .stall(stall),
		.next_pc(next_pc)
	);


	initial begin
		pc = 32'h0;
		rs1 = 32'h8;
		imm = 32'h8;
		pc_sel = `PC_SEL_NONE;
		taken = 0;
		stall = 0;
		#(STEP * 10)

		// pc = pc + 4
		for (integer i = 0; i < 4; i = i + 1) begin
			#(STEP) pc_sel = `PC_SEL_ADD4;
			$display("next_pc: %h", next_pc);
			pc = next_pc;
		end

		// pc = pc + imm
		#(STEP) pc_sel = `PC_SEL_JAL; taken = 1;
		$display("next_pc: %h", next_pc);
		pc = next_pc;

		// pc = rs1 + imm;
		#(STEP) pc_sel = `PC_SEL_JALR; taken = 1;
		$display("next_pc: %h", next_pc);
		pc = next_pc;

		// pc = pc
		for (integer i = 0; i < 4; i = i + 1) begin
			#(STEP) stall = 1; pc_sel = `PC_SEL_ADD4; taken = 0;
			$display("next_pc: %h", next_pc);
			pc = next_pc;
		end

		#(STEP * 100) $stop;
	end

endmodule // module tb_mux_pc
