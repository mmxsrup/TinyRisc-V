`include "param_src_a_mux.vh"

module tb_src_a_mux ();

	localparam STEP = 10;

	reg [31 : 0] pc;
	reg [31 : 0] rs1_data;
	reg [31 : 0] imm;
	reg [`SEL_SRC_A_WIDTH - 1 : 0] select;
	wire [31 : 0] alu_src_a;

	src_a_mux src_a_mux (
		.pc(pc),
		.rs1_data(rs1_data),
		.imm(imm), .select(select),
		.alu_src_a(alu_src_a)
	);

	initial begin
		pc = 32'b100000;
		rs1_data = 32'b1010;
		imm = 32'b100;
		#(STEP * 10)

		for (integer i = 0; i <= 3; i = i + 1) begin
			select = i;
			#(STEP)
			$display("alu_src_a: %b", alu_src_a);
		end

		#(STEP * 100) $stop;
	end

endmodule // tb_src_a_mux
