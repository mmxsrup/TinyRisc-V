module tb_memory ();

	localparam STEP = 10;

	parameter OP_STORE = 7'b0100011;
	parameter OP_LOAD  = 7'b0000011;
	parameter FUNC3_B = 3'b000; // sb, lb
	parameter FUNC3_H = 3'b001; // sh, lh
	parameter FUNC3_W = 3'b010; // sw, lw,
	parameter FUNC3_BU = 3'b100; // lbu
	parameter FUNC3_HU = 3'b101; // lhu

	reg clk;
	reg rst;

	reg [6 : 0] opcode;
	reg [2 : 0] func3;
	reg [31 : 0] alu_out;
	reg [31 : 0] rs2;

	wire [31 : 0] rdata;
	wire done;

	memory memory (
		.clk(clk), .rst(rst),
		.opcode(opcode), .func3(func3), .alu_out(alu_out), .rs2(rs2),
		.rdata(rdata), .done(done)
	);

	always begin
		clk = 0; #(STEP / 2);
		clk = 1; #(STEP / 2);
	end


	initial begin
		rst = 0;
		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		opcode = OP_LOAD; func3 = FUNC3_B; alu_out = 1<<2; rs2 = 32'b0; // LB 
		#(STEP)
		$display("[LB] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_H; alu_out = 1<<2; rs2 = 32'b0; // LH
		#(STEP)
		$display("[LH] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_W; alu_out = 1<<2; rs2 = 32'b0; // LW
		#(STEP)
		$display("[LW] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_BU; alu_out = 1<<2; rs2 = 32'b0; // LBU
		#(STEP)
		$display("[LBU] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_HU; alu_out = 1<<2; rs2 = 32'b0; // LHU
		#(STEP)
		$display("[LHU] rdata:%h, done:%b", rdata, done);


		// STORE
		opcode = OP_STORE; func3 = FUNC3_B; alu_out = 1<<2; rs2 = 32'hff; // SB
		#(STEP)
		$display("[SB] rdata:%h, done:%b", rdata, done);


		opcode = OP_LOAD; func3 = FUNC3_B; alu_out = 1<<2; rs2 = 32'b0; // LB 
		#(STEP)
		$display("[LB] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_H; alu_out = 1<<2; rs2 = 32'b0; // LH
		#(STEP)
		$display("[LH] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_W; alu_out = 1<<2; rs2 = 32'b0; // LW
		#(STEP)
		$display("[LW] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_BU; alu_out = 1<<2; rs2 = 32'b0; // LBU
		#(STEP)
		$display("[LBU] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_HU; alu_out = 1<<2; rs2 = 32'b0; // LHU
		#(STEP)
		$display("[LHU] rdata:%h, done:%b", rdata, done);


		// STORE
		opcode = OP_STORE; func3 = FUNC3_H; alu_out = 1<<2; rs2 = 32'hdead; // SH
		#(STEP)
		$display("[SH] rdata:%h, done:%b", rdata, done);


		opcode = OP_LOAD; func3 = FUNC3_B; alu_out = 1<<2; rs2 = 32'b0; // LB 
		#(STEP)
		$display("[LB] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_H; alu_out = 1<<2; rs2 = 32'b0; // LH
		#(STEP)
		$display("[LH] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_W; alu_out = 1<<2; rs2 = 32'b0; // LW
		#(STEP)
		$display("[LW] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_BU; alu_out = 1<<2; rs2 = 32'b0; // LBU
		#(STEP)
		$display("[LBU] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_HU; alu_out = 1<<2; rs2 = 32'b0; // LHU
		#(STEP)
		$display("[LHU] rdata:%h, done:%b", rdata, done);


		// STORE
		opcode = OP_STORE; func3 = FUNC3_W; alu_out = 1<<2; rs2 = 32'hdeadbeef; // SH
		#(STEP)
		$display("[SH] rdata:%h, done:%b", rdata, done);


		opcode = OP_LOAD; func3 = FUNC3_B; alu_out = 1<<2; rs2 = 32'b0; // LB 
		#(STEP)
		$display("[LB] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_H; alu_out = 1<<2; rs2 = 32'b0; // LH
		#(STEP)
		$display("[LH] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_W; alu_out = 1<<2; rs2 = 32'b0; // LW
		#(STEP)
		$display("[LW] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_BU; alu_out = 1<<2; rs2 = 32'b0; // LBU
		#(STEP)
		$display("[LBU] rdata:%h, done:%b", rdata, done);

		opcode = OP_LOAD; func3 = FUNC3_HU; alu_out = 1<<2; rs2 = 32'b0; // LHU
		#(STEP)
		$display("[LHU] rdata:%h, done:%b", rdata, done);


		#(STEP * 100) $stop;
	end


endmodule // tb_memory
