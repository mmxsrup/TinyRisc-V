module tb_datapath ();

	localparam STEP = 10;

	reg clk;
	reg rst;
	
	reg c_fetch_stall;
	reg [`SEL_PC_WIDTH - 1 : 0] c_pc_sel;
	reg c_br_taken;
	reg [31 : 0] c_next_pc;

	wire memory_done;
	wire [`SEL_PC_WIDTH - 1 : 0] pc_sel;
	wire br_taken;
	wire [31 : 0] ir;
	wire [31 : 0] next_pc;


	datapath datapath (
		.clk(clk), .rst(rst),
		.c_fetch_stall(c_fetch_stall), .c_pc_sel(c_pc_sel),
		.c_br_taken(c_br_taken), .c_next_pc(c_next_pc),
		.memory_done(memory_done), .pc_sel(pc_sel),
		.br_taken(br_taken), .ir(ir), .next_pc(next_pc)
	);


	always begin
		clk = 1; #(STEP / 2);
		clk = 0; #(STEP / 2);
	end

	initial begin
		rst = 0;
		c_fetch_stall = 0;
		c_pc_sel = 0;
		c_br_taken = 0;
		c_next_pc = 0;
		
		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		#(STEP * 100) $stop;
	end

endmodule // tb_datapath
