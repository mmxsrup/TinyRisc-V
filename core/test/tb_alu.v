`include "param_alu_op.vh"

module tb_mux_pc ();

	localparam STEP = 10;

	reg [`ALU_OP_WIDTH - 1 : 0] operator;
	reg [31 : 0] imm;
	reg [31 : 0] operand1;
	reg [31 : 0] operand2;
	wire [31 : 0] out;

	alu alu (
		.operator(operator),
		.imm(imm), .operand1(operand1), .operand2(operand2),
		.out(out)
	);

	initial begin
		imm = 32'b10;
		operand1 = 32'b10101010;
		operand2 = 32'b11;
		#(STEP * 10)

		for (integer i = 0; i <= 14; i = i + 1) begin
			operator = i;
			#(STEP)
			$display("out: %b", out);
		end
		
		#(STEP * 100) $stop;
	end

endmodule // module tb_mux_pc
