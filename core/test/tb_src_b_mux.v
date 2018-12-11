`include "param_src_b_mux.vh"

module tb_src_b_mux ();

	localparam STEP = 10;

	reg [31 : 0] rs2_data;
	reg [31 : 0] imm;
	reg [`SEL_SRC_B_WIDTH - 1 : 0] select;
	wire [31 : 0] alu_src_b;

	src_b_mux src_b_mux (
		.rs2_data(rs2_data),
		.imm(imm), .select(select),
		.alu_src_b(alu_src_b)
	);

	initial begin
		rs2_data = 32'b1010;
		imm = 32'b100;
		#(STEP * 10)

		for (integer i = 0; i <= 4; i = i + 1) begin
			select = i;
			#(STEP)
			$display("alu_src_b: %b", alu_src_b);
		end

		#(STEP * 100) $stop;
	end

endmodule // tb_src_b_mux
