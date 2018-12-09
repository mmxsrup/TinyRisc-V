module regfile
(
	input clk,
	input rst,

	// from controller
	input w_enable,

	// from decoder
	input [4 : 0] rs1_num,
	input [4 : 0] rs2_num,
	input [4 : 0] rd_num,

	// from alu
	input [31 : 0] rd_data,

	// to alu src mux
	output [31 : 0] rs1_data,
	output [31 : 0] rs2_data
);
	
	// 	general registers
	reg [31 : 0] datas[31 : 0];

	initial begin
		for (integer i = 0; i < 32; i = i + 1) begin
			datas[i] = 32'h0;
		end
	end

	assign rs1_data = (rs1_num == 0) ? 32'h0 : datas[rs1_num];
	assign rs2_data = (rs2_num == 0) ? 32'h0 : datas[rs2_num];


	// write back
	always @(posedge clk) begin
		if (rst) begin
			for (integer i = 0; i < 32; i = i + 1) begin
				datas[i] = 32'h0;
			end
		end else if (w_enable && rd_num != 0) begin
			datas[rd_num] <= rd_data;
		end
	end // always @(posedge clk) 


endmodule // regfile