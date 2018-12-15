module tb_writeback ();

	localparam STEP = 10;

	parameter OP_LOAD = 7'b0000011;
	parameter OP_STORE = 7'b0100011;
	parameter OP_BRANCH	 = 7'b1100011;
	parameter OP_IMM = 7'b0010011;
	parameter OP_OP = 7'b0110011;
	parameter OP_JUMP = 7'b1101111;

	reg [6 : 0] opcode;

	reg [31 : 0] alu_out;
	reg wb_reg;

	reg [31 : 0] dcache_out;
	reg done;

	wire [31 : 0] wb_rd_data;
	wire wb_enable;


	writeback writeback (
		.opcode(opcode),
		.alu_out(alu_out), .wb_reg(wb_reg),
		.dcache_out(dcache_out), .done(done),
		.wb_rd_data(wb_rd_data), .wb_enable(wb_enable)
	);
	

	initial begin
		alu_out = 32'h10000;
		dcache_out = 32'h101;
		done = 1;
		#(STEP * 10)
		
		opcode = OP_LOAD; wb_reg = 1;
		#(STEP)
		$display("[LOAD] data:%h, en:%b", wb_rd_data, wb_enable);

		opcode = OP_STORE; wb_reg = 0;
		#(STEP)
		$display("[STORE] data:%h, en:%b", wb_rd_data, wb_enable);

		opcode = OP_BRANCH; wb_reg = 0;
		#(STEP)
		$display("[BRANCH] data:%h, en:%b", wb_rd_data, wb_enable);

		opcode = OP_IMM; wb_reg = 1;
		#(STEP)
		$display("[IMM] data:%h, en:%b", wb_rd_data, wb_enable);

		opcode = OP_OP; wb_reg = 1;
		#(STEP)
		$display("[OP] data:%h, en:%b", wb_rd_data, wb_enable);

		opcode = OP_JUMP; wb_reg = 1;
		#(STEP)
		$display("[JUPM] data:%h, en:%b", wb_rd_data, wb_enable);


		#(STEP * 100) $stop;
	end

endmodule // tb_execute
