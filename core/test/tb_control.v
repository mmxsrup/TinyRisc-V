module tb_control ();

	localparam STEP = 10;

	reg clk;
	reg rst;

	reg memory_done_i;
	reg [`SEL_PC_WIDTH - 1 : 0] pc_sel_i;
	reg br_taken_i;
	reg [31 : 0] ir_i;
	reg [31 : 0] next_pc_i;

	wire fetch_stall_o;
	wire [`SEL_PC_WIDTH - 1 : 0] pc_sel_o;
	wire br_taken_o;
	wire [31 : 0] next_pc_o;


	control control (
		.clk(clk), .rst(rst),
		.memory_done_i(memory_done_i), .pc_sel_i(pc_sel_i),
		.br_taken_i(br_taken_i), .ir_i(ir_i), .next_pc_i(next_pc_i),
		.fetch_stall_o(fetch_stall_o), .pc_sel_o(pc_sel_o),
		.br_taken_o(br_taken_o), .next_pc_o(next_pc_o)
	);


	always begin
		clk = 1; #(STEP / 2);
		clk = 0; #(STEP / 2);
	end

	initial begin
		memory_done_i = 0;
		pc_sel_i = 0;
		br_taken_i = 0;
		ir_i = 0;
		next_pc_i = 0;
		
		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		$display("stall:%b, pc_sel:%b, br_taken:%b, next_pc:%h",
			fetch_stall_o, pc_sel_o, br_taken_o, next_pc_o);

		#(STEP * 100) $stop;
	end

endmodule // tb_control
