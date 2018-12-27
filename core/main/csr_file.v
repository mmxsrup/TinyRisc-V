// Control and Status Registers

module csr_file (
	input clk,
	input rst,

	// from controller	
	input w_enable,

	input [11 : 0] addr,
	input [31 : 0] wdata,
	output [31 : 0] rdata
);


	reg [31 : 0] csrs[4095 : 0];

	initial begin
		for (integer i = 0; i < 4096; i = i + 1) begin
			csrs[i] = 32'h0;
		end
	end

	// write back
	always @(posedge clk) begin
		if (rst) begin
			for (integer i = 0; i < 32; i = i + 1) begin
				csrs[i] = 32'h0;
			end
		end else if (w_enable) begin
			csrs[addr] <= rdata;
		end
	end // always @(posedge clk) 


endmodule // csr_file