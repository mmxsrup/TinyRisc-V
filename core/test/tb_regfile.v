module tb_regfile ();

	localparam STEP = 10;

	reg clk;
	reg rst;

	reg w_enable;
	reg [4 : 0] rs1_num;
	reg [4 : 0] rs2_num;
	reg [4 : 0] rd_num;
	reg [31 : 0] rd_data;
	wire [31 : 0] rs1_data;
	wire [31 : 0] rs2_data;


	regfile regfile (
		.clk(clk), .rst(rst),
		.w_enable(w_enable),
		.rs1_num(rs1_num), .rs2_num(rs2_num), .rd_num(rd_num),
		.rd_data(rd_data),
		.rs1_data(rs1_data), .rs2_data(rs2_data)
	);

	always begin
		clk = 0; #(STEP / 2);
		clk = 1; #(STEP / 2);
	end

	initial begin
		rst = 0;
		w_enable = 0;

		#(STEP * 10)
		#(STEP * 10) rst = 0;

		rs1_num = 5'b00001;
		rs2_num = 5'b00010;
		rd_num = 5'b00011;
		rd_data = 32'b1010;

		#(STEP)
		$display("rs1_data: %h rs2_data: %h", rs1_data, rs2_data);

		w_enable = 1;
		#(STEP)
		$display("rs1_data: %h rs2_data: %h", rs1_data, rs2_data);

		rs1_num = 5'b00011;
		#(STEP)
		$display("rs1_data: %h rs2_data: %h", rs1_data, rs2_data);

		#(STEP * 100) $stop;
	end

endmodule // tb_regfile
