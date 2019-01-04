`include "param_ram.vh"

module memory (
	input clk,
	input rst,

	// from execute
	input [6 : 0] opcode,
	input [2 : 0] func3,
	input [31 : 0] alu_out,
	input [31 : 0] rs2,

	// to writeback
	output reg [31 : 0] rdata, // read data
	// to controller
	output done, // load or finish done


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


	// to dcache
	wire [31 : 0] addr;
	wire wreq;
	wire rreq;
	wire [31 : 0] wdata;
	wire [3 : 0] byte_enable;

	// from dcache
	wire wvalid;
	wire [31 : 0] tmp_rdata;
	wire rvalid;

	parameter OP_STORE = 7'b0100011;
	parameter OP_LOAD  = 7'b0000011;
	parameter FUNC3_B = 3'b000; // sb, lb
	parameter FUNC3_H = 3'b001; // sh, lh
	parameter FUNC3_W = 3'b010; // sw, lw,
	parameter FUNC3_BU = 3'b100; // lbu
	parameter FUNC3_HU = 3'b101; // lhu


	assign addr = alu_out;
	assign wreq = (opcode == OP_STORE) ? 1 : 0;
	assign rreq = (opcode == OP_LOAD)  ? 1 : 0;
	assign wdata = (opcode == OP_STORE) ? rs2 : 32'b0;
	assign byte_enable = (func3 == FUNC3_B || func3 == FUNC3_BU) ? 4'b0001 :
							  (func3 == FUNC3_H || func3 == FUNC3_HU) ? 4'b0011 :
							  (func3 == FUNC3_W) ? 4'b1111 : 4'b0000;

	always @(*) begin
		case (func3)
			FUNC3_B  : rdata = { {25{tmp_rdata[7]}}, tmp_rdata[6 : 0] };
			FUNC3_H  : rdata = { {17{tmp_rdata[15]}}, tmp_rdata[14 : 0]};
			FUNC3_W  : rdata = tmp_rdata;
			FUNC3_BU : rdata = { 24'b0, tmp_rdata[7 : 0] };
			FUNC3_HU : rdata = { 16'b0, tmp_rdata[15 : 0]};
		endcase // func3
	end

	assign done = ((wreq && wvalid) || (rreq && rvalid) || (!wreq && !rreq)) ? 1 : 0;

	dcache dcache (
		.clk(clk), .rst(rst),
		.addr(addr),
		.wreq(wreq), .rreq(rreq), 
		.wdata(wdata), .byte_enable(byte_enable),
		.wvalid(wvalid), .rdata(tmp_rdata), .rvalid(rvalid),
		.ram_awaddr(ram_awaddr), .ram_awlen(ram_awlen), .ram_awvalid(ram_awvalid), .ram_awready(ram_awready),
		.ram_wdata(ram_wdata), .ram_wvalid(ram_wvalid), .ram_wready(ram_wready), .ram_wlast(ram_wlast),
		.ram_araddr(ram_araddr), .ram_arlen(ram_arlen), .ram_arvalid(ram_arvalid), .ram_arready(ram_arready),
		.ram_rdata(ram_rdata), .ram_rvalid(ram_rvalid), .ram_rready(ram_rready), .ram_rlast(ram_rlast)
	);


endmodule // memory
