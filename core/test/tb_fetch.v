`include "param_pc_mux.vh"

module tb_fetch ();

	localparam STEP = 10;

	reg clk;
	reg rst;

	reg [31 : 0] pc;
	reg stall;
	reg [31 : 0] rs1;
	reg [31 : 0] imm;
	reg [31 : 0] pc_sel;
	reg taken;
	wire [31 : 0] ir_code;
	wire [31 : 0] next_pc;

	fetch fetch (
		.clk(clk), .rst(rst),
		.pc(pc), .stall(stall),
		.rs1(rs1), .imm(imm), .pc_sel(pc_sel),
		.taken(taken),
		.ir_code(ir_code), .next_pc(next_pc)
	);

	always begin
		clk = 0; #(STEP / 2);
		clk = 1; #(STEP / 2);
	end

	initial begin
		rst = 0;

		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		pc = 32'h0;
		rs1 = 32'h100;
		imm = 32'h100;
		pc_sel = `PC_SEL_ADD4;
		taken = 0;
		stall = 0;

		for (integer i = 0; i < 4; i = i + 1) begin
			#(STEP)
			$display("ir_code: %h next_pc: %h", ir_code, next_pc);
			pc = next_pc;
		end

		pc_sel = `PC_SEL_JAL;
		#(STEP);
		$display("ir_code: %h next_pc: %h", ir_code, next_pc);
		pc = next_pc;

		pc_sel = `PC_SEL_JALR;
		#(STEP);
		$display("ir_code: %h next_pc: %h", ir_code, next_pc);
		pc = next_pc;

		pc_sel = `PC_SEL_ADD4; taken = 1;
		#(STEP);
		$display("ir_code: %h next_pc: %h", ir_code, next_pc);
		pc = next_pc;

		pc_sel = `PC_SEL_ADD4; taken = 0; stall = 1;
		for (integer i = 0; i < 4; i = i + 1) begin
			#(STEP)
			$display("ir_code: %h next_pc: %h", ir_code, next_pc);
			pc = next_pc;
		end

		// Cache Miss
		pc_sel = `PC_SEL_ADD4; taken = 0; stall = 0;
		pc = 32'h100000;
		#(STEP)
		$display("ir_code: %h next_pc: %h", ir_code, next_pc); // NOP

		#(STEP * 100) $stop;
	end

endmodule // tb_fetch
