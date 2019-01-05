module memory (
	input clk,
	input rst,

	// from execute
	input [6 : 0] opcode,
	input [2 : 0] func3,
	input [31 : 0] alu_out,
	input [31 : 0] rs2,

	// to dcache
	input [31 : 0] dcache_addr,
	input dcache_wreq, // write request
	input dcache_rreq, // read request
	input [31 : 0] dcache_wdata, // write data
	input [3 : 0] dcache_byte_enable,
	// from dcache
	output dcache_wvalid,
	output [31 : 0] dcache_rdata,
	output dcache_rvalid,

	// to writeback
	output reg [31 : 0] rdata, // read data
	// to controller
	output done // load or finish done
);


	parameter OP_STORE = 7'b0100011;
	parameter OP_LOAD  = 7'b0000011;
	parameter FUNC3_B = 3'b000; // sb, lb
	parameter FUNC3_H = 3'b001; // sh, lh
	parameter FUNC3_W = 3'b010; // sw, lw,
	parameter FUNC3_BU = 3'b100; // lbu
	parameter FUNC3_HU = 3'b101; // lhu


	assign dcache_addr = alu_out;
	assign dcache_wreq = (opcode == OP_STORE) ? 1 : 0;
	assign dcache_rreq = (opcode == OP_LOAD)  ? 1 : 0;
	assign dcache_wdata = (opcode == OP_STORE) ? rs2 : 32'b0;
	assign dcache_byte_enable = (func3 == FUNC3_B || func3 == FUNC3_BU) ? 4'b0001 :
							  (func3 == FUNC3_H || func3 == FUNC3_HU) ? 4'b0011 :
							  (func3 == FUNC3_W) ? 4'b1111 : 4'b0000;

	always @(*) begin
		case (func3)
			FUNC3_B  : rdata = { {25{dcache_rdata[7]}}, dcache_rdata[6 : 0] };
			FUNC3_H  : rdata = { {17{dcache_rdata[15]}}, dcache_rdata[14 : 0]};
			FUNC3_W  : rdata = dcache_rdata;
			FUNC3_BU : rdata = { 24'b0, dcache_rdata[7 : 0] };
			FUNC3_HU : rdata = { 16'b0, dcache_rdata[15 : 0]};
		endcase // func3
	end

	assign done = ((dcache_wreq && dcache_wvalid) || (dcache_rreq && dcache_rvalid) || (!dcache_wreq && !dcache_rreq)) ? 1 : 0;


endmodule // memory
