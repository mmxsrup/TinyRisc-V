`include "param_pc_mux.vh"
`include "param_ram.vh"

module fetch (
	input clk,
	input rst,

	// from controller
	input [31 : 0] pc,
	input stall,

	// from decoder
	input [31 : 0] rs1,
	input [31 : 0] imm,
	input [`SEL_PC_WIDTH - 1 : 0] pc_sel,

	// from br_cond
	input taken,

	// from csr_file
	input [31 : 0] mtvec,
	input [31 : 0] mepc,

	// to decoder
	output [31 : 0] ir_code,
	// to controller
	output [31 : 0] next_pc,


	// write
	output [`AWIDTH - 1 : 0] ram_awaddr,
	output [`LWIDTH - 1 : 0] ram_awlen,
	output ram_awvalid,
	input ram_awready,
	output [`DWIDTH - 1 : 0] ram_wdata,
	input ram_wvalid,
	output ram_wready,
	input ram_wlast,
	// read
	output [`AWIDTH - 1 : 0] ram_araddr,
	output [`LWIDTH - 1 : 0] ram_arlen,
	output ram_arvalid,
	input ram_arready,
	input [`DWIDTH - 1 : 0] ram_rdata,
	input ram_rvalid,
	output ram_rready,
	input ram_rlast
);

	parameter STATE_SIZE = 2;
	parameter IDLE = 2'b00;
	parameter RUN = 2'b01;
	parameter WAIT = 2'b10;

	parameter NOP = 32'b00000000_00000000_00000000_00010011;

	reg [STATE_SIZE - 1 : 0] state;

	// from icache
	wire [31 : 0] icache_data;
	wire icache_valid;
	// to icache
	wire [31 : 0] icache_addr;
	wire icache_req;

	// from pc_mux
	wire [31 : 0] pc_mux_out;

	assign ir_code = (icache_valid) ? icache_data : NOP;
	assign icache_addr = pc;
	assign next_pc = (icache_valid) ? pc_mux_out : pc;
	assign icache_req = (state == RUN) ? 1'b1 : 1'b0;


	pc_mux pc_mux (
		.pc(pc),
		.rs1(rs1), .imm(imm), .pc_sel(pc_sel),
		.taken(taken),
		.stall(stall),
		.mtvec(mtvec), .mepc(mepc),
		.next_pc(pc_mux_out)
	);

	icache icache (
		.clk(clk), .rst(rst),
		.addr(icache_addr), .req(icache_req),
		.data(icache_data), .valid(icache_valid),
		.ram_awaddr(ram_awaddr), .ram_awlen(ram_awlen), .ram_awvalid(ram_awvalid), .ram_awready(ram_awready),
		.ram_wdata(ram_wdata), .ram_wvalid(ram_wvalid), .ram_wready(ram_wready), .ram_wlast(ram_wlast),
		.ram_araddr(ram_araddr), .ram_arlen(ram_arlen), .ram_arvalid(ram_arvalid), .ram_arready(ram_arready),
		.ram_rdata(ram_rdata), .ram_rvalid(ram_rvalid), .ram_rready(ram_rready), .ram_rlast(ram_rlast)
	);


	always @(posedge clk) begin
		if (rst) begin
			state <= IDLE;
		end else begin
			case (state)
				IDLE : state <= RUN;
				RUN : begin
					if (icache_valid) state <= RUN; // Cache HIT
					else state <= WAIT; // Cache MISS
				end
				WAIT : begin // TODO
					if (icache_valid) state <= RUN;
				end
				default : state <= RUN;
			endcase // case (state)
		end
	end // always @(posedge clk) 

endmodule // fetch
