module writeback
(
	input [6 : 0] opcode,

	// from decode_execute
	input [31 : 0] alu_out,
	input wb_reg,

	// from memory
	input [31 : 0] dcache_out,
	input done,

	// to regfile
	output reg [31 : 0] wb_rd_data,
	output wb_enable
);

	parameter OP_LOAD = 7'b0000011;

	assign wb_enable = (done) ? wb_reg : 0;

	always @(*) begin
		if (wb_enable) begin
			if (opcode == OP_LOAD) wb_rd_data = dcache_out;
			else wb_rd_data = alu_out;
		end else begin
			wb_rd_data = 32'h0;
		end
	end // always @(*)

endmodule // writeback
