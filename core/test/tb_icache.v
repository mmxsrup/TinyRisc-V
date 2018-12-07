module tb_icache ();

	localparam STEP = 10;

	reg clk;
	reg rst;
	reg [31 : 0] addr;
	reg req;
	wire [31 : 0] data;
	wire valid;

	icache icache(
		.clk(clk), .rst(rst),
		.addr(addr), .req(req),
		.data(data), .valid(valid)
	);

	always begin
		clk = 0; #(STEP / 2);
		clk = 1; #(STEP / 2);
	end

	initial begin
		rst = 0;
		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		// HIT
		for (integer i = 0; i < 4096; i = i + 1) begin
			#(STEP)
			addr = i << 2; req = 1;
			#(STEP)
			$display("data: %h, valid, %h", data, valid);
		end

		#(STEP * 100) $stop;
	end

endmodule // module tb_icache
