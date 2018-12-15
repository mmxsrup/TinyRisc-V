module tb_memory_writeback ();

	localparam STEP = 10;

	parameter OP_LOAD = 7'b0000011;
	parameter OP_STORE = 7'b0100011;
	parameter OP_BRANCH	 = 7'b1100011;
	parameter OP_IMM = 7'b0010011;
	parameter OP_OP = 7'b0110011;
	parameter OP_JUMP = 7'b1101111;

	parameter FUNC3_B = 3'b000; // sb, lb
	parameter FUNC3_H = 3'b001; // sh, lh
	parameter FUNC3_W = 3'b010; // sw, lw,
	parameter FUNC3_BU = 3'b100; // lbu
	parameter FUNC3_HU = 3'b101; // lhu


	reg clk;
	reg rst;
	
	reg [6 : 0]	 opcode;
	reg [2 : 0] func3;
	reg wb_reg;
	reg [4 : 0] rd_num;
	reg [31 : 0] alu_out;

	wire wb_enable;
	wire [4 : 0] wb_rd_num;
	wire [31 : 0] wb_rd_data;

	wire done;

	memory_writeback memory_writeback (
		.clk(clk), .rst(rst),
		.opcode(opcode), .func3(func3),
		.wb_reg(wb_reg), .rd_num(rd_num), .alu_out(alu_out),
		.wb_enable(wb_enable), .wb_rd_num(wb_rd_num), .wb_rd_data(wb_rd_data),
		.done(done)
	);


	always begin
		clk = 0; #(STEP / 2);
		clk = 1; #(STEP / 2);
	end

	initial begin
		rst = 0;
		rd_num = 5'b00001;
		alu_out = 32'h10000;

		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		opcode = OP_LOAD; func3 = FUNC3_B; wb_reg = 1;
		#(STEP)
		$display("[LB] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);

		opcode = OP_LOAD; func3 = FUNC3_H; wb_reg = 1;
		#(STEP)
		$display("[LH] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);

		opcode = OP_LOAD; func3 = FUNC3_W; wb_reg = 1;
		#(STEP)
		$display("[LW] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);

		opcode = OP_STORE; func3 = 0; wb_reg = 0;
		#(STEP)
		$display("[STORE] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);

		opcode = OP_BRANCH; func3 = 0; wb_reg = 0;
		#(STEP)
		$display("[BRANCH] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);

		opcode = OP_IMM; func3 = 0; wb_reg = 1;
		#(STEP)
		$display("[IMM] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);

		opcode = OP_OP; func3 = 0; wb_reg = 1;
		#(STEP)
		$display("[OP] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);

		opcode = OP_JUMP; func3 = 0; wb_reg = 1;
		#(STEP)
		$display("[JUMP] en:%b, num:%h, data:%h, done:%b", wb_enable, wb_rd_num, wb_rd_data, done);


		#(STEP * 100) $stop;
	end

endmodule // tb_fetch
