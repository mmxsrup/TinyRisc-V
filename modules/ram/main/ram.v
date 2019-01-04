// ram and ram controller (4 byte arrignment)
`include "param_ram.vh"

module ram (
	input clk,
	input rst,

	// write
	input [`AWIDTH - 1 : 0] awaddr,
	input [`LWIDTH - 1 : 0] awlen,
	input awvalid,
	output reg awready,
	input [`DWIDTH - 1 : 0] wdata,
	output reg wvalid,
	input wready,
	output reg wlast,

	// read
	input [`AWIDTH - 1 : 0] araddr,
	input [`LWIDTH - 1 : 0] arlen,
	input arvalid,
	output reg arready,
	output reg [`DWIDTH - 1 : 0] rdata,
	output reg rvalid,
	input rready,
	output reg rlast
);

	parameter SWIDTH = 3;
	parameter IDLE = 3'h0;
	parameter WRITE = 3'h1;
	parameter READ = 3'h2;

	reg [`DWIDTH - 1 : 0] mem[0 : `WORDS/4 - 1];
	reg [`AWIDTH - 1 : 0] waddr_reg;
	reg [`AWIDTH - 1 : 0] raddr_reg;
	reg [`DWIDTH - 1 : 0] wdata_reg;
	reg [SWIDTH - 1 : 0] state;

	initial $readmemh("mem_data.mem", mem);

	reg [`LWIDTH - 1 : 0] wcnt_reg;
	reg [`LWIDTH - 1 : 0] rcnt_reg;
	reg [`LWIDTH - 1 : 0] wcnt_done_reg;
	reg [`LWIDTH - 1 : 0] rcnt_done_reg;

	always @(posedge clk) begin
		if (rst) begin
			state <= IDLE;
			waddr_reg <= 0;
			raddr_reg <= 0;
			awready <= 0;
			wvalid <= 0;
			arready <= 0;
			rdata <= 0;
			rvalid <= 0;
			wcnt_reg <= 0;
			rcnt_reg <= 0;
			wcnt_done_reg <= 0;
			rcnt_done_reg <= 0;
			wlast <= 0;
			rlast <= 0;
		end else begin
			case (state)
				IDLE: begin
					awready <= 1;
					arready <= 1;
					wvalid <= 0;
					rvalid <= 0;
					wcnt_reg <= 0;
					rcnt_reg <= 0;
					wcnt_done_reg <= 0;
					rcnt_done_reg <= 0;

					if (awvalid && awready) begin
						state <= WRITE;
						waddr_reg <= awaddr;
						wcnt_reg  <= awlen; 
					end else if (arvalid && arready) begin
						state <= READ;
						raddr_reg <= araddr;
						rcnt_reg  <= arlen;
					end
				end
				WRITE: begin
					awready <= 0;
					wvalid <= 1;
					if (wcnt_reg == wcnt_done_reg) begin
						wlast <= 0;
						state <= IDLE;
					end else begin
						if (wready) begin
							mem[(waddr_reg >> 2) + wcnt_done_reg] <= wdata;
							if (wcnt_reg - 1 == wcnt_done_reg) wlast <= 1;
							wcnt_done_reg <= wcnt_done_reg + 1;
						end
					end
				end
				READ: begin
					arready <= 0;
					rvalid <= 1;
					if (rcnt_reg == rcnt_done_reg) begin
						rlast <= 0;
						state <= IDLE;
					end else begin
						if (rready) begin
							rdata <= mem[(raddr_reg >> 2) + rcnt_done_reg];
							if (rcnt_reg - 1 == rcnt_done_reg) rlast <= 1;
							rcnt_done_reg <= rcnt_done_reg + 1;
						end
					end
				end
				default : state <= IDLE;
			endcase // state
		end
	end


endmodule // ram
